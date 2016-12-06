class AccountsController < ApplicationController
	before_action :get_account, only: [:edit, :update, :update_balance]
	after_action :redirect_to_user

	def edit
	end

	def update
		if @account.update_attributes account_params
			flash[:notice] = "Account information eddited"
		else
			flash[:notice] = @account.errors.full_messages.to_sentence
		end
	end

	def new_balance
		@account = current_user.account
	end

	def update_balance
		@account.update_balance params[:balance].to_f
	end

	private
	def account_params
		params.require(:account).permit(:card_number, :card_holder_first_name, :card_holder_second_name)
	end

	def get_account
		@account = current_user.account
	end

	def redirect_to_user
		redirect_to user_root_path
	end
end
