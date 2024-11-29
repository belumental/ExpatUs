class AddOnlineToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :online, :boolean, default: false
  end
end
