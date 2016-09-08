class UsersController < ApplicationController
	before_action :find_user, except: :index

	def index
		@users = User.all
	end

	def show
		@own_comments = @user.commented_on
		@comments = @user.comments
		@projects = @user.projects.where(published: true)
	end

	def update

	end

	private
	def find_user
		@user = User.find(params[:id])
	end
end
