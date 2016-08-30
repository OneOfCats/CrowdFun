class UsersController < ApplicationController
	before_action :find_user, except: :index

	def index
		@users = User.all
	end

	def show
		@own_comments = @user.commented_on
		@comments = @user.comments
	end

	def update
		if params[:user][:comments]
			@comment = @user.comments.new comment_params
			if current_user
				@comment.user_id = current_user.id
			end
			unless @comment.save
				flash[:notice] = "Can't comment"
			end
			redirect_to @user
		end
	end

	private
	def find_user
		@user = User.find(params[:id])
	end

	def comment_params
		params[:user].require(:comments).permit!
	end
end
