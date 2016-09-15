class CreatePledges < ActiveRecord::Migration
  def change
    create_table :pledges do |t|
      t.belongs_to :user
      t.belongs_to :project
      t.decimal :amount, scale: 2, precision: 8
      t.text :message
      t.boolean :visible

      t.timestamps null: false
    end
  end
end
