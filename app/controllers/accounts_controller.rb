class AccountsController < ApplicationController
	before_action :get_account, only: [:edit, :update]

	def edit
	end

	def update
		unless @account.update_attributes account_params
			flash[:notice] = @account.errors.full_messages.to_sentence
		end
		redirect_to user_root_url
	end

	private
	def account_params
		params.require(:account).permit(:card_number, :card_holder_first_name, :card_holder_second_name)
	end

	def get_account
		@account = current_user.account
	end
end
