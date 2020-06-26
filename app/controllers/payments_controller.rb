class PaymentsController < ApplicationController  
    require 'paypal-sdk-rest'
    include PayPal::SDK::REST
    protect_from_forgery :except => [:create, :execute]

    PayPal::SDK::REST.set_config(
        :mode => "sandbox",
        :client_id => "AW4I8tHeTC_xdRHrcvpgD2RgBHC-QlhnNO3uP_ZyUjpCanJbxbMvM3qI9nbnSv2ZtrMf_jNOZMuJV055",
        :client_secret => "EG_reR8BdsdgdW59kWzqRL79fVCbBmqX3-S3UaUwf1WF29oNnzITagp-YTXqrHyfWYCklAedLi2LeqWm")

    def client
        host      = "172.16.46.55"
        username  = "testblorbis"
        password  = "Password123"

        client = EPP::Client.new username, password, host
    end

    def create

        domain         = params[:domain]
        period         = params[:period]

        # Implement payment creation
        @payment = Payment.new({
            :intent =>  "sale",
            :payer =>  {
                :payment_method =>  "paypal" 
            },
            :redirect_urls => {
                :return_url => "http://localhost:3000/payment/execute",
                :cancel_url => "http://localhost:3000/" 
            },
            :transactions =>  [{
                :item_list => {
                    :items => [{
                        :name => "Domain registration for #{domain.to_s} for #{period.to_s} year(s)",
                        :sku => "Domain registration for #{domain.to_s} for #{period.to_s} year(s)",
                        :price => 35,
                        :currency => "USD",
                        :quantity => period
                    }]
                },
                :amount =>  {
                    :total =>  (35 * period.to_i),
                    :currency =>  "USD" 
                },
                :description =>  "This is the payment transaction description." 
            }]
        })

        if @payment.create
            @payment.id     # Payment Id
        else
            @payment.error  # Error Hash
        end

        render json: {id: @payment.id} # Fill in the the Payment ID

    end

    def execute
        payment_id  = params[:payment_id]
        payer_id    = params[:payer_id]
        period      = params[:period]
        domain_name = params[:domain]

        payment = Payment.find(payment_id)

        if payment.execute(:payer_id => payer_id)
            # CONTACT
            timestamp = '%10.6f' % Time.now.to_f
            handle = timestamp.sub('.', '')
            # check if exists
            command  = EPP::Contact::Check.new handle
            response = client.check command
            create_contact  = EPP::Contact::CheckResponse.new response

            # Store to EPP
            create_params =     {
                postal_info_int: {
                    name: "#{current_user.first_name} #{current_user.last_name}",
                    org:  params[:organization],
                    addr: {
                        street: params[:address],
                        city: "test city",
                        sp: "test state",
                        pc: "1234",
                        cc: "PH"
                    }
                },
                postal_info: {
                    name: "#{current_user.first_name} #{current_user.last_name}",
                    org:  params[:organization],
                    addr: {
                        street: params[:address],
                        city: "test city",
                        sp: "test state",
                        pc: "1234",
                        cc: "PH"
                    }
                },
                voice:  current_user.contact_number,
                fax:  nil,
                email:  current_user.email,
                auth_info:  { pw: "ABC123" }
            }

            create_contact = client.create(EPP::Contact::Create.new handle, create_params)
            create_host    = client.create(EPP::Host::Create.new params[:domain])
            create_params = {
                period: "#{params[:period].to_s}y" ,
                registrant: handle,
                auth_info:  { pw: "ABC123" },
                nameservers: [params[:domain]]
            }
            create_domain = client.create(EPP::Domain::Create.new params[:domain], create_params)
            # Store registrant
            registrant                = Registrant.new()
            registrant.user_id        = current_user.id
            registrant.handle         = handle
            registrant.address        = params[:address]
            registrant.contact_number = current_user.contact_number
            registrant.save

            r_id = registrant.id
            # Save orders
            orders         = ::Order.new()
            orders.user_id = current_user.id
            orders.save

            o_id = orders.id
            # Save domain
            domain               = Domain.new()
            domain.name          = params[:domain]
            domain.reg_date      = Time.now
            domain.exp_date      = (Time.now + (params[:period].to_i).year)
            domain.user_id       = current_user.id
            domain.order_id      = o_id
            domain.period        = params[:period]
            domain.save
            # Save transactions
            transaction            = PaymentTransaction.new()
            transaction.order_id   = o_id
            transaction.payment_id = payment_id
            transaction.save
 
        end

        state = payment.state

        render json: {payment_state: state, order_id: o_id} # Fill in the the payment state
    end


end