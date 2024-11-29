class PresenceChannel < ApplicationCable::Channel
  def subscribed
    stream_from "presence_channel"
    current_user.update(online: true)
    broadcast_user_list
  end

  def unsubscribed
    current_user.update(online: false) if current_user
    broadcast_user_list
  end

  def broadcast_user_list
    users = User.where(online: true)
    ActionCable.server.broadcast("presence_channel", users: users.as_json)
  end
end
