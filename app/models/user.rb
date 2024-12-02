class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_one_attached :photo
  # user.picture_url
  has_many :joined_chats
  has_many :chats, through: :joined_chats
  has_many :messages
  has_many :stareds

  after_commit :broadcast_user_status, on: [:update]

  private

  def broadcast_user_status
    return unless saved_change_to_online?
    ActionCable.server.broadcast "presence_channel", {
      chats_online_num: compute_online_user_num_on_chat
    }
  end

  def compute_online_user_num_on_chat
    # Select all message that message.user.online = true
    messages = Message.includes(:user).where(user: {online: true})
    # Remove repeatted messages
    seen = Set.new
    now_ele_arr = messages.select do |item|
      identifier = "#{item['user_id']}_#{item['chat_id']}"
      unless seen.include?(identifier)
        seen.add(identifier)
      end
    end
    # Count the num by chat_id
    counts = Hash.new(0)
    now_ele_arr.each do |item|
      value = item.chat_id
      counts[value] += 1
    end
    counts.as_json
  end
end
