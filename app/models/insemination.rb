class Insemination < ApplicationRecord
  belongs_to :animal
  belongs_to :company

  # Validaciones
  validates :bull_name, presence: true
  validates :insemination_date, presence: true
  validates :technician, presence: true

  # Scopes
  scope :recent, -> { order(insemination_date: :desc) }
  scope :by_date_range, ->(start_date, end_date) { 
    where(insemination_date: start_date..end_date) 
  }
  scope :successful, -> { joins(:animal).where(animals: { status: 'active' }) }

  # Métodos
  def days_since_insemination
    (Date.current - insemination_date).to_i
  end

  def is_recent?
    days_since_insemination <= 30
  end

  def expected_birth_date
    insemination_date + 280.days # 9 meses aproximadamente
  end

  def days_until_expected_birth
    (expected_birth_date - Date.current).to_i
  end

  def is_pregnancy_period?
    days_since_insemination >= 21 && days_since_insemination <= 300
  end

  def pregnancy_status
    if days_since_insemination < 21
      'Muy temprano para confirmar'
    elsif days_since_insemination > 300
      'Período de gestación excedido'
    else
      'En período de gestación'
    end
  end
end
