class AddObservationsToAnimals < ActiveRecord::Migration[7.1]
  def change
    add_column :animals, :observations, :text
  end
end
