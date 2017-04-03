class StaticPagesController < ApplicationController

  def home
    @projects = Project.where(published: true)
    @projects_top_admins = @projects.joins(:votes).where status: Vote.statuses[:liked]
    @project_main = @projects_top_admins.order("RANDOM()").first
  end

  def search
    @projects = Project.where(published: true).search(params[:search], params[:categories]).paginate per_page: 9, page: params[:page]

    respond_to do |format|
      format.html
      format.js
    end
  end
end
