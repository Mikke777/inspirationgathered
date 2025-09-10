class AddRecordToNoticedNotifications < ActiveRecord::Migration[8.0]
  def change
    add_reference :noticed_notifications, :record, polymorphic: true, index: true
  end
end
