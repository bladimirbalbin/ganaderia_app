class CreateMembershipPlans < ActiveRecord::Migration[7.1]
  def change
    create_table :membership_plans do |t|
      t.string :name
      t.text :description
      t.decimal :price
      t.integer :users_limit
      t.integer :duration_in_days
      t.boolean :active

      t.timestamps
    end
  end
end
