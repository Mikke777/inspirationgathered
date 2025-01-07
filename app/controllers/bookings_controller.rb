class BookingsController < ApplicationController
  before_action :authenticate_user!

  def create
    @workshop = Workshop.find(params[:workshop_id])
    @booking = @workshop.bookings.build(user: current_user)

    if @booking.save
      redirect_to @workshop, notice: 'You have successfully booked this workshop.'
    else
      redirect_to @workshop, alert: 'Unable to book this workshop.'
    end
  end

  def destroy
    @booking = current_user.bookings.find(params[:id])
    @workshop = @booking.workshop
    @booking.destroy
    redirect_to @booking.workshop, notice: 'Your booking has been canceled.'
  end
end
