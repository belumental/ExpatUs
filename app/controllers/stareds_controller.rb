class StaredsController < ApplicationController
  def show
    @starred_messages = current_user.stareds.includes(:message_id).map(&:message_id)
    render json: { starred_messages: @starred_messages }
  end

  def create
    @message = Message.find(params[:message_id])
    @starred_message = current_user.stareds.find(params[:message_id])

    if @starred_message.save
      render json: { starred: true }
    else
      render json: { error: @starred.errors.full_messages }, status: :unprocessable_entity
    end
  end
end
