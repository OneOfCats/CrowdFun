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
  #has_many :voted, through: :votes, class_name: 'Project'
  has_many :votes

  accepts_nested_attributes_for :account
  after_create :create_associated_account

  def create_associated_account
    self.create_account balance: 0
  end

  def admin?
    admin
  end
end
