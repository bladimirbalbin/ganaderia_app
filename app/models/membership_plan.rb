class MembershipPlan < ApplicationRecord
    has_many :companies
    validates :name, :price, :users_limit, :duration_in_days, presence: true
end
