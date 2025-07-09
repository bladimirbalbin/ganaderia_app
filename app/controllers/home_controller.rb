class HomeController < ApplicationController
  def index
    if user_signed_in?
      if current_user.provider?
        redirect_to companies_path
      elsif current_user.admin?
        # redirigir a dashboard de la empresa
        if current_user.company.present?
          redirect_to company_path(current_user.company)
        else
          redirect_to dashboard_path
        end
      elsif current_user.veterinario?
        # ejemplo: redirigir a sección de animales
        redirect_to animals_path
      else
        # otros usuarios normales
        redirect_to dashboard_path
      end
    end
    # si NO está logueado: se muestra la página index.html.erb con login / registro
  end
end
