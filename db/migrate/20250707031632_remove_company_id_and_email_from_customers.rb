class RemoveCompanyIdAndEmailFromCustomers < ActiveRecord::Migration[7.1]
  def change
    remove_column :customers, :company_id, :integer
    remove_column :customers, :email, :string
  end
end
