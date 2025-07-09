class CreateInseminations < ActiveRecord::Migration[7.1]
  def change
    create_table :inseminations do |t|
      t.references :animal, null: false, foreign_key: true
      t.string :bull_name
      t.date :insemination_date
      t.string :technician
      t.text :notes
      t.references :company, null: false, foreign_key: true

      t.timestamps
    end
  end
end
