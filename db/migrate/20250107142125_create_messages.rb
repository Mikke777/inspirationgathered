class CreateMessages < ActiveRecord::Migration[7.2]
  def change
    create_table :messages do |t|
      t.text :content
      t.references :user, null: false, foreign_key: true
      t.references :booking, null: false, foreign_key: true

      t.timestamps
    end
  end
end
