class CreatePledges < ActiveRecord::Migration
  def change
    create_table :pledges do |t|
      t.belongs_to :user
      t.belongs_to :project
      t.decimal :amount
      t.text :message

      t.timestamps null: false
    end
  end
end
