class WorkshopsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_workshop, only: [:edit, :update, :destroy]
  before_action :set_workshop_for_show, only: [:show]

  def index
    @workshops = Workshop.where('date >= ?', Date.today.beginning_of_day)
    if params[:query].present?
      @workshops = @workshops.global_search(params[:query])
    end
    @markers = @workshops.geocoded.map do |workshop|
      {
        lat: workshop.latitude,
        lng: workshop.longitude,
        info_window_html: render_to_string(partial: "info_window", locals: { workshop: workshop }),
      }
    end
  end

  def show
    @markers = [{
      lat: @workshop.latitude,
      lng: @workshop.longitude,
      info_window_html: render_to_string(partial: "info_window", locals: { workshop: @workshop }),
    }]
  end

  def new
    @workshop = current_user.workshops.build
  end

  def create
    @workshop = current_user.workshops.build(workshop_params)
    if @workshop.save
      redirect_to @workshop, notice: 'Workshop was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @workshop.update(workshop_params)
      redirect_to @workshop, notice: 'Workshop was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @workshop.destroy
    redirect_to root_path, notice: 'Workshop was successfully destroyed.'
  end

  def booked
    @booked_workshops = current_user.booked_workshops
    @upcoming_workshops = @booked_workshops.where('date >= ?', Date.today.beginning_of_day)
    @past_workshops = @booked_workshops.where('date < ?', Date.today.beginning_of_day)
  end

  def dashboard
    @workshops = current_user.workshops.includes(:bookings)
    @upcoming_workshops = @workshops.where('date >= ?', Date.today.beginning_of_day).order(date: :asc)
    @past_workshops = @workshops.where('date < ?', Date.today.beginning_of_day).order(date: :desc)
  end

  def inbox
    @bookings = current_user.bookings.includes(:workshop)
    @workshops = current_user.workshops.includes(:bookings)
  end

  private

  def set_workshop
    @workshop = current_user.workshops.find(params[:id])
  end

  def set_workshop_for_show
    @workshop = Workshop.find(params[:id])
  end

  def workshop_params
    params.require(:workshop).permit(:title, :description, :photo, :date, :address, :latitude, :longitude)
  end
end
