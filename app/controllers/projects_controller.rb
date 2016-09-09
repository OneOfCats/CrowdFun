class ProjectsController < ApplicationController
	before_action :authenticate_user!, except: :show
	before_action :find_project, except: [:new, :create]

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
		@deadline = @project.deadline
	end

	def edit
		@user = current_user if is_owner @project.user_id 
	end

	def update
		return unless is_owner @project.user_id
		if @project.update_attributes project_edit_params
			flash[:notice] = "Project successfully edited"
		else
			flash[:notice] = @account.errors.full_messages.to_sentence
		end
		redirect_to user_project_path current_user.id, params[:id]
	end

	def publish
		return unless is_owner @project.user_id
		if @project.update_attribute :published, true
			flash[:notice] = "Project successfully published"
		else
			flash[:notice] = @account.errors.full_messages.to_sentence
		end
		redirect_to user_project_path params[:user_id], params[:id]
	end

	private
	def project_params
		params.require(:project).permit(:title, :description, :main_picture, :main_video, :realization_duration, :goal, :published)
	end

	def project_edit_params
		if @project.published
			params.require(:project).permit(:main_picture, :main_video);
		else
			params.require(:project).permit(:title, :description, :main_picture, :main_video, :realization_duration, :goal);
		end
	end

	def is_owner id
		unless current_user.id == id
			flash[:notice] = "You can't edit this project"
			redirect_to user_root_path
			return false
		end
		true
	end

	def find_project
		@project = Project.find(params[:id])
	end
end
