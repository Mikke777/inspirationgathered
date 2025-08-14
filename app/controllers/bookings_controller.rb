class BookingsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_booking, only: %i[show destroy chat]
  before_action :authorize_user!, only: %i[show chat]

  def show
    @messages = @booking.messages
  end

  def create
    @workshop = Workshop.find(params[:workshop_id])
    if @workshop.can_book?
      handle_booking_creation
    else
      redirect_to @workshop, alert: t('bookings.no_places')
    end
  end

  def chat
    @messages = @booking.messages.order(created_at: :asc)
    @messages.where.not(user: current_user).find_each do |message|
      message.update(read: true)
    end
    @other_user = @booking.user == current_user ? @booking.workshop.user : @booking.user
  end

  def destroy
    @booking = current_user.bookings.find(params[:id])
    @workshop = @booking.workshop
    @booking.destroy
    redirect_to @booking.workshop, notice: t('bookings.canceled')
  end

  private

  def set_booking
    @booking = Booking.find(params[:id])
  end

  def handle_booking_creation
    @booking = @workshop.bookings.build(user: current_user)
    if @booking.save
      redirect_to @workshop, notice: t('bookings.success')
    else
      redirect_to @workshop, alert: t('bookings.failure')
    end
  end

  def authorize_user!
    return if @booking.user == current_user || @booking.workshop.user == current_user

    redirect_to root_path, alert: t('bookings.unauthorized')
  end
end
