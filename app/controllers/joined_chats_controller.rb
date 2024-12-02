class JoinedChatsController < ApplicationController

  def create

    @chat = Chat.find(params[:chat_id])
    @joined_chat = JoinedChat.new
    @joined_chat.chat = @chat
    @joined_chat.user = current_user

    respond_to do |format|
      if @joined_chat.save
        format.json { render json: { message: 'success!' } }
        format.html { redirect_to chat_path(@chat) }
      else
        format.json { render json: { message: 'failure!' } }
        format.html { render 'chat/show' }
      end
    end

  end
end
