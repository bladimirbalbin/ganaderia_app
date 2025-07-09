class CreateBirths < ActiveRecord::Migration[7.1]
  def change
    create_table :births do |t|
      t.references :animal, null: false, foreign_key: true
      t.date :birth_date
      t.string :calf_gender
      t.decimal :calf_weight
      t.string :calf_name
      t.text :notes
      t.references :company, null: false, foreign_key: true

      t.timestamps
    end
  end
end
