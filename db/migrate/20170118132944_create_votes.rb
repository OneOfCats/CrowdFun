class CreateVotes < ActiveRecord::Migration
  def change
    create_table :votes do |t|
    	t.belongs_to :user
    	t.belongs_to :project
    	t.integer :status, default: 0
    	t.integer :group, default: 0

      t.timestamps null: false
    end
  end
end
