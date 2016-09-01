class Account < ActiveRecord::Base
	validates :card_number, credit_card_number: true
	validates :card_holder_first_name, format: { with: /\A[a-zA-Z0-9]+\Z/ }
	validates :card_holder_second_name, format: { with: /\A[a-zA-Z0-9]+\Z/ }

	belongs_to :user
end
