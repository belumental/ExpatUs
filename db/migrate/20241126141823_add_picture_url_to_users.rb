class AddPictureUrlToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :picture_url, :text
  end
end
