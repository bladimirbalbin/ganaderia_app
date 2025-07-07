class User < ApplicationRecord  
  belongs_to :company
  belongs_to :role

  # Devise modules
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Validaciones
  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
  validates :company, presence: true
  validates :role, presence: true

  def admin?
    role.name == "Admin"
  end

  def provider?
    company.is_provider?
  end

  def membership_active?
    company.membership_active?
  end

  def can_create_more_users?
    company.can_create_more_users?
  end

  def veterinario?
    role&.name == "Veterinario"
  end         
end
