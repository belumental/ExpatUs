class CreateJoinedChats < ActiveRecord::Migration[7.2]
  def change
    create_table :joined_chats do |t|
      t.references :user, null: false, foreign_key: true
      t.references :chat, null: false, foreign_key: true

      t.timestamps
    end
  end
end
