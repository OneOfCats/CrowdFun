class AddIndexesToTables < ActiveRecord::Migration
  def change
  	add_index :accounts, :card_number
  	add_index :accounts, :user_id
  	add_index :comments, :user_id
  	add_index :pledges, :user_id
  	add_index :pledges, :project_id
  	add_index :projects, :user_id
  	add_index :projects, :title
  	add_index :updates, :project_id
  end
end
