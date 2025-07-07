class User < ApplicationRecord  
  belongs_to :company
  belongs_to :role

  # Devise modules
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Validaciones  
  validates :email, presence: true, uniqueness: true
  validates :password, presence: true, on: :create
  validates :company, presence: true
  validates :role, presence: true
  has_one :customer, dependent: :destroy
  accepts_nested_attributes_for :customer 

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
