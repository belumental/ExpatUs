class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :chats
  has_many :messages
  has_many :stareds

  after_commit :broadcast_user_status, on: [:update]

  private

  def broadcast_user_status
    return unless saved_change_to_online?
    ActionCable.server.broadcast "presence_channel", {
      chats_online_num: Chat.includes(:user).where(user: {online: true}).group("chats.id").count.as_json
    }
  end
end
