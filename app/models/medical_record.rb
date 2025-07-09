class MedicalRecord < ApplicationRecord
  belongs_to :animal

  # Validaciones
  validates :date, presence: true
  validates :diagnosis, presence: true
  validates :veterinarian, presence: true

  # Scopes
  scope :recent, -> { order(date: :desc) }
  scope :by_date_range, ->(start_date, end_date) { where(date: start_date..end_date) }
  scope :by_veterinarian, ->(vet) { where(veterinarian: vet) }

  # Métodos
  def display_date
    date.strftime("%d/%m/%Y")
  end

  def short_diagnosis
    diagnosis.truncate(100)
  end

  def days_ago
    (Date.current - date).to_i
  end

  def is_recent?(days = 30)
    days_ago <= days
  end
end
