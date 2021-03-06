class StaticPagesController < ApplicationController
  require 'will_paginate/array'

  def home
    @projects_top_admins = Project.search_published order_rating: 1, search: ''
    @project_main = @projects_top_admins[0..2][rand(3)] if @projects_top_admins.size > 0
    
    @projects_top_users = Project.search_published order_rating: 0, search: ''
    @project_users_top_one = @projects_top_users[0..2][rand(3)] if @projects_top_users.size > 0
    
    @projects_popular = Project.popular
    @projects_popular_random = @projects_popular[0..3].sort_by { rand }.first(3) if @projects_popular.size > 0

    @projects_finished = Project.where.not(result: nil).first(2)
  end

  def search
    @projects = Project.search_published search: params[:search], categories: params[:categories], order_rating: params[:order_by], result_present: params[:result_present], result_unpresent: params[:result_unpresent]
    @projects = @projects.paginate per_page: 9, page: params[:page]

    respond_to do |format|
      format.html
      format.js
    end
  end
end
