class StaredsController < ApplicationController

  def index
    @stareds = Stared.where(user_id: user.id)
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
  end

  def destroy
    transaction_success = false
    begin
      ActiveRecord::Base.transaction do
        Rails.logger.info "Finding Stared record for user_id: #{current_user.id}, message_id: #{params[:id]}"
        stared = Stared.lock("FOR UPDATE").find_by(user_id: current_user.id, message_id: params[:id])
        if stared
          Rails.logger.info "Deleting record with id: #{stared.id}"
          stared.destroy!
          Rails.logger.info "Deleted record with id: #{stared.id}"
        else
          Rails.logger.warn "Record not found for user_id: #{current_user.id}, message_id: #{params[:id]}"
          raise ActiveRecord::RecordNotFound, "Stared record not found"
        end
      end
      transaction_success = true
    rescue => e
      Rails.logger.error "Transaction failed: #{e.message}"
    end

    if transaction_success
      render json: { starred: true }
    else
      render json: { starred: false }, status: :unprocessable_entity
    end
  end

end
