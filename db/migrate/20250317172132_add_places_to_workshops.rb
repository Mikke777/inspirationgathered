class AddPlacesToWorkshops < ActiveRecord::Migration[7.2]
  def change
    add_column :workshops, :places, :integer, default: 0, null: false
  end
end
