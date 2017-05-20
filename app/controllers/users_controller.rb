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
		@users_rating = @user.users_rating
		@result_rating = @user.result_rating
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
