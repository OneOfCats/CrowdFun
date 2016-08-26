class CommentsController < ApplicationController
	def new
		@context = context
		@comment = @context.comments.new
	end

	def create
		@context = context
		@comment = @context.comments.new comment_params

		if @comment.save
			redirect_to context_url(context)
		end
	end

	private
	def comment_params
		params.require(:comment).permit!
	end

	def context
		if params[:user_id]
			id = params[:user_id]
			User.find params[:user_id]
		elsif params[:project_id]
			id = params[:project_id]
			Project.find params[:project_id]
		end
	end

	def context_url(context)
		if User === context
			user_path context
		elsif Project === context
			project_path context
		end
	end
end
