class CreateMedicalRecords < ActiveRecord::Migration[7.1]
  def change
    create_table :medical_records do |t|
      t.references :animal, null: false, foreign_key: true
      t.date :date
      t.text :diagnosis
      t.text :treatment
      t.string :veterinarian
      t.text :notes

      t.timestamps
    end
  end
end
