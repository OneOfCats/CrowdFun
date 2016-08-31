class CommentsController < ApplicationController
	before_action :find_user, only: :create

	def create
		if params[:user][:comments]
			@comment = @user.comments.new comment_params
			if current_user
				@comment.user_id = current_user.id
			end
			unless @comment.save
				flash[:notice] = @comment.errors.full_messages.to_sentence
			end
			redirect_to @user
		end
	end

	private
	def find_user
		@user = User.find(params[:user_id])
	end

	def comment_params
		params[:user].require(:comments).permit!
	end
end
