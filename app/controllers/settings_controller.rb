class SettingsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_admin!
  before_action :ensure_company_assigned!
  
  def index
    if current_user.provider?
      # Si es proveedor, puede ver estadísticas globales
      @total_users = User.count
      @total_companies = Company.count
      @total_customers = Customer.count
      @total_roles = Role.count
      @total_membership_plans = MembershipPlan.count
      
      @recent_users = User.includes(:company, :role).where.not(company: nil, role: nil).order(created_at: :desc).limit(5)
      @recent_companies = Company.includes(:membership_plan).order(created_at: :desc).limit(5)
      
      # Calcular estadísticas usando métodos del modelo
      @system_stats = {
        users_this_month: User.where('created_at >= ?', 1.month.ago).count,
        companies_this_month: Company.where('created_at >= ?', 1.month.ago).count,
        active_memberships: Company.all.select(&:membership_active?).count,
        inactive_memberships: Company.all.reject(&:membership_active?).count
      }
    else
      # Si no es proveedor, solo ve información de su empresa
      @total_users = User.where(company: current_user.company).count
      @total_companies = 1 # Solo su empresa
      @total_customers = Customer.where(company: current_user.company).count
      @total_roles = Role.count # Los roles son globales
      @total_membership_plans = MembershipPlan.count # Los planes son globales
      
      @recent_users = User.includes(:company, :role)
                         .where(company: current_user.company)
                         .where.not(role: nil)
                         .order(created_at: :desc)
                         .limit(5)
      @recent_companies = [current_user.company] # Solo su empresa
      
      # Calcular estadísticas de su empresa
      @system_stats = {
        users_this_month: User.where(company: current_user.company)
                             .where('created_at >= ?', 1.month.ago)
                             .count,
        companies_this_month: 0, # No aplica para empresas no proveedoras
        active_memberships: current_user.company&.membership_active? ? 1 : 0,
        inactive_memberships: current_user.company&.membership_active? ? 0 : 1
      }
    end
  end
  
  private
  
  def ensure_admin!
    unless current_user&.admin? || current_user&.provider?
      redirect_to dashboard_path, alert: 'Acceso denegado. Solo los administradores y usuarios de empresas proveedoras pueden acceder al panel de configuración.'
    end
  end

  def ensure_company_assigned!
    unless current_user&.company.present?
      redirect_to root_path, alert: 'Tu cuenta no tiene una empresa asignada. Contacta al administrador.'
    end
  end
end
