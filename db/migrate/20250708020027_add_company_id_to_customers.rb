class AddCompanyIdToCustomers < ActiveRecord::Migration[7.1]
  def change
    add_reference :customers, :company, null: false, foreign_key: true
  end
end
