class ChangeDefaultPlacesForWorkshops < ActiveRecord::Migration[7.2]
  def change
    change_column_default :workshops, :places, 10
  end
end
