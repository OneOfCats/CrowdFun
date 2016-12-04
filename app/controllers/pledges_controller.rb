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
		unless balance_enough?
			return flash[:notice] = 'You have not enough money on your balance'
		end
		@pledge = @project.pledges.new pledge_params
		@pledge.user_id = current_user.id
		if @pledge.save #if pledge is saved successfuly - transfer the money
			new_funds = @project.funds + params[:pledge][:amount].to_f
			@project.update_attribute :funds, new_funds
			new_balance = current_user.account.balance - params[:pledge][:amount].to_f
			current_user.account.update_attribute :balance, new_balance
		else
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
