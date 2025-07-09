class ApplicationController < ActionController::Base
  before_action :check_membership_status
  helper_method :customer_incomplete?, :admin_user?, :user_has_company?, :company_needs_membership?, :company_needs_billing_data?
  before_action :authenticate_user!
  # Evitar que Devise llame este before_action donde no hay current_user
  skip_before_action :check_membership_status, if: :devise_controller?
  def after_sign_in_path_for(resource)
      dashboard_path
  end

  def customer_incomplete?(customer)
      required_fields = %w[
      first_name last_name document_type document_number address1 mobile_phone1
      ]
      required_fields.any? { |attr| customer.send(attr).blank? }
  end

  def company_needs_membership?
    return false unless current_user&.company.present?
    return false if current_user.company.is_provider?
    !current_user.company.membership_active?
  end

  def company_needs_billing_data?
    return false unless current_user&.company&.customer.present?
    customer_incomplete?(current_user.company.customer)
  end

  def admin_user?
    current_user&.admin? || current_user&.provider?
  end

  def user_has_company?
    current_user&.company.present?
  end
  
  private

  def check_membership_status
      return unless user_signed_in?
      company = current_user.company
      return if company.nil?
      
      # Solo verificar membresía si no es proveedor y la empresa no está activa
      unless company.is_provider? || company.membership_active?
          # Solo redirigir si la empresa tiene un plan asignado pero la membresía venció
          if company.membership_plan.present?
              flash[:alert] = "Tu membresía ha vencido, selecciona un nuevo plan."
              redirect_to select_plan_company_path(company)
          end
          # Si no tiene plan asignado, no redirigir automáticamente
      end
  end
end
