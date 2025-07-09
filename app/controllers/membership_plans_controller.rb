class MembershipPlansController < ApplicationController
  before_action :check_user_permissions
  
  def index
    # Solo mostrar planes si el usuario tiene empresa y permisos
    if current_user.company.present?
      @plans = MembershipPlan.where(active: true)
    else
      redirect_to root_path, alert: "Tu cuenta no tiene una empresa asignada. Contacta al administrador."
    end
  end

  def show
    @plan = MembershipPlan.find(params[:id])
  end

  def new
    unless current_user&.provider?
      redirect_to membership_plans_path, alert: "Solo los administradores del sistema pueden crear planes de membresía."
      return
    end
    @plan = MembershipPlan.new
  end

  def edit
    unless current_user&.provider?
      redirect_to membership_plans_path, alert: "Solo los administradores del sistema pueden editar planes de membresía."
      return
    end
    @plan = MembershipPlan.find(params[:id])
  end

  def create
    unless current_user&.provider?
      redirect_to membership_plans_path, alert: "Solo los administradores del sistema pueden crear planes de membresía."
      return
    end
    
    @plan = MembershipPlan.new(membership_plan_params)
    if @plan.save
      redirect_to @plan, notice: "Plan de membresía creado exitosamente."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    unless current_user&.provider?
      redirect_to membership_plans_path, alert: "Solo los administradores del sistema pueden editar planes de membresía."
      return
    end
    
    @plan = MembershipPlan.find(params[:id])
    if @plan.update(membership_plan_params)
      redirect_to @plan, notice: "Plan de membresía actualizado exitosamente."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    unless current_user&.provider?
      redirect_to membership_plans_path, alert: "Solo los administradores del sistema pueden eliminar planes de membresía."
      return
    end
    
    @plan = MembershipPlan.find(params[:id])
    @plan.destroy
    redirect_to membership_plans_path, notice: "Plan de membresía eliminado exitosamente."
  end

  private

  def check_user_permissions
    # Verificar que el usuario esté autenticado
    unless user_signed_in?
      redirect_to new_user_session_path, alert: "Debes iniciar sesión para acceder a esta sección."
      return
    end

    # Verificar que el usuario tenga empresa asignada (excepto para proveedores)
    unless current_user.provider? || current_user.company.present?
      redirect_to root_path, alert: "Tu cuenta no tiene una empresa asignada. Contacta al administrador."
      return
    end
  end

  def membership_plan_params
    params.require(:membership_plan).permit(:name, :description, :price, :users_limit, :duration_in_days, :active)
  end
end
