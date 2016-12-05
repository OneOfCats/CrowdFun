class AddFundedOnProjects < ActiveRecord::Migration
  def change
  	add_column :projects, :funded, :boolean, null: false, default: false
  end
end
