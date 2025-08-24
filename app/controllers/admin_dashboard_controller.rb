class AdminDashboardController < ApplicationController
  before_action :authenticate_user!
  before_action :authenticate_admin!

  def index
    @workshops_to_review = Workshop.where(date: Time.zone.today.beginning_of_day.., published: false)
  end

  private

  def authenticate_admin!
    redirect_to new_user_session_path, alert: t('admin_dashboard.not_authorized') unless current_user&.admin?
  end
end
