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
		user.email 					  = params[:email]
		user.first_name 			  = params[:firstname]
		user.last_name 				  = params[:lastname]
		user.contact_number 		  = params[:contact_number]
		user.password       		  = params[:password]

		if user.save
			render json: {success: true, message: 'Successfully registered!'}
		else
			render json: {success: false, message: user}
		end
	end

	def registrant
		# handle
		timestamp = '%10.6f' % Time.now.to_f
		handle = timestamp.sub('.', '')
	end

	def logout
		sign_out
		redirect_to root_path
	end

	def success
		@user = User.find(current_user.id)
		@domain = Domain.where(user_id: @user.id).where(order_id: params[:order_id]).first
		@payment = PaymentTransaction.where(order_id: params[:order_id]).first
	end


	# register page
	def create
	end

	def destroy
	end

	def payment
	end

end
