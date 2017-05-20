class UpdatesController < OwnableController
	before_action :find_project
	before_action :only_owner, only: [:new]

	def show
		@update = Update.find(params[:id])
		@project = @update.project
		@comments = @update.comments

		respond_to do |format|
			format.html
			format.js
		end
	end

	def new
		@update = Update.new
	end

	def create
		@update = @project.updates.new update_params
		if @update.save
			flash[:notice] = 'Update created'
		else
			flash[:notice] = @update.errors.full_messages.to_sentence
		end
		redirect_to @project
	end

	private
	def update_params
		params.require(:update).permit(:title, :main_picture, :description)
	end
end
