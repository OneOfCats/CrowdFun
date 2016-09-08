class PersonsController < ApplicationController
  def profile
  	@balance = current_user.account.balance
  	@projects = current_user.projects
  	@user = current_user
  end
end
