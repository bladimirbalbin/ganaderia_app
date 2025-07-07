class AddIsProviderToCompanies < ActiveRecord::Migration[7.1]
  def change
    add_column :companies, :is_provider, :boolean
  end
end
