class AddSubscriptionStatusToCompanies < ActiveRecord::Migration[7.1]
  def change
    add_column :companies, :subscription_status, :string, default: "free"
  end
end
