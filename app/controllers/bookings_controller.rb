class BookingsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_booking, only: [:show, :destroy, :chat]
  before_action :authorize_user!, only: [:show, :chat]

  def create
    @workshop = Workshop.find(params[:workshop_id])
    @booking = @workshop.bookings.build(user: current_user)

    if @booking.save
      redirect_to @workshop, notice: 'You have successfully booked this workshop.'
    else
      redirect_to @workshop, alert: 'Unable to book this workshop.'
    end
  end

  def show
    @messages = @booking.messages
  end

  def chat
    @messages = @booking.messages.order(created_at: :asc)
    @messages.where.not(user: current_user).update_all(read: true)
    @other_user = @booking.user == current_user ? @booking.workshop.user : @booking.user
  end

  def destroy
    @booking = current_user.bookings.find(params[:id])
    @workshop = @booking.workshop
    @booking.destroy
    redirect_to @booking.workshop, notice: 'Your booking has been canceled.'
  end

  private

  def set_booking
    @booking = Booking.find(params[:id])
  end

  def authorize_user!
    unless @booking.user == current_user || @booking.workshop.user == current_user
      redirect_to root_path, alert: 'You are not authorized to view this page.'
    end
  end
end
