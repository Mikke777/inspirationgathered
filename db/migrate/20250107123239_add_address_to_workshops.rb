class AddAddressToWorkshops < ActiveRecord::Migration[7.2]
  def change
    add_column :workshops, :address, :string
  end
end
