class UsersController < ApplicationController


  def profile
    params[:username]
  end

  def destroy
    sign_out(current_user)
      redirect_to root_path, notice: "You have successfully logged out."
  end

  def show
    @user = current_user
    #redirect_to list_path
    @chats = Chat.all
    if params[:query].present?
      @chats = Chat.search_by_title_and_synopsis(params[:query])
    else
      @chats = Chat.all
    end
  end
end
