class DashboardController < ApplicationController
  before_action :authenticate_user!

  def index
    @user = current_user
    Rails.logger.info "=== current_user: #{@user.inspect}"

    if @user.nil?
      redirect_to new_user_session_path, alert: "Debes iniciar sesión para continuar"
      return
    end

    if @user.provider?
      # Usuario de empresa proveedora - acceso completo al sistema
      @companies = Company.all
      @users = User.all
      @membership_plans = MembershipPlan.all

    elsif @user.admin?
      # Administrador de empresa cliente
      @company = @user.company
      if @company.present?
        @users = @company.users
      else
        flash[:alert] = "Debes completar el registro de la empresa antes de continuar."
        redirect_to new_company_registration_path and return
      end

    elsif @user.veterinario?
      # Veterinario
      @animals = Animal.where(veterinario_id: @user.id)

    else
      # Usuario normal
      @company = @user.company
      if @company.present?
        @users = @company.users
      else
        flash[:alert] = "Tu cuenta no tiene una empresa asignada. Contacta al administrador."
        redirect_to root_path and return
      end
    end
  end
end
