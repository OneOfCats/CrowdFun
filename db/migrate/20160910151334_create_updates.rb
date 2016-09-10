class CreateUpdates < ActiveRecord::Migration
  def change
    create_table :updates do |t|
      t.string :title
      t.text :description
      t.string :main_picture
      t.string :main_video
      t.belongs_to :project, foreign_key: true

      t.timestamps null: false
    end
  end
end
