class CreateWeightRecords < ActiveRecord::Migration[7.1]
  def change
    create_table :weight_records do |t|
      t.references :animal, null: false, foreign_key: true
      t.date :weight_date
      t.decimal :weight
      t.text :notes
      t.references :company, null: false, foreign_key: true

      t.timestamps
    end
  end
end
