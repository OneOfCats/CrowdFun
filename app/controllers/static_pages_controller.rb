class StaticPagesController < ApplicationController
  def home
    @projects = Project.where(published: true)
    @projects_top_admins = @projects.joins(:votes).where status: 0
    @project_main = @projects_top_admins.order("RANDOM()").first
  end
end
