class AddOpenedOnProjects < ActiveRecord::Migration
  def change
  	add_column :projects, :opened, :boolean, null: false, default: true
  end
end
