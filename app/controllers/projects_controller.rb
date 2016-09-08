class ProjectsController < ApplicationController
	def new
		@project = Project.new
	end

	def create
		@project = Project.new project_params
		if current_user
			@project.user_id = current_user.id
		else
			flash[:notice] = 'You are not logged in'
			redirect_to root_path
		end
		unless @project.save
			flash[:notice] = @project.errors.full_messages.to_sentence
		end
		redirect_to user_root_path
	end

	def show
		@project = Project.find(params[:id])
		@time_left = @project.time_left
	end

	private
	def project_params
		params.require(:project).permit(:title, :description, :main_picture, :main_video, :realization_duration, :goal, :published)
	end
end
