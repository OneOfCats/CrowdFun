class Vote < ActiveRecord::Base
	belongs_to :user
	belongs_to :project

  before_create :set_group

	enum status: [:liked, :disliked]
	enum group: [:preview, :admins, :result]

  private

  def set_group
    self.group = 0
    self.group = 2 if project.result?
    self.group = 1 if user.admin?
  end
end
