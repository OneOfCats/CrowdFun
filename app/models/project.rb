class Project < ActiveRecord::Base
	before_save :set_published_time
	require 'action_view'
	include ActionView::Helpers::DateHelper

	validates :title, :description, :realization_duration, :goal, presence: true
	validates :goal, format: { :with => /\A\d+(?:\.\d{0,2})?\z/ }

	belongs_to :user
	has_many :comments, as: :commentable

	def time_left
		if self.published
			distance_of_time_in_words(Time.current, (self.published_at + self.realization_duration.days))
		else
			false
		end
	end

	private
	def set_published_time
		if self.published
			self.published_at = DateTime.now
		end
	end
end
