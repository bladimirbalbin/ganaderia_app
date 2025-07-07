class CompanyRegistrationsController < ApplicationController
  def new
    @company = Company.new
    @company.build_customer
    @user = User.new
  end

  def create
    @company = Company.new(company_params)
    @user = User.new(user_params)
    @user.role = Role.find_by(name: 'Provider') # o 'Admin'
    if @company.save
      @user.company = @company
      if @user.save
        sign_in(@user) # Devise: loguea el usuario
        redirect_to dashboard_path, notice: "Empresa registrada correctamente"
      else
        @company.destroy # rollback empresa si falla usuario
        render :new, alert: "Error al crear el usuario"
      end
    else
      render :new, alert: "Error al registrar la empresa"
    end
  end

  private

  def company_params
    params.require(:company).permit(:name,
      customer_attributes: [:customer_type, :document_type, :document_number, 
                            :address1, :address2, :mobile_phone1, :mobile_phone2, 
                            :landline_phone, :email])
  end

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end
