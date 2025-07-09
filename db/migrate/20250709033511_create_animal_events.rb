class CreateAnimalEvents < ActiveRecord::Migration[7.1]
  def change
    create_table :animal_events do |t|
      t.string :event_type
      t.date :event_date
      t.text :description
      t.references :animal, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.references :company, null: false, foreign_key: true

      t.timestamps
    end
  end
end
