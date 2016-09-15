class Pledge < ActiveRecord::Base
	validates :amount, :visible, presence: true
	validates :amount, format: { :with => /\A\d+(?:\.\d{0,2})?\z/ }

	belongs_to :user
	belongs_to :project
end
