class CommentsController < ApplicationController
	before_action :define_relative, only: :create

	def create
		@comment = @relative.comments.new comment_params
		if current_user
			@comment.user_id = current_user.id
			unless @comment.save
				flash[:notice] = @comment.errors.full_messages.to_sentence
			end
		else
			flash[:notice] = 'You are not logged in'
		end
		redirect_to :back
	end

	private
	def define_relative
		@relative_class = Object.const_get params[:commentable_type]
		@relative = @relative_class.find(params[:commentable_id])
	end

	def comment_params
		params.require(:comment).permit(:content)
	end
end
