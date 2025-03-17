class UpdateExistingWorkshopsPlaces < ActiveRecord::Migration[7.2]
  def up
    Workshop.where(places: 0).update_all(places: 10)
  end

  def down
    Workshop.where(places: 10).update_all(places: 0)
  end
end
