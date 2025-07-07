class CustomersController < ApplicationController
  before_action :set_customer, only: %i[show edit update destroy]

  def index
    @q = Customer.ransack(params[:q])
    @customers = @q.result.order(created_at: :desc).page(params[:page]).per(20)

    respond_to do |format|
      format.html
      format.csv { send_data @customers.to_csv, filename: "clientes-#{Date.today}.csv" }
    end
  end


  def show
  end

  def new
    @customer = Customer.new
  end

  def edit
  end

  def create
    @customer = Customer.new(customer_params)
    if @customer.save
      redirect_to @customer, notice: "Cliente creado correctamente."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @customer.update(customer_params)
      redirect_to @customer, notice: "Cliente actualizado correctamente."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @customer.destroy
    redirect_to customers_path, notice: "Cliente eliminado correctamente."
  end

  private

  def set_customer
    @customer = Customer.find(params[:id])
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
