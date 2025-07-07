class AddPeriodToMembershipPlans < ActiveRecord::Migration[7.1]
  def change
    add_column :membership_plans, :period, :string
  end
end
