class DomainsController < ApplicationController
    def index

        host_name = params[:q]
        extensions = ['.net.ph', '.ph', '.com.ph', '.org.ph']
        suggested_names = []

        host      = "172.16.46.55"
        username  = "testblorbis"
        password  = "Password123"

        client = EPP::Client.new username, password, host

        # CONTACT
        timestamp = '%10.6f' % Time.now.to_f
        handle = timestamp.sub('.', '')

        command   = EPP::Host::Check.new host_name
        response  = client.check command
        check     = EPP::Host::CheckResponse.new response

        if host_name.present?
            if check.available?
                message = 'Congratulations your domain is available!'
                suggested_names.push(host_name)
                render partial: "domains/partials/result", locals: { message: message, names: suggested_names, addClass: 'success' }
            else
                message = host_name + ' is not available, You can select other name below.'

                if host_name.include?('.')
                    host_name = host_name.chop.chop.chop
                else
                    host_name = host_name
                end

                extensions.each do |ext|
                    if !(host_name + ext).eql?(params[:q])
                        suggested_names.push(host_name + ext)
                    end
                end

                render partial: "domains/partials/result", locals: { message: message, names: suggested_names, addClass: 'warning' }
            end
        else

        end

        

    end

    def new
    end

    def edit
    end

    def show
    end

    def destroy
    end

    def search

        @message = nil

        host      = "172.16.46.55"
        username  = "testblorbis"
        password  = "Password123"

        host_name = params[:q] # wildcard

        client = EPP::Client.new username, password, host

        # CONTACT
        timestamp = '%10.6f' % Time.now.to_f
        handle = timestamp.sub('.', '')

        command   = EPP::Host::Check.new host_name
        response  = client.check command
        check     = EPP::Host::CheckResponse.new response

        if check.available?
            
        else
            @message = 'unavailable'
            render :index
        end

    end
end
