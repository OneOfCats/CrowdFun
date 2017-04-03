class Vote < ActiveRecord::Base
	belongs_to :user
	belongs_to :project

  before_create :set_group

	enum status: [:liked, :disliked]
	enum group: [:users, :admins, :result]

  private

  def set_group
    group = :users
    group = :result if project.result?
    group = :admins if user.admin?
  end
end
