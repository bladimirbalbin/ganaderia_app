class Palpation < ApplicationRecord
  belongs_to :animal
  belongs_to :company

  # Validaciones
  validates :palpation_date, presence: true
  validates :result, presence: true, inclusion: { 
    in: %w[pregnant not_pregnant empty unknown] 
  }
  validates :veterinarian, presence: true

  # Enums
  enum result: {
    pregnant: 'pregnant',
    not_pregnant: 'not_pregnant',
    empty: 'empty',
    unknown: 'unknown'
  }

  # Scopes
  scope :recent, -> { order(palpation_date: :desc) }
  scope :pregnant, -> { where(result: 'pregnant') }
  scope :not_pregnant, -> { where(result: 'not_pregnant') }
  scope :by_date_range, ->(start_date, end_date) { 
    where(palpation_date: start_date..end_date) 
  }

  # Métodos
  def days_since_palpation
    (Date.current - palpation_date).to_i
  end

  def is_recent?
    days_since_palpation <= 30
  end

  def result_display
    case result
    when 'pregnant'
      'Preñada'
    when 'not_pregnant'
      'No preñada'
    when 'empty'
      'Vacía'
    when 'unknown'
      'Desconocido'
    else
      result.humanize
    end
  end

  def pregnancy_weeks
    return nil unless result == 'pregnant'
    # Estimación aproximada basada en la palpación
    # Esto podría ser más preciso con datos adicionales
    days_since_palpation / 7
  end
end
