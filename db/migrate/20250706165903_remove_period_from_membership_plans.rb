class RemovePeriodFromMembershipPlans < ActiveRecord::Migration[7.1]
  def change
    remove_column :membership_plans, :period, :string
  end
end
