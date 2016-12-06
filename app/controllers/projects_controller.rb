class ProjectsController < ApplicationController
	before_action :authenticate_user!, except: :show
	before_action :find_project, except: [:new, :create]
	before_action :only_owner, only: [:edit]

	def new
		@project = Project.new
	end

	def create
		@project = current_user.projects.new project_params
		flash[:notice] = @project.errors.full_messages.to_sentence unless @project.save
		redirect_to project_path(@project)
	end

	def show
		only_owner unless @project.published
	end

	def edit
		@user = current_user
	end

	def update
		return unless only_owner
		flash[:notice] = "Project successfully edited"
		unless @project.update_attributes project_edit_params
			flash[:notice] = @account.errors.full_messages.to_sentence
		end
		redirect_to project_path(@project)
	end

	def publish
		return unless only_owner
		flash[:notice] = "Project successfully published"
		unless @project.update_attribute :published, true
			flash[:notice] = @account.errors.full_messages.to_sentence
		end
		redirect_to project_path(@project)
	end

	def finish
		return unless only_owner
		@project.close_project
		redirect_to project_path(@project)
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

	def only_owner
		unless @project.is_owner? current_user.id
			flash[:notice] = "You have no access to this project"
			redirect_to user_root_path
			return false
		end
		true
	end

	def find_project
		@project = Project.find(params[:id])
	end
end
