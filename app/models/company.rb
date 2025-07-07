class Company < ApplicationRecord
  has_many :users, dependent: :destroy
  belongs_to :membership_plan, optional: true
  has_one :customer, dependent: :destroy
  accepts_nested_attributes_for :customer
  # Validaciones
  validates :name, presence: true
  validates :membership_plan, presence: true, unless: :is_provider?
  validates :users_limit, numericality: { only_integer: true, greater_than: 0 }, unless: :is_provider?
  validates :active_until, presence: true, unless: :is_provider?
  validate  :users_limit_cannot_be_less_than_current_users, unless: :is_provider?

  # Por defecto no es proveedora
  attribute :is_provider, :boolean, default: false

  # Comprueba si la membresía está activa
  def membership_active?
    is_provider? || (active? && active_until && active_until >= Date.today)
  end

  # Comprueba si puede crear más usuarios según el límite
  def can_create_more_users?
    return true if is_provider?
    return false unless membership_active?
    users.count < (users_limit || 0)
  end

  # Mensaje explicativo para la vista o admin
  def users_status_message
    if is_provider?
      "Compañía proveedora: sin límite de usuarios"
    elsif !membership_active?
      "La membresía no está activa"
    elsif can_create_more_users?
      remaining = users_limit - users.count
      "Puedes crear #{remaining} usuario(s) más"
    else
      "Has alcanzado el límite de usuarios permitidos"
    end
  end

  # Evitar que se baje el límite por debajo de usuarios existentes
  def users_limit_cannot_be_less_than_current_users
    if users_limit.present? && users_limit < users.count
      errors.add(:users_limit, "no puede ser menor que el número actual de usuarios (#{users.count})")
    end
  end

  # Método para activar membresía: asigna plan, usuarios_limit y fecha fin
  def activate_membership!(plan)
    self.membership_plan = plan
    self.users_limit = plan.users_limit
    self.active_until = Date.today + plan.duration_in_days
    self.active = true
    save!
  end
end

