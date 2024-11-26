class ChatsController < ApplicationController
  # before_action :authenticate_user!, only: :new
  # def index
  # end

  before_action :authenticate_user!, only: [:new, :create, :show]

  def new
    @chat = Chat.new
  end

  def create

  end

  def show
  end

  def list
    @chats = Chat.all
  end
end
