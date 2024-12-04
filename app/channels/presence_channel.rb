# class PresenceChannel < ApplicationCable::Channel
#   def subscribed
#     stream_from "presence"
#     Rails.logger.error "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx: #{current_user}"
#     current_user.update(online: true)
#   end

#   def unsubscribed
#     current_user.update(online: false) if current_user
#   end
# end
