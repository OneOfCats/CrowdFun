class StaticPagesController < ApplicationController
  require 'will_paginate/array'

  def home
    @projects_top_admins = Project.find_by_sql ("SELECT projects.*, (COALESCE((SELECT COUNT(votes.id) FROM votes WHERE votes.status = 1 AND votes.project_id = projects.id AND votes.group = 1) * 100 / NULLIF((SELECT COUNT(votes.id) FROM votes WHERE votes.project_id = projects.id AND votes.group = 1), 0), 0)) AS admins_rating FROM projects WHERE projects.published = TRUE ORDER BY admins_rating DESC LIMIT 3;") 
    @project_main = @projects_top_admins[rand(@projects_top_admins.count)]
    
    @projects_top_users = Project.find_by_sql ("SELECT projects.*, (COALESCE((SELECT COUNT(votes.id) FROM votes WHERE votes.status = 1 AND votes.project_id = projects.id AND votes.group = 0) * 100 / NULLIF((SELECT COUNT(votes.id) FROM votes WHERE votes.project_id = projects.id AND votes.group = 0), 0), 0)) AS users_rating FROM projects WHERE projects.published = TRUE ORDER BY users_rating DESC LIMIT 3;") 
    @project_users_top_one = @projects_top_users[rand(@projects_top_users.count)]
    
    @projects_popular = Project.find_by_sql ("SELECT projects.*, (SELECT COUNT(votes.id) FROM votes WHERE votes.project_id = projects.id) AS votes_amount FROM projects WHERE projects.published = TRUE ORDER BY votes_amount DESC LIMIT 4")
    @projects_popular_random = @projects_popular.sort_by { rand }.first(3)

    @projects_finished = Project.where.not(result: nil).first(2)
  end

  def search
    if params[:order_by].present?
      @projects = Project.find_by_sql ["SELECT projects.*, (COALESCE((SELECT COUNT(votes.id) FROM votes WHERE votes.status = 0 AND votes.project_id = projects.id AND votes.group = ?) * 100 / NULLIF((SELECT COUNT(votes.id) FROM votes WHERE votes.project_id = projects.id AND votes.group = ?), 0), 0)) AS rating FROM projects WHERE projects.published = TRUE AND projects.category_id IN (?) AND lower(title) LIKE ? ORDER BY rating DESC;", params[:order_by], params[:order_by], params[:categories] || Category.all.map { |cat| cat.id }, "%#{params[:search]}%"]
    else
      @projects = Project.where(published: true).search params[:search], params[:categories]
    end
    @projects = @projects.paginate per_page: 9, page: params[:page]

    respond_to do |format|
      format.html
      format.js
    end
  end
end
