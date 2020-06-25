class PaymentsController < ApplicationController  
    require 'paypal-sdk-rest'
    include PayPal::SDK::REST
    protect_from_forgery :except => [:create, :execute]

    PayPal::SDK::REST.set_config(
        :mode => "sandbox",
        :client_id => "AW4I8tHeTC_xdRHrcvpgD2RgBHC-QlhnNO3uP_ZyUjpCanJbxbMvM3qI9nbnSv2ZtrMf_jNOZMuJV055",
        :client_secret => "EG_reR8BdsdgdW59kWzqRL79fVCbBmqX3-S3UaUwf1WF29oNnzITagp-YTXqrHyfWYCklAedLi2LeqWm")

    def create

        domain = params[:domain]
        period = params[:period]

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
        # Implement payment execution
        payment_id = params[:payment_id]
        payer_id   = params[:payer_id]

        period = params[:period]
        domain_name = params[:domain]

        payment = Payment.find(payment_id)

        if payment.execute(:payer_id => payer_id)
            # Save to database using EPP [Model for now]
            domain = Domain.new
            domain.name = domain_name
            domain.reg_date = Time.now
            domain.exp_date = (Time.now + (period.to_i).year)
            domain.user_id = 1

            domain.save
        end

        state = payment.state

        render json: {payment_state: state} # Fill in the the payment state
    end

end