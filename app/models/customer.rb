class Customer < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :company, optional: true

  enum customer_type: { person: 0, company: 1, veterinarian: 2 }

  validates :customer_type, presence: true
  validates :document_number, presence: true, uniqueness: true
  validates :first_name, :last_name, :document_number, presence: true
  validates :first_name, presence: true, if: -> { person? || veterinarian? }
  validates :last_name, presence: true, if: -> { person? || veterinarian? }
  scope :by_type, ->(type) { where(customer_type: type) if type.present? }
  require 'csv'
  def full_name
    [first_name, middle_name, last_name, second_last_name].compact.join(' ')
  end
  def self.to_csv
    attributes = %w{id customer_type first_name last_name document_type document_number mobile_phone1 email}
    CSV.generate(headers: true) do |csv|
      csv << attributes
      all.each do |customer|
        csv << attributes.map{ |attr| customer.send(attr) }
      end
    end
  end

end
