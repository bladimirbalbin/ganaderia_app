class AddAnimalTypeToAnimals < ActiveRecord::Migration[7.1]
  def change
    add_column :animals, :animal_type, :string
  end
end
