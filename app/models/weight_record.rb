class WeightRecord < ApplicationRecord
  belongs_to :animal
  belongs_to :company

  # Enums
  enum method: {
    scale: 'scale',
    tape: 'tape',
    visual: 'visual',
    other: 'other'
  }

  enum condition: {
    very_thin: 'very_thin',
    thin: 'thin',
    normal: 'normal',
    fat: 'fat',
    very_fat: 'very_fat'
  }

  # Validaciones
  validates :weight_date, presence: true
  validates :weight, presence: true, numericality: { greater_than: 0 }

  # Scopes
  scope :recent, -> { order(weight_date: :desc) }
  scope :by_date_range, ->(start_date, end_date) { 
    where(weight_date: start_date..end_date) 
  }
  scope :by_weight_range, ->(min_weight, max_weight) { 
    where(weight: min_weight..max_weight) 
  }

  # Métodos
  def days_since_weighing
    (Date.current - weight_date).to_i
  end

  def is_recent?
    days_since_weighing <= 30
  end

  def weight_category
    case weight
    when 0..200
      'Ternero/a'
    when 201..400
      'Novillo/a'
    when 401..600
      'Toro/Vaca joven'
    when 601..800
      'Toro/Vaca adulto'
    else
      'Toro/Vaca pesado'
    end
  end

  def weight_change_from_previous
    previous_record = animal.weight_records
      .where('weight_date < ?', weight_date)
      .order(weight_date: :desc)
      .first
    
    return nil unless previous_record
    
    weight - previous_record.weight
  end

  def daily_weight_gain
    previous_record = animal.weight_records
      .where('weight_date < ?', weight_date)
      .order(weight_date: :desc)
      .first
    
    return nil unless previous_record
    
    days_between = (weight_date - previous_record.weight_date).to_i
    return 0 if days_between == 0
    
    (weight - previous_record.weight) / days_between
  end

  def weight_percentage_change
    previous_record = animal.weight_records
      .where('weight_date < ?', weight_date)
      .order(weight_date: :desc)
      .first
    
    return nil unless previous_record
    
    ((weight - previous_record.weight) / previous_record.weight * 100).round(2)
  end
end
