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

  def list
  end
end
