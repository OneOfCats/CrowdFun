class AddFundedOnProjects < ActiveRecord::Migration
  def change
  	add_column :projects, :funded, :boolean
  end
end
