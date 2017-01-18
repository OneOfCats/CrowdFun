class Vote < ActiveRecord::Base
	belongs_to :user
	belongs_to :project

	enum status: [:liked, :disliked]
	enum group: [:users, :admins]
end
