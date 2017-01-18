#For example a Project or an Update, an entity that has an owner and a project (or is a project)

class OwnableController < ApplicationController
	def only_owner
		unless @project.is_owner? current_user.id
			flash[:notice] = "You have no access to this project"
			redirect_to user_root_path
		end
	end

	def find_project
		@project = Project.find(params[:id])
	end
end