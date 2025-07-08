class Customer < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :company, optional: true

  enum customer_type: { person: 0, company: 1, veterinarian: 2 }

  validates :customer_type, presence: true
  validates :document_number, presence: true, unless: -> { skip_document_validation }
  validates :document_type, presence: true, unless: -> { skip_document_validation }
  validates :mobile_phone1, presence: true  
  validates :address1, presence: true  

  # Validaciones condicionales para nombres según tipo de cliente
  # Si es persona o veterinario, los nombres son obligatorios
  # Si es empresa, no son obligatorios
  # Esto permite que una empresa pueda no tener nombres asociados
  # pero un veterinario o persona siempre debe tenerlos
  validates :first_name, presence: true, if: -> { person? || veterinarian? }
  validates :last_name, presence: true, if: -> { person? || veterinarian? }
  scope :by_type, ->(type) { where(customer_type: type) if type.present? }
  enum document_type: {
  cc: "C",   # Cédula de ciudadanía
  ce: "E",   # Cédula de extranjería
  nit: "N",  # NIT
  ti: "T"    # Tarjeta de identidad
  }
  attr_accessor :skip_document_validation
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
