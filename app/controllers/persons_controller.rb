class PersonsController < ApplicationController
  def profile
  	@balance = current_user.account.balance
  end
end
