class Message < ApplicationRecord
  belongs_to :user
  belongs_to :chat
  has_many :stareds

  after_create_commit :broadcast_message

  private

  def broadcast_message
    broadcast_append_to "chat_#{chat.id}_messages",
                        partial: "messages/message",
                        target: "messages",
                        locals: {message: self }
  end
end
