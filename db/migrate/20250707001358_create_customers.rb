class CreateCustomers < ActiveRecord::Migration[7.1]
  def change
    create_table :customers do |t|

      t.references :user, foreign_key: true, null: true
      t.references :company, foreign_key: true, null: true
      t.integer :customer_type, null: false, default: 0  # 0: persona, 1: empresa, 2: veterinario, etc.

      t.string :first_name
      t.string :middle_name
      t.string :last_name
      t.string :second_last_name
      t.string :document_type
      t.string :document_number
      t.string :address1
      t.string :address2
      t.string :mobile_phone1
      t.string :mobile_phone2
      t.string :landline_phone
      t.string :email      
      t.timestamps
    end
  end
end
