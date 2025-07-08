class Users::RegistrationsController < Devise::RegistrationsController
  def create
    build_resource(sign_up_params)

    resource.role = Role.find_by(name: "Admin")

    resource.build_company(name: "Mi empresa", subscription_status: "free") do |company|
      company.build_customer(skip_document_validation: true)
    end

    if resource.save
      sign_up(resource_name, resource)
      redirect_to root_path, notice: "Cuenta creada correctamente. Completa tus datos de facturación para activar tu suscripción."
    else
      clean_up_passwords resource
      set_minimum_password_length
      render :new
    end
  end

  private

  def sign_up_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end
