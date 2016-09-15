class PledgesController < ApplicationController
	before_action :get_project
	before_action :get_pledges, only: :index

	def index
	end

	def new
		@pledge = @project.pledges.new
	end
	
	def create
		redirect_to @project
		if owner?
			return flash[:notice] = 'You can not pledge to your own project'
		end
		unless balance_enough?
			return flash[:notice] = 'You have not enough money on your balance'
		end
		@pledge = @project.pledges.new pledge_params
		@pledge.user_id = current_user.id
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

	def get_pledges
		@pledges = @project.pledges
	end

	def pledge_params
		params.require(:pledge).permit([:amount, :message, :visible])
	end

	def owner?
		@project.user_id == current_user.id
	end

	def balance_enough?
		current_user.account.balance >= params[:pledge][:amount].to_f
	end
end
