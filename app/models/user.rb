class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :comments, as: :commentable
  has_many :commented_on, class_name: 'Comment'
  has_many :projects
  has_one :account
  has_many :pledges
  has_many :pledged_projects, through: :pledges, source: :project
  has_many :votes

  accepts_nested_attributes_for :account
  after_create :create_associated_account

  def create_associated_account
    self.create_account balance: 0
  end

  def admin?
    admin
  end

  def demand_rating
    all = projects.where('(published=? AND opened=?) OR funded=?', true, false, true)
    negative = all.where(funded: false)
    puts "ASDASD"
    puts all.inspect
    puts negative.inspect
    count_rating all, negative
  end

  def resulting_rating
    all = projects.where(funded: true)
    negative = all.where(result: nil)
    count_rating all, negative
  end

  def users_rating
    all = Vote.where("project_id in (?)", projects.map { |project| project.id}).users
    negative = all.disliked
    count_rating all, negative
  end

  def pledgers_rating
    all = Vote.where("project_id in (?)", projects.map { |project| project.id}).pledgers
    negative = all.disliked
    count_rating all, negative
  end

  private

  def count_rating(all, negative)
    unless all.count == 0
      return 100 - (negative.count.to_f / all.count.to_f) * 100
    end
    return 0
  end
end
