class Message < ApplicationRecord
  belongs_to :user
  belongs_to :booking
  after_create_commit :notify_recipient
  has_many :notifications, class_name: "Noticed::Notification", as: :record, dependent: :destroy

  validates :content, presence: true
  after_create_commit :broadcast_message

  scope :unread, -> { where(read: false) }

  encrypts :content

  private

  def broadcast_message
    broadcast_append_to "booking_#{booking.id}_messages",
                        partial: "messages/message",
                        locals: { message: self, user: user },
                        target: "messages"
  end

  def notify_recipient
    recipient = booking.user == user ? booking.workshop.user : booking.user
    NewMessageNotifier.with(message: self, record: self).deliver_later(recipient)
    Turbo::StreamsChannel.broadcast_replace_to(
      "user_#{recipient.id}_notifications",
      target: "notifications_badge",
      partial: "shared/notifications_badge",
      locals: { current_user: recipient }
    )
  end
end
