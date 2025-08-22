class NotificationsController < ApplicationController
  before_action :authenticate_user!

  def mark_as_read
    notification = current_user.notifications.find(params[:id])
    notification.mark_as_read!
    redirect_to params[:redirect_path].presence || request.referer || root_path
  end
end
