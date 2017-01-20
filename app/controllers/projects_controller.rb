class ProjectsController < OwnableController
	before_action :authenticate_user!, except: :show
	before_action :find_project, except: [:new, :create]
	before_action :only_owner, only: [:edit, :update, :publish, :finish]
	before_action :only_owner, only: [:show], if: ->(){ !@project.published }

	def new
		@project = Project.new
	end

	def create
		@project = current_user.projects.new project_params
		flash[:notice] = @project.errors.full_messages.to_sentence unless @project.save
		redirect_to project_path(@project)
	end

	def show
		if @project.user == current_user
			@voted = true
		elsif @project.funded
			@voted = @project.votes.where(user: current_user).pledgers.first
		else
			@voted = @project.votes.where(user: current_user).users.first
		end
		@users_rating = @project.users_rating
		@admins_rating = @project.admins_rating
		@pledgers_rating = @project.pledgers_rating
	end

	def edit
		@user = current_user
	end

	def update
		flash[:notice] = "Project successfully edited"
		unless @project.update project_edit_params
			flash[:notice] = @account.errors.full_messages.to_sentence
		end
		redirect_to project_path(@project)
	end

	def publish
		flash[:notice] = "Project successfully published"
		unless @project.update_attribute :published, true
			flash[:notice] = @account.errors.full_messages.to_sentence
		end
		redirect_to project_path(@project)
	end

	def finish
		@project.close_project
		redirect_to project_path(@project)
	end

	def like
		if @project.opened && !@project.funded
			vote :liked, :users
		elsif @project.result && @project.pledgers.find(current_user)
			vote :liked, :pledgers
		end
		respond_to do |format|
			format.js { render 'vote.js.erb' }
		end
	end

	def dislike
		if @project.opened && !@project.funded
			vote :disliked, :users
		elsif @project.result && @project.pledgers.find(current_user)
			vote :disliked, :pledgers
		end
		respond_to do |format|
			format.js { render 'vote.js.erb' }
		end
	end

	def vote status, group
		return if @project.votes.where(user: current_user, group: group).first
		@vote = @project.votes.new(user: current_user, status: status, group: group || "admins")
		unless @vote.save
			flash[:notice] = @vote.errors.full_messages.to_sentence
		end
	end

	private
	def project_params
		params.require(:project).permit(:title, :description, :main_picture, :main_video, :realization_duration, :goal, :published)
	end

	def project_edit_params
		if @project.funded && !@project.result
			params.require(:project).permit(:result)
		elsif !@project.published
			params.require(:project).permit(:title, :description, :main_picture, :main_video, :realization_duration, :goal)
		end
	end
end
