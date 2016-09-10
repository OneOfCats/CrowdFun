class Update < ActiveRecord::Base
	validates :title, :description, presence: true

	belongs_to :project
	has_many :comments, as: :commentable
end
