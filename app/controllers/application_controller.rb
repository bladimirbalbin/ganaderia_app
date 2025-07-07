class ApplicationController < ActionController::Base
    before_action :check_membership_status
    def after_sign_in_path_for(resource)
        dashboard_path
    end
    
    private

    def check_membership_status
        return unless user_signed_in?
        company = current_user.company
        unless company.is_provider? || company.membership_active?
            flash[:alert] = "Tu membresía ha vencido, selecciona un nuevo plan."
            redirect_to select_plan_company_path(company)
        end
    end
end
