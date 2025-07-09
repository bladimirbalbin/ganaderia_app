class CreatePalpations < ActiveRecord::Migration[7.1]
  def change
    create_table :palpations do |t|
      t.references :animal, null: false, foreign_key: true
      t.date :palpation_date
      t.string :result
      t.string :veterinarian
      t.text :notes
      t.references :company, null: false, foreign_key: true

      t.timestamps
    end
  end
end
