class UpdatesController < ApplicationController
	before_action :get_project

	def show
		@project = Project.find(params[:project_id])
		@update = Update.find(params[:id])
		@comments = @update.comments
	end

	def new
		unless project_owner?
			flash[:notice] = 'You have no access to this project'
			redirect_to @project
		end
		@update = Update.new
	end

	def create
		@update = @project.updates.new update_params
		if @update.save
			flash[:notice] = 'Update created'
		else
			flash[:notice] = @update.errors.full_messages.to_sentence
		end
		redirect_to @project
	end

	private
	def update_params
		params.require(:update).permit(:title, :description)
	end

	def project_owner?
		@project.user_id == current_user.id
	end

	def get_project
		@project = Project.find(params[:project_id])
	end
end
