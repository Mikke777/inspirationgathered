class AddCoordinatesToWorkshops < ActiveRecord::Migration[7.2]
  def change
    add_column :workshops, :latitude, :float
    add_column :workshops, :longitude, :float
  end
end
