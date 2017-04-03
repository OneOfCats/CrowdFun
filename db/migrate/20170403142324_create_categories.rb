class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.string :title, null: false

      t.timestamps null: false
    end

    add_index :categories, :title, unique: true

    change_table :projects do |t|
      t.belongs_to :category
    end
  end
end
