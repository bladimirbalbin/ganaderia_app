class UsersController < ApplicationController
  before_action :set_user, only: %i[ show edit update destroy ]
  before_action :check_subscription, only: [:new, :create]

  # GET /users or /users.json
  def index
    @users = User.includes(:customer).all
  end

  # GET /users/1 or /users/1.json
  def show
    @user = User.includes(:customer).find(params[:id])
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
    @customer = @user.customer || @user.build_customer
  end

  def settings
    # lógica de configuración
  end  
  # POST /users or /users.json
  def create
    @user = User.new(user_params)
    company = @user.company

    respond_to do |format|
      if company && !company.can_create_more_users?
        @user.errors.add(:base, "La empresa ha alcanzado el límite de usuarios permitidos por su membresía.")
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      elsif @user.save
        format.html { redirect_to @user, notice: "Usuario fue creado exitosamente." }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end


  # PATCH/PUT /users/1 or /users/1.json

  def update
    @user = User.find(params[:id])
    
    if @user.update(user_params)
      redirect_to users_path, notice: "Usuario actualizado correctamente"
    else
      @customer = @user.customer || @user.build_customer
      flash.now[:alert] = "Error al actualizar el usuario"
      render :edit
    end
  end

  # DELETE /users/1 or /users/1.json
  def destroy
    @user.destroy!

    respond_to do |format|
      format.html { redirect_to users_path, status: :see_other, notice: "Usuario fue eliminado exitosamente." }
      format.json { head :no_content }
    end
  end
  # GET /users/:id/edit_password
  def edit_password
    @user = User.find(params[:id])
  end

  # PATCH /users/:id/change_password
  def change_password
    @user = User.find(params[:id])
    if @user.update(password_params)
      redirect_to users_path, notice: "Contraseña actualizada correctamente"
    else
      render :edit_password
    end
  end

  private

  def check_subscription
    unless current_user.company.can_manage_users?
      redirect_to root_path, alert: "Debes activar tu suscripción para crear usuarios"
    end
  end
  def password_params
    params.require(:user).permit(:password, :password_confirmation)
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def user_params
    params.require(:user).permit(
      :email,
      :role_id,
      :company_id,
      :password,
      :password_confirmation,
      customer_attributes: [
        :first_name, :middle_name, :last_name, :second_last_name,
        :document_type, :document_number,
        :address1, :address2, :mobile_phone1, :mobile_phone2, :landline_phone, :company_id
      ]
    )
  end  
end
