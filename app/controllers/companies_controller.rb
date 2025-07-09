class CompaniesController < ApplicationController
  before_action :set_company, only: [:show, :edit, :update, :destroy , :select_plan, :activate_plan]

  def index
    # Verificar si el usuario tiene empresa asignada
    unless current_user.company.present?
      redirect_to root_path, alert: "Tu cuenta no tiene una empresa asignada. Contacta al administrador."
      return
    end

    if current_user.provider?
      # Usuario de la empresa proveedora → puede ver todas las empresas
      @companies = Company.where.not(is_provider: true)
    else
      # Usuario no proveedor → solo puede ver su propia empresa
      @companies = Company.where(id: current_user.company&.id)
    end
  end

  def show
    # Verificar que el usuario pueda ver esta empresa específica
    unless current_user.provider? || @company == current_user.company
      redirect_to companies_path, alert: "No tienes permisos para ver esta empresa."
    end
  end

  def new
    # Solo los proveedores pueden crear nuevas empresas
    unless current_user.provider?
      redirect_to companies_path, alert: "Solo los administradores del sistema pueden crear nuevas empresas."
    end
    @company = Company.new
  end

  def edit
    # Verificar que el usuario pueda editar esta empresa específica
    unless current_user.provider? || @company == current_user.company
      redirect_to companies_path, alert: "No tienes permisos para editar esta empresa."
    end
  end

  def create
    # Solo los proveedores pueden crear nuevas empresas
    unless current_user.provider?
      redirect_to companies_path, alert: "Solo los administradores del sistema pueden crear nuevas empresas."
    end
    
    @company = Company.new(company_params)

    if @company.save
      redirect_to select_plan_company_path(@company), notice: "Compañía creada exitosamente. Por favor, selecciona un plan de membresía."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    # Verificar que el usuario pueda actualizar esta empresa específica
    unless current_user.provider? || @company == current_user.company
      redirect_to companies_path, alert: "No tienes permisos para actualizar esta empresa."
      return
    end
    
    if @company.update(company_params)
      # Lógica de redirección según el tipo de usuario y estado de la empresa
      if current_user.provider?
        # Proveedores van a la página de la empresa
        redirect_to @company, notice: "Compañía actualizada exitosamente."
      else
        # Usuarios de empresas cliente
        if @company.customer.present? && customer_incomplete?(@company.customer)
          # Si los datos de facturación están incompletos, redirigir a completarlos
          redirect_to edit_customer_path(@company.customer), notice: "Datos de facturación actualizados. Completa la información restante."
        elsif !@company.membership_active? && !@company.is_provider?
          # Si la membresía no está activa, redirigir a seleccionar plan
          redirect_to select_plan_company_path(@company), notice: "Datos de facturación completados. Ahora selecciona un plan de membresía."
        else
          # Todo está bien, redirigir a la página de la empresa
          redirect_to @company, notice: "Datos de facturación actualizados exitosamente."
        end
      end
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    # Solo los proveedores pueden eliminar empresas
    unless current_user.provider?
      redirect_to companies_path, alert: "Solo los administradores del sistema pueden eliminar empresas."
      return
    end
    
    @company.destroy
    redirect_to companies_path, notice: "Compañía eliminada exitosamente."
  end

  # GET /companies/:id/select_plan
  def select_plan
    # Verificar que el usuario pueda seleccionar plan para esta empresa específica
    unless current_user.provider? || @company == current_user.company
      redirect_to companies_path, alert: "No tienes permisos para seleccionar plan para esta empresa."
    end
    @plans = MembershipPlan.all
  end

  # POST /companies/:id/activate_plan
  def activate_plan
    # Verificar que el usuario pueda activar plan para esta empresa específica
    unless current_user.provider? || @company == current_user.company
      redirect_to companies_path, alert: "No tienes permisos para activar plan para esta empresa."
      return
    end
    
    plan = MembershipPlan.find(params[:plan_id])

    if @company.activate_membership!(plan)
      redirect_to @company, notice: "¡Membresía activada correctamente!"
    else
      redirect_to select_plan_company_path(@company), alert: "No se pudo activar la membresía."
    end
  end

  private

  def set_company
    @company = Company.find(params[:id])
  end

  def company_params
    params.require(:company).permit(
      :name, :contact_email, :membership_plan_id, :users_limit,
      :active_until, :active, :is_provider
    )
  end
end
