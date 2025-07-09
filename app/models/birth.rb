class Birth < ApplicationRecord
  belongs_to :animal
  belongs_to :company

  # Validaciones
  validates :birth_date, presence: true
  validates :calf_gender, presence: true, inclusion: { in: %w[male female] }
  validates :calf_weight, presence: true, numericality: { greater_than: 0 }

  # Enums
  enum calf_gender: { male: 'male', female: 'female' }

  # Scopes
  scope :recent, -> { order(birth_date: :desc) }
  scope :by_date_range, ->(start_date, end_date) { 
    where(birth_date: start_date..end_date) 
  }
  scope :male_calves, -> { where(calf_gender: 'male') }
  scope :female_calves, -> { where(calf_gender: 'female') }

  # Métodos
  def days_since_birth
    (Date.current - birth_date).to_i
  end

  def is_recent?
    days_since_birth <= 30
  end

  def calf_age_in_days
    days_since_birth
  end

  def calf_age_in_weeks
    (days_since_birth / 7).to_i
  end

  def calf_age_in_months
    (days_since_birth / 30.44).to_i
  end

  def calf_gender_display
    calf_gender == 'male' ? 'Macho' : 'Hembra'
  end

  def weight_category
    case calf_weight
    when 0..25
      'Bajo peso'
    when 26..35
      'Peso normal'
    when 36..45
      'Buen peso'
    else
      'Excelente peso'
    end
  end
end
