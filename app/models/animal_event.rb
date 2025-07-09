class AnimalEvent < ApplicationRecord
  belongs_to :animal
  belongs_to :user
  belongs_to :company

  # Validaciones
  validates :event_type, presence: true, inclusion: { 
    in: %w[health_check vaccination deworming treatment sale purchase transfer death other] 
  }
  validates :event_date, presence: true
  validates :description, presence: true

  # Enums
  enum event_type: {
    health_check: 'health_check',
    vaccination: 'vaccination',
    deworming: 'deworming',
    treatment: 'treatment',
    sale: 'sale',
    purchase: 'purchase',
    transfer: 'transfer',
    death: 'death',
    other: 'other'
  }

  # Scopes
  scope :recent, -> { order(event_date: :desc) }
  scope :by_type, ->(type) { where(event_type: type) }
  scope :by_date_range, ->(start_date, end_date) { 
    where(event_date: start_date..end_date) 
  }

  # Métodos
  def event_type_display
    case event_type
    when 'health_check'
      'Chequeo de Salud'
    when 'vaccination'
      'Vacunación'
    when 'deworming'
      'Desparasitación'
    when 'treatment'
      'Tratamiento'
    when 'sale'
      'Venta'
    when 'purchase'
      'Compra'
    when 'transfer'
      'Transferencia'
    when 'death'
      'Muerte'
    when 'other'
      'Otro'
    else
      event_type.humanize
    end
  end

  def days_ago
    (Date.current - event_date).to_i
  end

  def is_recent?
    days_ago <= 30
  end
end
