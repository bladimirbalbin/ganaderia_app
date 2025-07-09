class UsersController < ApplicationController
  before_action :set_user, only: %i[ show edit update destroy ]
  before_action :check_subscription, only: [:new, :create]
  before_action :authorize_manage_users!
  before_action :ensure_company_assigned!, except: [:index]

  # GET /users or /users.json
  def index
    if current_user.provider?
      @users = User.includes(:customer).all
    else
      @users = User.includes(:customer).where(company: current_user.company)
    end
  end

  # GET /users/1 or /users/1.json
  def show
    @user = User.includes(:customer).find(params[:id])
    # Verificar que el usuario pueda ver este usuario específico
    unless current_user.provider? || @user.company == current_user.company
      redirect_to users_path, alert: "No tienes permisos para ver este usuario."
    end
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
    # Verificar que el usuario pueda editar este usuario específico
    unless current_user.provider? || @user.company == current_user.company
      redirect_to users_path, alert: "No tienes permisos para editar este usuario."
    end
    @customer = @user.customer || @user.build_customer
  end

  def settings
    # lógica de configuración
  end  
  # POST /users or /users.json
  def create
    @user = User.new(user_params)
    # Si no es proveedor, asignar automáticamente su empresa
    unless current_user.provider?
      @user.company = current_user.company
    end
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
    # Verificar que el usuario pueda actualizar este usuario específico
    unless current_user.provider? || @user.company == current_user.company
      redirect_to users_path, alert: "No tienes permisos para actualizar este usuario."
      return
    end
    
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
    # Verificar que el usuario pueda eliminar este usuario específico
    unless current_user.provider? || @user.company == current_user.company
      redirect_to users_path, alert: "No tienes permisos para eliminar este usuario."
      return
    end
    
    @user.destroy!

    respond_to do |format|
      format.html { redirect_to users_path, status: :see_other, notice: "Usuario fue eliminado exitosamente." }
      format.json { head :no_content }
    end
  end
  # GET /users/:id/edit_password
  def edit_password
    @user = User.find(params[:id])
    # Verificar que el usuario pueda cambiar la contraseña de este usuario específico
    unless current_user.provider? || @user.company == current_user.company
      redirect_to users_path, alert: "No tienes permisos para cambiar la contraseña de este usuario."
    end
  end

  # PATCH /users/:id/change_password
  def change_password
    @user = User.find(params[:id])
    # Verificar que el usuario pueda cambiar la contraseña de este usuario específico
    unless current_user.provider? || @user.company == current_user.company
      redirect_to users_path, alert: "No tienes permisos para cambiar la contraseña de este usuario."
      return
    end
    
    if @user.update(password_params)
      redirect_to users_path, notice: "Contraseña actualizada correctamente"
    else
      render :edit_password
    end
  end

  def reset_password
    unless current_user&.admin? || current_user&.provider?
      redirect_to users_path, alert: 'Solo los administradores y usuarios de empresas proveedoras pueden restablecer contraseñas.'
      return
    end
    
    @user = User.find(params[:id])
    # Verificar que el usuario pueda restablecer la contraseña de este usuario específico
    unless current_user.provider? || @user.company == current_user.company
      redirect_to users_path, alert: "No tienes permisos para restablecer la contraseña de este usuario."
      return
    end
    
    if request.post?
      new_password = params[:user][:new_password]
      password_confirmation = params[:user][:password_confirmation]
      
      if new_password == password_confirmation && new_password.present?
        @user.update(password: new_password, password_confirmation: password_confirmation)
        redirect_to users_path, notice: "Contraseña actualizada exitosamente para #{@user.email}"
      else
        flash.now[:alert] = "Las contraseñas no coinciden o están vacías"
        render :reset_password
      end
    end
  end

  def generate_temp_password
    unless current_user&.admin? || current_user&.provider?
      redirect_to users_path, alert: 'Solo los administradores y usuarios de empresas proveedoras pueden generar contraseñas temporales.'
      return
    end
    
    @user = User.find(params[:id])
    # Verificar que el usuario pueda generar contraseña temporal para este usuario específico
    unless current_user.provider? || @user.company == current_user.company
      redirect_to users_path, alert: "No tienes permisos para generar contraseña temporal para este usuario."
      return
    end
    
    temp_password = generate_secure_password
    
    if @user.update(password: temp_password, password_confirmation: temp_password)
      redirect_to reset_password_user_path(@user), 
                  notice: "Contraseña temporal generada: #{temp_password}. Por favor, comunícasela al usuario de forma segura."
    else
      redirect_to users_path, alert: "Error al generar la contraseña temporal"
    end
  end

  private

  def authorize_manage_users!
    unless current_user.can?(:manage_users)
      redirect_to root_path, alert: "No tienes permisos para gestionar usuarios."
    end
  end

  def ensure_company_assigned!
    unless current_user&.company.present?
      redirect_to root_path, alert: "Tu cuenta no tiene una empresa asignada. Contacta al administrador."
    end
  end

  def check_subscription
    unless current_user.company&.can_manage_users?
      redirect_to root_path, alert: "Debes activar tu suscripción para crear usuarios"
    end
  end
  def password_params
    params.require(:user).permit(:password, :password_confirmation)
  end

  def generate_secure_password
    # Genera una contraseña de 12 caracteres con mayúsculas, minúsculas, números y símbolos
    chars = ('A'..'Z').to_a + ('a'..'z').to_a + ('0'..'9').to_a + ['!', '@', '#', '$', '%', '^', '&', '*']
    password = ''
    
    # Asegura al menos un carácter de cada tipo
    password += chars[('A'..'Z').to_a.sample]
    password += chars[('a'..'z').to_a.sample]
    password += chars[('0'..'9').to_a.sample]
    password += chars[['!', '@', '#', '$', '%', '^', '&', '*'].sample]
    
    # Completa con caracteres aleatorios
    (8..12).each do
      password += chars.sample
    end
    
    # Mezcla la contraseña
    password.chars.shuffle.join
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
