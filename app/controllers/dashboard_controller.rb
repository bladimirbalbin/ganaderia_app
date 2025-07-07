class DashboardController < ApplicationController
  before_action :authenticate_user!  # <== esto es clave

  def index
    @user = current_user
    Rails.logger.info "=== current_user: #{@user.inspect}"

    if @user.nil?
      redirect_to new_user_session_path, alert: "Debes iniciar sesión para continuar"
      return
    end

    if @user.company&.is_provider?
      @companies = Company.all
      @users = User.all
      @membership_plans = MembershipPlan.all
    elsif @user.admin?
      @company = @user.company
      @users = @company.users
    elsif @user.veterinario?
      @animals = Animal.where(veterinario_id: @user.id)
    else
      redirect_to root_path, alert: "No tienes permisos para ver este panel"
    end
  end

end