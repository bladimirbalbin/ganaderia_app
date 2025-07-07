class CompaniesController < ApplicationController
  before_action :set_company, only: [:show, :edit, :update, :destroy , :select_plan, :activate_plan]

  def index
    if current_user.company.is_provider?
      # Usuario de la empresa proveedora → puede ver todas las empresas
      @companies = Company.where.not(is_provider: true)
      @companies = Company.all
    elsif current_user.admin?
      # Usuario administrador → solo puede ver su propia empresa
      @companies = Company.where(id: current_user.company.id)
    else
      # Usuario normal o veterinario → no puede ver empresas
      redirect_to root_path, alert: "No tienes permiso para ver esta información."
    end
  end


  def show
  end

  def new
    @company = Company.new
  end

  def edit
  end

  def create
    @company = Company.new(company_params)

    if @company.save
      redirect_to select_plan_company_path(@company), notice: "Compañía creada exitosamente. Por favor, selecciona un plan de membresía."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @company.update(company_params)
      redirect_to @company, notice: "Compañía actualizada exitosamente."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @company.destroy
    redirect_to companies_path, notice: "Compañía eliminada exitosamente."
  end

    # GET /companies/:id/select_plan
  def select_plan
    @company = Company.find(params[:id])  # <= esta línea es necesaria
    @plans = MembershipPlan.all
  end

  # POST /companies/:id/activate_plan
  def activate_plan
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
