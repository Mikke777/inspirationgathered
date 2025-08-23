class WorkshopsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :set_workshop, only: %i[edit update destroy]
  before_action :set_workshop_for_show, only: [:show]

  def index
    @workshops = Workshop.where(date: Time.zone.today.beginning_of_day.., published: true)
    @workshops = @workshops.global_search(params[:query]) if params[:query].present?
    @markers = @workshops.geocoded.map do |workshop|
      {
        lat: workshop.latitude,
        lng: workshop.longitude,
        info_window_html: render_to_string(partial: "info_window", locals: { workshop: workshop })
      }
    end
  end

  def show
    @markers = [{
      lat: @workshop.latitude,
      lng: @workshop.longitude,
      info_window_html: render_to_string(partial: "info_window", locals: { workshop: @workshop })
    }]
  end

  def new
    @workshop = current_user.workshops.build
  end

  def edit
  end

  def create
    @workshop = current_user.workshops.build(workshop_params)
    if @workshop.save
      redirect_to @workshop, notice: t('workshops.created')
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @workshop.update(workshop_params)
      redirect_to @workshop, notice: t('workshops.updated')
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    unless @workshop.user == current_user || current_user.admin?
      redirect_to root_path, alert: "Not authorized"
      return
    end
    @workshop.destroy
    redirect_to root_path, notice: t('workshops.destroyed')
  end

  def booked
    @booked_workshops = current_user.booked_workshops.joins(:bookings).where(bookings: { status: "accepted" })
    @upcoming_workshops = @booked_workshops.where(date: Time.zone.today.beginning_of_day..)
    @past_workshops = @booked_workshops.where(date: ...Time.zone.today.beginning_of_day)
  end

  def dashboard
    @workshops = current_user.workshops.includes(:bookings)
    @upcoming_workshops = @workshops.where(date: Time.zone.today.beginning_of_day..).order(date: :asc)
    @past_workshops = @workshops.where(date: ...Time.zone.today.beginning_of_day).order(date: :desc)
  end

  def inbox
    @bookings = current_user.bookings.joins(:workshop).where(workshops: { date: Time.zone.today.beginning_of_day.. },
                                                             status: "accepted")
    @workshops = current_user.workshops.includes(:bookings).where(date: Time.zone.today.beginning_of_day..)
  end

  def approve
    @workshop = Workshop.find(params[:id])
    @workshop.update(published: true)
    redirect_to root_path, notice: "Workshop approved!"
  end

  private

  def set_workshop
    @workshop = Workshop.find(params[:id])
  end

  def set_workshop_for_show
    @workshop = Workshop.find(params[:id])
  end

  def workshop_params
    params.expect(workshop: %i[title description photo date address latitude longitude places])
  end
end
