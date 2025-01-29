class AddDefaultToReadInMessages < ActiveRecord::Migration[7.2]
  def change
    change_column_default :messages, :read, false
  end
end
