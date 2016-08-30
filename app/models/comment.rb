class Comment < ActiveRecord::Base
	validates :content, presence: true
	belongs_to :commentable, polymorphic: true
	belongs_to :user
end
