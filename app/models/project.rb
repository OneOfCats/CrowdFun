class Project < ActiveRecord::Base
	after_save :publishing, if: :published_changed?
	after_save :check_goal, if: :funds_changed?

	validates :title, :description, :realization_duration, :goal, presence: true
	validates :goal, format: { :with => /\A\d+(?:\.\d{0,2})?\z/ }

	belongs_to :user
	has_many :comments, as: :commentable, dependent: :delete_all
	has_many :updates, dependent: :delete_all
	has_many :pledges
	has_many :pledgers, through: :pledges, class_name: 'User'

	def deadline
		if self.published
			self.published_at + self.realization_duration.days
		else
			false
		end
	end

	private
	def publishing
		return if !self.published
		self.touch(:published_at)
		handle_asynchronously :close_project, :run_at => Proc.new { realization_duration.days.from_now }
	end

	def close_project
		update_attribute :opened, false
	end

	def check_goal
		if funds >= goal && !funded
			update_attribute :funded, true
		end
	end

end
