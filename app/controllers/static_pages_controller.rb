class StaticPagesController < ApplicationController

  def home
    @projects_top_admins = Project.find_by_sql ("SELECT projects.*, (100 - COALESCE((SELECT COUNT(votes.id) FROM votes WHERE votes.status = 1 AND votes.project_id = projects.id AND votes.group = 1) * 100 / NULLIF((SELECT COUNT(votes.id) FROM votes WHERE votes.project_id = projects.id AND votes.group = 1), 0), 0)) AS admins_rating FROM projects WHERE projects.published = TRUE ORDER BY admins_rating LIMIT 10;") 
    @project_main = @projects_top_admins[rand(@projects_top_admins.count)]
    
    @projects_top_users = Project.find_by_sql ("SELECT projects.*, (100 - COALESCE((SELECT COUNT(votes.id) FROM votes WHERE votes.status = 1 AND votes.project_id = projects.id AND votes.group = 0) * 100 / NULLIF((SELECT COUNT(votes.id) FROM votes WHERE votes.project_id = projects.id AND votes.group = 0), 0), 0)) AS users_rating FROM projects WHERE projects.published = TRUE ORDER BY users_rating LIMIT 10;") 
    @project_users_top_one = @projects_top_users[rand(@projects_top_users.count)]
    
    @projects_popular = Project.find_by_sql ("SELECT projects.*, (SELECT COUNT(votes.id) FROM votes WHERE votes.project_id = projects.id) AS votes_amount FROM projects WHERE projects.published = TRUE ORDER BY votes_amount LIMIT 10")
    @projects_popular_random = @projects_popular.sort_by { rand }.first(3)

    @projects_finished = Project.where.not(result: nil).first(2)
  end

  def search
    @projects = Project.where(published: true).search(params[:search], params[:categories]).paginate per_page: 9, page: params[:page]

    respond_to do |format|
      format.html
      format.js
    end
  end
end
