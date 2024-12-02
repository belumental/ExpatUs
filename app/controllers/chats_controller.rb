class ChatsController < ApplicationController
  # before_action :authenticate_user!, only: :new
  # def index
  # end

  before_action :authenticate_user!, only: [:new, :create, :show]

  def new
    @chat = Chat.new
  end

  def create
    @chat = Chat.new(chat_params)
    @chat.user = current_user

    if @chat.save
      redirect_to list_path(@chat), notice: "Your group chas has been succesfully created!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @chat = Chat.find(params[:id])
    @message = Message.new

    if current_user.chats.include?(@chat)
      @joined = true
    else
      @joined = false
    end
  end

  def list_by_user
    unless params[:query].present?
      my_messages = Message.where(user_id: current_user.id)

      # to get the chats we clicked 'join' for
      chats = current_user.chats

      # to get the chats we have written a message in
      my_messages.each do |my_message|
        unless chats.include?(my_message.chat)
          chats.push(my_message.chat)
        end
      end

      # @chats = User.find(current_user.id).chats
      @chats_with_messages_count = []
      online_num = self.compute_online_user_num_on_chat.to_h
      chats.each_with_index do |chat, index|
        @chats_with_messages_count[index] = chat.attributes.dup
        @chats_with_messages_count[index]["msgcount"] = Message.where(chat_id: chat.id).count
        online_num.keys.each do |key|
          if @chats_with_messages_count[index]['id'] == key
            @chats_with_messages_count[index]["online_num"] = online_num[key]
          end
        end
      end
    else
      self.list
    end
  end

  def list
    @user = current_user
    @chats = Chat.all
    if params[:query].present?
      @chats = Chat.search_by_title_and_synopsis(params[:query])
    else
      @chats = Chat.all
    end
  end

  def created_by_user
    def list_by_user
      unless params[:query].present?
        my_messages = Message.where(user_id: current_user.id)

        # to get the chats we clicked 'join' for
        chats = current_user.chats

        # to get the chats we have written a message in
        my_messages.each do |my_message|
          unless chats.include?(my_message.chat)
            chats.push(my_message.chat)
          end
        end

        # @chats = User.find(current_user.id).chats
        @chats_with_messages_count = []
        online_num = self.compute_online_user_num_on_chat.to_h
        chats.each_with_index do |chat, index|
          @chats_with_messages_count[index] = chat.attributes.dup
          @chats_with_messages_count[index]["msgcount"] = Message.where(chat_id: chat.id).count
          online_num.keys.each do |key|
            if @chats_with_messages_count[index]['id'] == key
              @chats_with_messages_count[index]["online_num"] = online_num[key]
            end
          end
        end
      else
        self.list
      end
    end

    def list
      @user = current_user
      @chats = Chat.all
      if params[:query].present?
        @chats = Chat.search_by_title_and_synopsis(params[:query])
      else
        @chats = Chat.all
      end
    end

    def created_by_user
      @created_chats = Chat.where(user_id: current_user.id)
    end
  end

  private

  def chat_params
    params.require(:chat).permit(:title, :category, :description)
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
    counts
  end
end
