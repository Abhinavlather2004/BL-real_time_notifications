require_dependency 'user'


class Api::V1::MessagesController < ApplicationController

  def send_message
    sender = ::User.find(params[:sender_id].to_i)
    recipient = ::User.find(params[:recipient_id].to_i)

    message = Message.new(content: params[:content],
                          sender_id: sender.id,
                          recipient_id: recipient.id
                          )
    
                          
    if message.save
      ActionCable.server.broadcast("chat_channel#{recipient.id.to_s}", { 
        sender: sender.name, message: message.content,timestamp: message.created_at.strftime("%H:%M %p")})

      render json: {message: "message is successfully sent", data: message}, status: :created
    else
      render json: {error: "message is not sent"}, status: :unprocessable_entity
    end
  end

  def get_messages
    messages = Message.all.order(created_at: :asc)
    render json: messages
  rescue StandardError => e
    render json: { error: "Failed to get message", message: e.message }, status: :internal_server_error
  end

end

