class CreateCompanies < ActiveRecord::Migration[7.1]
  def change
    create_table :companies do |t|
      t.string :name
      t.string :contact_email
      t.boolean :active

      t.timestamps
    end
  end
end
