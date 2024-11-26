class AddChatDescriptionToChats < ActiveRecord::Migration[7.2]
  def change
    add_column :chats, :description, :string
  end
end
