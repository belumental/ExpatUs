class Users::SessionsController < Devise::SessionsController
  def create
    super
    current_user.update(online: true)
    sleep(1)
  end

  def destroy
    current_user.update(online: false)
    sleep(1)
    super
  end
end
