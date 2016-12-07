class Pledge < ActiveRecord::Base
	validates :amount, :visible, presence: true
	validates :amount, format: { :with => /\A\d+(?:\.\d{0,2})?\z/ }
	validate :user_must_have_enough_money

	belongs_to :user
	belongs_to :project

	after_save :transfer_funds

	def is_owner? id
		user.id == id
	end

	def user_must_have_enough_money
		if user.account.balance < amount
			errors.add(:amount, 'You have not enough money')
		end
	end

	def transfer_funds
		project.update_attribute :funds, project.funds + amount
		user.account.update_attribute :balance, user.account.balance - amount
	end
end
