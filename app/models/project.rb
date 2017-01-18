class Project < ActiveRecord::Base

	after_save :publishing, if: :published_changed?
	after_save :check_goal, if: :funds_changed?

	validates :title, :description, :realization_duration, :goal, presence: true
	validates :goal, format: { :with => /\A\d+(?:\.\d{0,2})?\z/ }

	belongs_to :user
	has_many :comments, as: :commentable, dependent: :delete_all
	has_many :updates, dependent: :delete_all
	has_many :pledges
	has_many :pledgers, through: :pledges, class_name: 'User'
	#has_many :voters, through: :votes, class_name: 'User'
	has_many :votes

	def deadline
		if self.published
			self.published_at + self.realization_duration.days
		else
			false
		end
	end

	def close_project
		return false if !opened
		update_attribute :opened, false
		if funds >= goal
			user.account.update_attribute :balance, user.account.balance + funds
		else
			refund_pledges
		end
	end

	def is_owner? id
		user.id == id
	end

	def users_rating
		get_rating :users
	end

	def admins_rating
		get_rating :admins
	end

	def get_rating group
		negative = votes.disliked.where(group: Vote.groups[group])
		all = votes.where(group: Vote.groups[group])
		unless all.count == 0
			return 100 - (negative.count / all.count) * 100
		end
		return 0
	end

	private

	def publishing
		return if !self.published
		self.touch(:published_at)
		delay.close_project(run_at: realization_duration.days.from_now)
	end

	def check_goal
		if funds >= goal && !funded
			update_attribute :funded, true
		end
	end

	def refund_pledges
		pledges.each do |pledge|
			puts pledge.user.inspect
			puts pledge.amount
			pledge.user.account.update_attribute :balance, pledge.user.account.balance + pledge.amount
		end
	end

end
