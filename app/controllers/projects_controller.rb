class ProjectsController < ApplicationController
	before_action :logged_in?, only: :create

	def new
		@project = Project.new
	end

	def create
		@project = Project.new project_params
		@project.user_id = current_user.id
		unless @project.save
			flash[:notice] = @project.errors.full_messages.to_sentence
		end
		redirect_to user_root_path
	end

	def show
		@project = Project.find(params[:id])
		@deadline = @project.deadline
	end

	private
	def project_params
		params.require(:project).permit(:title, :description, :main_picture, :main_video, :realization_duration, :goal, :published)
	end

	def logged_in?
		unless current_user
			flash[:notice] = 'You are not logged in'
			redirect_to root_path
		end
	end
end
