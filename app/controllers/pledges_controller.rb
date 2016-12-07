class PledgesController < ApplicationController
	before_action :get_project

	def index
	end

	def new
		@pledge = @project.pledges.new
	end
	
	def create
		redirect_to @project
		@pledge = @project.pledges.new pledge_params.merge(user_id: current_user.id)
		unless @pledge.save
			flash[:notice] = @pledge.errors.full_messages.to_sentence
		end
	end

	private
	def get_project
		@project = Project.find(params[:project_id])
		unless @project
			flash[:notice] = 'Project doesnt exist'
			return redirect_to(root_path)
		end
		unless @project.published
			flash[:notice] = 'Project is not published'
			redirect_to project_path(@project)
		end
	end

	def pledge_params
		params.require(:pledge).permit([:amount, :message, :visible])
	end
end
