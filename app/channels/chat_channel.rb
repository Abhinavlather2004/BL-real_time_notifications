class ChatChannel < ApplicationCable::Channel
  def subscribed
    stream_from "chat_channel#{params[:user_id]}"
    Rails.logger.info "Subscribed to ChatChannel"
  end

  def unsubscribed
    Rails.logger.info("unsubscribed from channel")
  end
end

