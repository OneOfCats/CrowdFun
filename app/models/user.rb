class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable, :omniauth_providers => [:facebook]
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

  #Рейтинг востребованности: как много из опубликованных проектов собрали нужную сумму
  def demand_rating
    all = projects.where(published: true)
    positive = all.where(funded: true)
    count_rating all, positive
  end

  #Как много проектов выполнено с результатом
  def resulting_rating
    all = projects.where(published: true)
    positive = all.where('result IS NOT NULL')
    count_rating all, positive
  end

  #Рейтинг первой стадии проекта (когда он ещё не собрал деньги, лайкать могут все)
  def preview_rating
    all = Vote.where("project_id in (?)", projects.map { |project| project.id}).preview
    positive = all.liked
    count_rating all, positive
  end

  #Как оценивают результаты проектов
  def satisfaction_rating
    all = Vote.where("project_id in (?)", projects.map { |project| project.id}).result
    positive = all.liked
    count_rating all, positive
  end

  #Одобрение администрации
  def admins_rating
    all = Vote.where("project_id in (?)", projects.map { |project| project.id}).admins
    positive = all.liked
    count_rating all, positive
  end

  #Одобрение спонсоров
  def sponsors_rating
    all = Vote.where("project_id in (?)", projects.map { |project| project.id}).sponsors
    positive = all.liked
    count_rating all, positive
  end

  def voted? project
    if project.user == self
      true
    elsif project.result?
      project.votes.where(user: self).result.first
    else
      project.votes.where(user: self).preview.first
    end
  end

  def self.round_dating rating
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

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0,20]
      user.avatar = auth.info.image
    end
  end

  private

  def count_rating(all, positive)
    unless all.count == 0
      return 100 * positive.count.to_f / all.count.to_f
    end
    return 0
  end
end
