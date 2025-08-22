# To deliver this notification:
#
# NewMessageNotifier.with(record: @post, message: "New post").deliver(User.all)

class NewMessageNotifier < ApplicationNotifier
  deliver_by :database
  deliver_by :action_cable do |config|
    config.channel = "Noticed::NotificationChannel"
    config.stream = -> { recipient }
    config.message = -> { params.merge(user_id: recipient.id) }
  end
  # deliver_by :turbo_stream do |config|
  # config.partial = "shared/notifications_badge"
  # config.target = -> { "notifications_badge" }
  # end

  required_param :message
  # Add your delivery methods
  #
  # deliver_by :email do |config|
  #   config.mailer = "UserMailer"
  #   config.method = "new_post"
  # end
  #
  # bulk_deliver_by :slack do |config|
  #   config.url = -> { Rails.application.credentials.slack_webhook_url }
  # end
  #
  # deliver_by :custom do |config|
  #   config.class = "MyDeliveryMethod"
  # end

  # Add required params
  #
  # required_param :message

  # Compute recipients without having to pass them in
  #
  # recipients do
  #   params[:record].thread.all_authors
  # end
end
