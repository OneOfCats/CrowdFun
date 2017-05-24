class AddResultImageAndResutYoutubeToProject < ActiveRecord::Migration
  def change
    add_column :projects, :result_image, :string
    add_column :projects, :result_youtube, :string
  end
end
