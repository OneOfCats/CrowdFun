class PledgesController < ApplicationController
	before_action :get_project

	def index
		respond_to do |format|
			format.html
			format.js { render template: 'pledges/index' }
		end
	end

	def new
		@pledge = @project.pledges.new
	end
	
	def create
		@pledge = @project.pledges.new pledge_params.merge(user_id: current_user.id)
		unless @pledge.save
			flash[:notice] = @pledge.errors.full_messages.to_sentence
		end
		redirect_to @project
	end

	private
	def get_project
		@project = Project.find(params[:project_id])
		unless @project || @project.published
			flash[:notice] = 'Project doesnt exist'
			return redirect_to(root_path)
		end
	end

	def pledge_params
		params.require(:pledge).permit([:amount, :message, :visible])
	end
end
