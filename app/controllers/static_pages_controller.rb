class StaticPagesController < ApplicationController
  def home
    @projects = Project.where(published: true)
    @projects_top_admins = @projects.find :all, order: 'admins_rating', limit: 10
    @project_main = @projects_top_admins.order("RANDOM()").first
  end
end
