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
  end

  def list
    @chats = Chat.all
    if params[:query].present?
      @chats = Chat.search_by_title_and_synopsis(params[:query])
    else
      @chats = Chat.all
    end
  end

  private

  def chat_params
    params.require(:chat).permit(:title, :category, :description)
  end
end
