class CommentsController < ApplicationController
	before_action :find_user, only: :create

	def create
		@comment = @user.comments.new comment_params
		if current_user
			@comment.user_id = current_user.id
		else
			flash[:notice] = 'You are not logged in'
			redirect_to root_path
		end
		unless @comment.save
			flash[:notice] = @comment.errors.full_messages.to_sentence
		end
		redirect_to @user
	end

	private
	def find_user
		@user = User.find(params[:user_id])
	end

	def comment_params
		params[:user].require(:comments).permit!
	end
end
