module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      self.current_user = current_user
    end

    def beat
    end

    private

    # def find_verified_user
    #   if verified_user = env['warden'].user
    #     self.current_user = verified_user
    #   else
    #     reject_unauthorized_connection
    #   end
    # end
  end
end
