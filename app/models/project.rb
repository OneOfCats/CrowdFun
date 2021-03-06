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

	def preview_rating
		get_rating :preview
	end

	def admins_rating
		get_rating :admins
	end

	def result_rating
		get_rating :result
	end

	def sponsors_rating
		get_rating :sponsors
	end

	def get_rating group
		positive = votes.liked.where(group: Vote.groups[group])
		all = votes.where(group: Vote.groups[group])
		unless all.count == 0
			return 100 * positive.count.to_f / all.count.to_f
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

	def self.search_published(options = {})
		if options[:result_present] == "true" && options[:result_unpresent].nil?
			options[:result] = true
		elsif options[:result_unpresent] == "true" && options[:result_present].nil?
			options[:result] = false
		end

		if options[:order_rating].present? && options[:order_rating] != 'popularity'
	    return Project.find_by_sql ["SELECT projects.*, (COALESCE((SELECT COUNT(votes.id) FROM votes WHERE votes.status = 0 AND votes.project_id = projects.id AND votes.group = ?) * 100 / NULLIF((SELECT COUNT(votes.id) FROM votes WHERE votes.project_id = projects.id AND votes.group = ?), 0), 0)) AS rating FROM projects WHERE projects.published = TRUE AND projects.category_id IN (?) AND lower(title) LIKE ? #{result_query_part(options[:result])} ORDER BY rating DESC;", options[:order_rating], options[:order_rating], options[:categories] || Category.all.map { |cat| cat.id }, "%#{options[:search].downcase}%"]
    end
    if options[:order_rating] == 'popularity'
    	return Project.find_by_sql ["SELECT projects.*, (SELECT COUNT(votes.id) FROM votes WHERE votes.project_id = projects.id) AS popularity FROM projects WHERE projects.published = TRUE AND projects.category_id IN (?) AND lower(title) LIKE ? #{result_query_part(options[:result])} ORDER BY popularity DESC;", options[:categories] || Category.all.map { |cat| cat.id }, "%#{options[:search].downcase}%"]
    end

    @projects = Project.where published: true
		if options[:search] && options[:categories]
			@projects.where 'lower(title) LIKE ? AND category_id in (?)' + result_query_part(options[:result]), "%#{options[:search].downcase}%", options[:categories]
		elsif options[:search]
			@projects.where 'lower(title) LIKE ?' + result_query_part(options[:result]), "%#{options[:search].downcase}%"
		elsif options[:categories]
			@projects.where 'category_id in (?)' + result_query_part(options[:result]), options[:categories]
		else
			self
		end
	end

	def self.result_query_part bool
		return " AND projects.result IS NOT NULL" if bool == true
		return " AND projects.result IS NULL" if bool == false
		return ""
	end

	def self.popular
		return Project.find_by_sql ("SELECT projects.*, (SELECT COUNT(votes.id) FROM votes WHERE votes.project_id = projects.id) AS votes_amount FROM projects WHERE projects.published = TRUE ORDER BY votes_amount DESC")
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
