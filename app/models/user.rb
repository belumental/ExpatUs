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
    partial_data = self.compute_online_user_num_on_chat
    Rails.logger.error "...........................#{partial_data}"
    broadcast_update_to "presence",
                        partial: "chats/my_chats_online_users",
                        target: "joined-tab-pane",
                        locals: {chats_with_messages_count: partial_data}
  end

  def compute_online_user_num_on_chat
    my_messages = Message.where(user_id: self.id)
    chats = self.chats
    my_messages.each do |my_message|
      unless chats.include?(my_message.chat)
        chats.push(my_message.chat)
      end
    end
    chats_with_messages_count = []
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
      counts[value] = [] unless counts.has_key?(value)
      counts[value] << item.user
    end
    # counts.as_json

    online_num = counts.to_h
    chats.each_with_index do |chat, index|
      chats_with_messages_count[index] = chat.attributes.dup
      chats_with_messages_count[index]["msgcount"] = Message.where(chat_id: chat.id).count
      online_num.keys.each do |key|
        if chats_with_messages_count[index]['id'] == key
          chats_with_messages_count[index]["online_num"] = online_num[key]
        end
      end
    end
    chats_with_messages_count
  end
end
