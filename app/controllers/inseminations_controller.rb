class InseminationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_company
  before_action :set_animal
  before_action :set_insemination, only: [:show, :edit, :update, :destroy]
  before_action :ensure_company_access

  def index
    @inseminations = @animal.inseminations
      .order(insemination_date: :desc)
      .page(params[:page]).per(20)

    # Filtros
    @inseminations = @inseminations.where(method: params[:method]) if params[:method].present?
    @inseminations = @inseminations.where(technician: params[:technician]) if params[:technician].present?
    
    # Búsqueda por toro o notas
    if params[:search].present?
      search_term = "%#{params[:search]}%"
      @inseminations = @inseminations.where("bull_name ILIKE ? OR notes ILIKE ?", search_term, search_term)
    end

    # Filtro por fecha
    if params[:date_from].present? && params[:date_to].present?
      @inseminations = @inseminations.where(insemination_date: params[:date_from]..params[:date_to])
    end
  end

  def show
  end

  def new
    @insemination = @animal.inseminations.build
  end

  def create
    @insemination = @animal.inseminations.build(insemination_params)
    @insemination.company = @company
    
    if @insemination.save
      redirect_to animal_inseminations_path(@animal), notice: 'Inseminación registrada exitosamente.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @insemination.update(insemination_params)
      redirect_to animal_inseminations_path(@animal), notice: 'Inseminación actualizada exitosamente.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @insemination.destroy
    redirect_to animal_inseminations_path(@animal), notice: 'Inseminación eliminada exitosamente.'
  end

  private

  def set_company
    @company = current_user.company
    redirect_to root_path, alert: 'No tienes una empresa asignada.' unless @company
  end

  def set_animal
    @animal = @company.animals.find(params[:animal_id])
  rescue ActiveRecord::RecordNotFound
    redirect_to animals_path, alert: 'Animal no encontrado.'
  end

  def set_insemination
    @insemination = @animal.inseminations.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to animal_inseminations_path(@animal), alert: 'Inseminación no encontrada.'
  end

  def ensure_company_access
    unless @company
      redirect_to root_path, alert: 'No tienes acceso a esta sección.'
    end
  end

  def insemination_params
    params.require(:insemination).permit(
      :insemination_date, :bull_name, :technician, :method, :notes
    )
  end
end
