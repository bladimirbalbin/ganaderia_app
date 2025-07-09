class CustomersController < ApplicationController
  before_action :set_customer, only: %i[show edit update destroy]
  before_action :ensure_company_assigned!

  def index
    if current_user.provider?
      @q = Customer.ransack(params[:q])
      @customers = @q.result.order(created_at: :desc).page(params[:page]).per(20)
    else
      @q = Customer.where(company: current_user.company).ransack(params[:q])
      @customers = @q.result.order(created_at: :desc).page(params[:page]).per(20)
    end

    respond_to do |format|
      format.html
      format.csv { send_data @customers.to_csv, filename: "clientes-#{Date.today}.csv" }
    end
  end

  def show
    # Verificar que el usuario pueda ver este cliente específico
    unless current_user.provider? || @customer.company == current_user.company
      redirect_to customers_path, alert: "No tienes permisos para ver este cliente."
    end
  end

  def new
    @customer = Customer.new
  end

  def edit
    # Verificar que el usuario pueda editar este cliente específico
    unless current_user.provider? || @customer.company == current_user.company
      redirect_to customers_path, alert: "No tienes permisos para editar este cliente."
    end
  end

  def create
    @customer = Customer.new(customer_params)
    # Si no es proveedor, asignar automáticamente su empresa
    unless current_user.provider?
      @customer.company = current_user.company
    end
    
    if @customer.save
      redirect_to @customer, notice: "Cliente creado correctamente."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    # Verificar que el usuario pueda actualizar este cliente específico
    unless current_user.provider? || @customer.company == current_user.company
      redirect_to customers_path, alert: "No tienes permisos para actualizar este cliente."
      return
    end
    
    if @customer.update(customer_params)
      # Lógica de redirección según el estado de la empresa
      if current_user.provider?
        # Proveedores van al dashboard
        redirect_to dashboard_path, notice: "Datos de facturación actualizados correctamente."
      else
        # Usuarios de empresas cliente
        if customer_incomplete?(@customer)
          # Si aún faltan datos, redirigir de vuelta al formulario
          redirect_to edit_customer_path(@customer), notice: "Datos actualizados. Completa la información restante."
        elsif !@customer.company.membership_active? && !@customer.company.is_provider?
          # Si los datos están completos pero no hay membresía activa, redirigir a seleccionar plan
          redirect_to select_plan_company_path(@customer.company), notice: "¡Datos de facturación completados! Ahora selecciona un plan de membresía para activar tu cuenta."
        else
          # Todo está bien, redirigir al dashboard
          redirect_to dashboard_path, notice: "Datos de facturación actualizados correctamente."
        end
      end
    else
      flash.now[:alert] = "Hubo un problema al guardar los datos."
      render :edit
    end
  end

  def destroy
    # Verificar que el usuario pueda eliminar este cliente específico
    unless current_user.provider? || @customer.company == current_user.company
      redirect_to customers_path, alert: "No tienes permisos para eliminar este cliente."
      return
    end
    
    @customer.destroy
    redirect_to customers_path, notice: "Cliente eliminado correctamente."
  end

  private

  def set_customer
    @customer = Customer.find(params[:id])
  end

  def ensure_company_assigned!
    unless current_user&.company.present?
      redirect_to root_path, alert: "Tu cuenta no tiene una empresa asignada. Contacta al administrador."
    end
  end

  def customer_params
    params.require(:customer).permit(
      :user_id, :company_id, :customer_type,
      :first_name, :middle_name, :last_name, :second_last_name,
      :document_type, :document_number,
      :address1, :address2, :mobile_phone1, :mobile_phone2,
      :landline_phone, :email,
      :company_id, :user_id
    )
  end
end

