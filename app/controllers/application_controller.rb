class ApplicationController < ActionController::Base
  before_action :check_membership_status
  helper_method :customer_incomplete?
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
  
  private

  def check_membership_status
      return unless user_signed_in?
      company = current_user.company
      return if company.nil?
      unless company.is_provider? || company.membership_active?
          flash[:alert] = "Tu membresía ha vencido, selecciona un nuevo plan."
          redirect_to select_plan_company_path(company)
      end
  end
end
