class AddDateToWorkshops < ActiveRecord::Migration[7.2]
  def change
    add_column :workshops, :date, :datetime
  end
end
