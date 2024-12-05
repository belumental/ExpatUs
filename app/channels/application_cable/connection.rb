module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      self.current_user = find_verified_user
      Rails.logger.error ":::::::::::::::::::::::::::::::::::::::::::::::::::::::::::#{current_user}"
    end

    def disconnect
      current_user.update(online: false)
    end

    private

    def find_verified_user
      if verified_user = env['warden'].user || User.find_by(id: cookies.encrypted[:user_id])
        self.current_user = verified_user
      else
        reject_unauthorized_connection
      end
    end
  end
end
