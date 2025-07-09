class CompanyRegistrationsController < ApplicationController
  skip_before_action :authenticate_user!
  layout 'application'

  def new
    @company = Company.new
    @company.build_customer
    @company.customer.customer_type = :company # Valor por defecto para tipo cliente
    @company.users.build if @company.users.empty? # inicializamos el primer usuario admin
  end

  def create
    @company = Company.new(company_params)
    # Le ponemos status inicial
    @company.subscription_status = "free"
    @company.active = true
    
    # Asignar plan por defecto si existe, si no, dejar sin plan
    default_plan = MembershipPlan.where(active: true).first
    if default_plan
      @company.membership_plan = default_plan
      @company.users_limit = default_plan.users_limit
      @company.active_until = default_plan.duration_in_days.days.from_now
    else
      @company.users_limit = 1
      @company.active_until = 1.month.from_now
    end

    # Le asignamos el rol de Admin al primer user
    if @company.users.any?
      admin_role = Role.find_by(name: "Admin")
      @company.users.first.role = admin_role
    end

    if @company.save
      redirect_to new_user_session_path, notice: "Empresa registrada correctamente. Ahora inicia sesión con el usuario administrador."
    else
      flash.now[:alert] = "Hubo errores al registrar la empresa."
      puts @company.errors.full_messages
      @company.users.each { |u| puts u.errors.full_messages }
      render :new
    end
  end

  private

  def company_params
    params.require(:company).permit(
      :name, :contact_email,
      customer_attributes: [
        :customer_type, :document_type, :document_number,
        :address1, :address2, :mobile_phone1, :mobile_phone2, :landline_phone
      ],
      users_attributes: [:email, :password, :password_confirmation]
    )
  end
end
