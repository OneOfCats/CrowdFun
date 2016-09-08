class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.belongs_to :user, foreign_key: true
      t.string :title
      t.text :description
      t.string :main_picture
      t.string :main_video
      t.integer :realization_duration
      t.decimal :goal
      t.decimal :funds, default: 0
      t.boolean :published, default: false
      t.datetime :published_at

      t.timestamps null: false
    end
  end
end
