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
		@projects_rating = @user.projects_rating
		@resulting_rating = @user.resulting_rating
	end

	def update

	end

	private
	def find_user
		@user = User.find(params[:id])
	end
end
