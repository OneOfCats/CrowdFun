class ProjectsController < OwnableController
	before_action :authenticate_user!, except: :show
	before_action :find_project, except: [:new, :create]
	before_action :only_owner, only: [:edit, :update, :publish, :finish]
	before_action :only_owner, only: [:show], if: ->(){ !@project.published }

	def new
		@project = Project.new
		@categories = Category.all
	end

	def create
		@project = current_user.projects.new project_params
		flash[:notice] = @project.errors.full_messages.to_sentence unless @project.save
		redirect_to project_path(@project)
	end

	def show
		if current_user
			@voted = current_user.voted? @project
		else
			@voted = true
		end

		@updates = @project.updates.order created_at: :desc
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
		vote :liked
	end

	def dislike
		vote :disliked
	end

	def vote status
		return if current_user.voted? @project
		@vote = @project.votes.new user: current_user, status: status
		unless @vote.save
			flash[:notice] = @vote.errors.full_messages.to_sentence
		end

		respond_to do |format|
			format.js { render template: 'projects/vote' }
		end
	end

	private
	def project_params
		params.require(:project).permit(:title, :description, :category_id, :main_picture, :main_video, :realization_duration, :goal, :published)
	end

	def project_edit_params
		if @project.funded && !@project.result
			params.require(:project).permit(:result, :result_youtube, :result_image)
		elsif !@project.published
			params.require(:project).permit(:title, :description, :main_picture, :main_video, :realization_duration, :goal)
		end
	end
end
