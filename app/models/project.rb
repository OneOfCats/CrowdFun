class Project < ActiveRecord::Base

	after_save :publishing, if: :published_changed?
	after_save :check_goal, if: :funds_changed?

	validates :title, :description, :realization_duration, :goal, presence: true
	validates :goal, format: { :with => /\A\d+(?:\.\d{0,2})?\z/ }

	belongs_to :user
	belongs_to :category
	has_many :comments, as: :commentable, dependent: :delete_all
	has_many :updates, dependent: :delete_all
	has_many :pledges
	has_many :pledgers, through: :pledges, source: :user
	has_many :votes

	def deadline
		if self.published
			self.published_at + self.realization_duration.days
		else
			false
		end
	end

	def close_project
		return false unless opened
		update_attribute :opened, false
		if funds >= goal
			user.account.increment! :balance, funds
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

	def result_rating
		get_rating :pledgers
	end

	def get_rating group
		negative = votes.disliked.where(group: Vote.groups[group])
		all = votes.where(group: Vote.groups[group])
		unless all.count == 0
			return 100 - (negative.count.to_f / all.count.to_f) * 100
		end
		return 0
	end

	def get_rounded_rating group
		rating = get_rating group
		case rating
			when 0..6 then rating = 0
			when 6..18 then rating = 12
			when 19..31 then rating = 25
			when 31..43 then rating = 38
			when 44..56 then rating = 50
			when 51..67 then rating = 62
			when 68..80 then rating = 75
			when 81..94 then rating = 88
			when 95..100 then rating = 100
		end
	end

	def funded?
		funded
	end

	def result?
		result.present?
	end

	def progress
		100 * funds / goal
	end

	def days_left
		(deadline - Time.zone.now).to_i / 1.day
	end

	def short_description characters
		description.split[0...characters].join(' ').html_safe
	end

	def self.search search, categories
		if search && categories
			where 'lower(title) LIKE ? AND category_id in (?)', "%#{search.downcase}%", categories
		elsif search
			where 'lower(title) LIKE ?', "%#{search.downcase}%"
		elsif categories
			where 'category_id in (?)', categories
		else
			self
		end
	end

	private

	def publishing
		return unless published
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
