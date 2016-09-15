class Project < ActiveRecord::Base
	after_save :set_published_time

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
	def set_published_time
		if self.published
			self.touch(:published_at)
		end
	end
end
