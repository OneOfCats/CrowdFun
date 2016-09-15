class PledgesController < ApplicationController
	before_action :get_vars

	def index
	end

	private
	def get_vars
		@project = Project.find(params[:project_id])
		unless @project.published
			flash[:notice] = 'Project is not published'
			redirect_to @project
		end
		@pledges = @project.pledges
	end
end
