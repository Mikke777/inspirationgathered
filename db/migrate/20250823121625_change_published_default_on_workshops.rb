class ChangePublishedDefaultOnWorkshops < ActiveRecord::Migration[8.0]
  def change
    change_column_default :workshops, :published, false
  end
end
