class ChatsController < ApplicationController
  # before_action :authenticate_user!, only: :new
  # def index
  # end

  before_action :authenticate_user!, only: [:new, :create, :show]

  def new
    # Add your new action implementation
  end

  def create
  end

  def show
  end

  def list_by_user
    @chats = current_user.chats
    @chats_with_messages_count = []
    @chats.each_with_index do |chat, index|
      @chats_with_messages_count[index] = chat.attributes.dup
      @chats_with_messages_count[index]["msgcount"] = Message.where(chat_id: chat.id).count
    end
    # raise
  end
end
