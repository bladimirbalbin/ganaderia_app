class Animal < ApplicationRecord
  belongs_to :company
  has_many :animal_events, dependent: :destroy
  has_many :inseminations, dependent: :destroy
  has_many :palpations, dependent: :destroy
  has_many :births, dependent: :destroy
  has_many :milk_productions, dependent: :destroy
  has_many :weight_records, dependent: :destroy
  has_many :medical_records, dependent: :destroy

  # Validaciones
  validates :name, presence: true
  validates :breed, presence: true
  validates :birth_date, presence: true
  validates :gender, presence: true, inclusion: { in: %w[male female] }
  validates :ear_tag, presence: true, uniqueness: { scope: :company_id }
  validates :status, presence: true, inclusion: { in: %w[active inactive sold dead] }
  validates :animal_type, presence: true, inclusion: { in: %w[bovine equine porcine ovine caprine] }

  # Enums
  enum gender: { male: 'male', female: 'female' }
  enum status: { active: 'active', inactive: 'inactive', sold: 'sold', dead: 'dead' }
  enum animal_type: { bovine: 'bovine', equine: 'equine', porcine: 'porcine', ovine: 'ovine', caprine: 'caprine' }

  # Scopes
  scope :active, -> { where(status: 'active') }
  scope :females, -> { where(gender: 'female') }
  scope :males, -> { where(gender: 'male') }
  scope :by_company, ->(company_id) { where(company_id: company_id) }
  scope :by_type, ->(type) { where(animal_type: type) }

  # Métodos
  def age_in_months
    return 0 unless birth_date
    ((Date.current - birth_date) / 30.44).to_i
  end

  def age_in_years
    return 0 unless birth_date
    ((Date.current - birth_date) / 365.25).to_i
  end

  def current_weight
    weight_records.order(weight_date: :desc).first&.weight || weight
  end

  def last_insemination
    inseminations.order(insemination_date: :desc).first
  end

  def last_palpation
    palpations.order(palpation_date: :desc).first
  end

  def last_birth
    births.order(birth_date: :desc).first
  end

  def last_medical_record
    medical_records.order(date: :desc).first
  end

  def is_pregnant?
    return false unless gender == 'female'
    last_palpation&.result == 'pregnant'
  end

  def pregnancy_status
    return 'N/A' unless gender == 'female'
    return 'Pregnant' if is_pregnant?
    return 'Not pregnant' if last_palpation&.result == 'not_pregnant'
    'Unknown'
  end

  def days_since_last_insemination
    return nil unless last_insemination
    (Date.current - last_insemination.insemination_date).to_i
  end

  def days_since_last_birth
    return nil unless last_birth
    (Date.current - last_birth.birth_date).to_i
  end

  def days_since_last_medical_check
    return nil unless last_medical_record
    (Date.current - last_medical_record.date).to_i
  end

  def average_milk_production(period = 30)
    return nil unless bovine?
    milk_productions
      .where('production_date >= ?', period.days.ago)
      .average(:quantity)
  end

  def total_milk_production(period = 30)
    return nil unless bovine?
    milk_productions
      .where('production_date >= ?', period.days.ago)
      .sum(:quantity)
  end

  def weight_growth_rate(days = 30)
    recent_records = weight_records
      .where('weight_date >= ?', days.days.ago)
      .order(:weight_date)
    
    return nil if recent_records.count < 2
    
    first_weight = recent_records.first.weight
    last_weight = recent_records.last.weight
    days_between = (recent_records.last.weight_date - recent_records.first.weight_date).to_i
    
    return 0 if days_between == 0
    
    ((last_weight - first_weight) / days_between).round(2)
  end

  def display_name
    "#{name} (#{ear_tag})"
  end

  def full_info
    "#{name} - #{animal_type.humanize} - #{breed} - #{gender.humanize} - #{age_in_years} años"
  end

  def type_display_name
    case animal_type
    when 'bovine'
      'Bovino'
    when 'equine'
      'Equino'
    when 'porcine'
      'Porcino'
    when 'ovine'
      'Ovino'
    when 'caprine'
      'Caprino'
    else
      animal_type.humanize
    end
  end

  # Métodos específicos para equinos
  def is_equine?
    animal_type == 'equine'
  end

  def is_bovine?
    animal_type == 'bovine'
  end

  def medical_history_summary
    medical_records.order(date: :desc).limit(5)
  end

  def has_recent_medical_issues(days = 30)
    medical_records.where('date >= ?', days.days.ago).exists?
  end

  def has_observations?
    observations.present?
  end

  def short_observations
    observations&.truncate(100)
  end
end
