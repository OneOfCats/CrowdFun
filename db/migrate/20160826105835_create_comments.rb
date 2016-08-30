class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.text :content
      t.references :commentable, polymorphic: true, index: true
      t.belongs_to :user
      t.timestamps null: false
    end
  end
end
