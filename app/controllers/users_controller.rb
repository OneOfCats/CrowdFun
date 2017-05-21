class UsersController < ApplicationController
	before_action :find_user, except: :index

	def index
		@users = User.all
	end

	def show
		@own_comments = @user.commented_on
		@comments = @user.comments
		@projects = @user.projects.where(published: true)
		@demand_rating = @user.demand_rating
		@preview_rating = @user.preview_rating
		@resulting_rating = @user.resulting_rating
		@satisfaction_rating = @user.satisfaction_rating
		@admins_rating = @user.admins_rating
	end

	def update
		current_user.update_attributes attributes_for_update

		redirect_to user_root_path
	end

	private
	def find_user
		@user = User.find(params[:id])
	end

	def attributes_for_update
		return params.require(:user).permit(:avatar)
	end
end
