class StaredsController < ApplicationController

  def index
    @stareds = Stared.where(user_id: current_user.id)
  end

  def show
    @starred_messages = current_user.stareds.includes(:message_id).map(&:message_id)
    render json: { starred_messages: @starred_messages }
  end

  def create
    transaction_success = false
    begin
      ActiveRecord::Base.transaction do
        params[:messageIds].each do |msgId|
          Stared.create!(user_id: current_user.id, message_id: msgId)
        end
        transaction_success = true
      end
    rescue => e
      puts "Transaction failed: #{e.message}"
    end
    if transaction_success
      render json: { starred: true }
    else
      render json: { starred: false }, status: :unprocessable_entity
    end
    # Rails.logger.error "xxxxxxxxx: #{params[:messageIds]}"
    # @message = Message.find(params[:message_id])
    # @starred_message = current_user.stareds.find(params[:message_id])

    # if @starred_message.save
    #   render json: { starred: true }
    # else
    #   render json: { error: @starred.errors.full_messages }, status: :unprocessable_entity
    # end
  end
end
