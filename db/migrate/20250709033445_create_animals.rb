class CreateAnimals < ActiveRecord::Migration[7.1]
  def change
    create_table :animals do |t|
      t.string :name
      t.string :breed
      t.date :birth_date
      t.decimal :weight
      t.string :gender
      t.string :ear_tag
      t.string :status
      t.references :company, null: false, foreign_key: true

      t.timestamps
    end
  end
end
