class MilkProduction < ApplicationRecord
  belongs_to :animal
  belongs_to :company

  # Validaciones
  validates :production_date, presence: true
  validates :quantity, presence: true, numericality: { greater_than: 0 }
  validates :period, presence: true, inclusion: { 
    in: %w[morning afternoon evening total] 
  }

  # Enums
  enum period: {
    morning: 'morning',
    afternoon: 'afternoon',
    evening: 'evening',
    total: 'total'
  }

  # Scopes
  scope :recent, -> { order(production_date: :desc) }
  scope :by_date_range, ->(start_date, end_date) { 
    where(production_date: start_date..end_date) 
  }
  scope :by_period, ->(period) { where(period: period) }
  scope :daily_totals, -> { where(period: 'total') }

  # Métodos
  def days_since_production
    (Date.current - production_date).to_i
  end

  def is_recent?
    days_since_production <= 7
  end

  def period_display
    case period
    when 'morning'
      'Mañana'
    when 'afternoon'
      'Tarde'
    when 'evening'
      'Noche'
    when 'total'
      'Total del día'
    else
      period.humanize
    end
  end

  def production_category
    case quantity
    when 0..5
      'Baja producción'
    when 6..10
      'Producción media'
    when 11..15
      'Buena producción'
    else
      'Excelente producción'
    end
  end

  def liters_per_hour
    case period
    when 'morning'
      quantity / 4.0 # 4 horas de ordeño matutino
    when 'afternoon'
      quantity / 4.0 # 4 horas de ordeño vespertino
    when 'evening'
      quantity / 4.0 # 4 horas de ordeño nocturno
    else
      quantity / 12.0 # 12 horas totales
    end
  end
end
