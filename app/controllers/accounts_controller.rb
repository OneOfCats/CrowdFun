class AccountsController < ApplicationController
	before_action :get_account, only: [:edit, :update]

	def edit
	end

	def update
		if @account.update_attributes account_params
			flash[:notice] = "Account information eddited"
		else
			flash[:notice] = @account.errors.full_messages.to_sentence
		end
		redirect_to edit_account_path
	end

	def new_balance
		@account = current_user.account
	end

	def update_balance
		@amount = params[:account][:balance].to_f
		current_user.account.balance += @amount
	end

	private
	def account_params
		params.require(:account).permit(:card_number, :card_holder_first_name, :card_holder_second_name)
	end

	def get_account
		@account = current_user.account
	end
end
