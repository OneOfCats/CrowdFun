class AddResultToProject < ActiveRecord::Migration
  def change
  	add_column :projects, :result, :text
  end
end
