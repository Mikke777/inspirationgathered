class MessagesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_booking
  before_action :authorize_user!

  def create
    @message = @booking.messages.build(message_params)
    @message.user = current_user

    if @message.save
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.append("messages", partial: "messages/message", locals: { message: @message })
        end
        format.html { redirect_to chat_workshop_booking_path(@booking.workshop, @booking), notice: 'Message sent successfully.' }
      end
    else
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace("new_message", partial: "messages/form", locals: { booking: @booking, message: @message })
        end
        format.html { render "bookings/chat", status: :unprocessable_entity }
      end
    end
  end

  private

  def set_booking
    @booking = Booking.find(params[:booking_id])
  end

  def authorize_user!
    unless @booking.user == current_user || @booking.workshop.user == current_user
      redirect_to root_path, alert: 'You are not authorized to perform this action.'
    end
  end

  def message_params
    params.require(:message).permit(:content)
  end
end
