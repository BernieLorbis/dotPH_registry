class UsersController < ApplicationController

	# before_action :authenticate_user!

	def login

		user_email 	  = params[:email]
		user_password = params[:password]

		user = User.where(email: user_email)

		if user.exists?
			if user.where(password: user_password)
				sign_in user.first
				success = true
			else
				message = 'You enter invalid password.'
				success = false
			end
		else
			message = 'Email address does not exists.'
			success = false
		end

		render json: {message: message, success: success}
	end

	def validate_session
		response = user_signed_in? ? true : false
		render inline: response.to_s
	end

	def register
		user = User.new
		user.email 			= params[:email]
		user.first_name 	= params[:firstname]
		user.last_name 		= params[:lastname]
		user.contact_number = params[:contact_number]
		user.password       = params[:password]

		if user.save
			render json: {success: true, message: 'Successfully registered!'}
		else
			render json: {success: false, message: 'Can`t Register!'}
		end
	end

	def logout
	end

	def create
	end

	def destroy
	end

	def payment
	end

end
