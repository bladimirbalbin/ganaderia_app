class AddMembershipPlanToCompanies < ActiveRecord::Migration[7.1]
  def change
    add_reference :companies, :membership_plan, foreign_key: true
  end
end
