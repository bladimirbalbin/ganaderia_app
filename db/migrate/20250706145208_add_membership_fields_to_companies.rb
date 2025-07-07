class AddMembershipFieldsToCompanies < ActiveRecord::Migration[7.1]
  def change
    add_column :companies, :membership_plan, :string
    add_column :companies, :users_limit, :integer
    add_column :companies, :active_until, :date
    #add_column :companies, :active, :boolean
  end
end
