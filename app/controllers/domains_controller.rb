class DomainsController < ApplicationController
    def index

        host_name = params[:q]
        extensions = ['.net.ph', '.ph', '.com.ph', '.org.ph']
        suggested_names = []

        # If search domain is set
        if host_name.present?
            if check_domain(host_name)
                message = 'Congratulations your domain is available!'
                suggested_names.push(host_name)
                addClass = 'success'
            else
                message = host_name + ' is not available, You can select other name below.'
                if host_name.include?('.')
                    host_name = host_name.slice(0..(host_name.index('.') - 1))
                end
                # Loop in available extensions
                extensions.each do |ext|
                    if !(host_name + ext).eql?(params[:q])
                        if check_domain(host_name + ext)
                            suggested_names.push(host_name + ext)
                        end
                    end
                end
                addClass = 'warning'
            end
            # Render partial result
            render partial: "domains/partials/result", locals: { message: message, names: suggested_names, addClass: addClass }
        end

        
        # End of search

    end

    def check_domain(host_name)

        host      = "172.16.46.55"
        username  = "testblorbis"
        password  = "Password123"

        client = EPP::Client.new username, password, host

        domain    = host_name 
        command   = EPP::Domain::Check.new(domain)
        response  = client.check command
        check     = EPP::Domain::CheckResponse.new response

        check.available?

    end

    def new
    end

    def edit
    end

    def show
    end

    def destroy
    end

end
