class CreateMilkProductions < ActiveRecord::Migration[7.1]
  def change
    create_table :milk_productions do |t|
      t.references :animal, null: false, foreign_key: true
      t.date :production_date
      t.decimal :quantity
      t.string :period
      t.text :notes
      t.references :company, null: false, foreign_key: true

      t.timestamps
    end
  end
end
