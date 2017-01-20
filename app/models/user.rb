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
  has_many :pledged_projects, through: :pledges, class_name: 'Project'
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
    return 0 if projects.size == 0 
    all = projects.where(published: true, opened: false)
    negative = all.where(funded: false)
    count_rating all, negative
  end

  def resulting_rating
    return 0 if projects.size == 0 
    all = projects.where(funded: true)
    negative = all.where(result: nil)
    count_rating all, negative
  end

  def projects_rating
    return 0 if projects.size == 0 
    all = Vote.where("project_id in (?)", projects.map { |project| project.id})
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
