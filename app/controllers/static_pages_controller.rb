class StaticPagesController < ApplicationController

  def home
    @projects_top_admins = Project.find_by_sql ("SELECT projects.*, (100 - COALESCE((SELECT COUNT(votes.id) FROM votes WHERE votes.status = 1 AND votes.project_id = projects.id AND votes.group = 1) * 100 / NULLIF((SELECT COUNT(votes.id) FROM votes WHERE votes.project_id = projects.id AND votes.group = 1), 0), 0)) AS admins_rating FROM projects WHERE projects.published = TRUE ORDER BY admins_rating LIMIT 10;") 
    @project_main = @projects_top_admins[rand(@projects_top_admins.count)]
  end

  def search
    @projects = Project.where(published: true).search(params[:search], params[:categories]).paginate per_page: 9, page: params[:page]

    respond_to do |format|
      format.html
      format.js
    end
  end
end
