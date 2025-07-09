class PalpationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_company
  before_action :set_animal
  before_action :set_palpation, only: [:show, :edit, :update, :destroy]
  before_action :ensure_company_access

  def index
    @palpations = @animal.palpations
      .order(palpation_date: :desc)
      .page(params[:page]).per(20)

    # Filtros
    @palpations = @palpations.where(result: params[:result]) if params[:result].present?
    @palpations = @palpations.where(veterinarian: params[:veterinarian]) if params[:veterinarian].present?
    
    # Búsqueda por notas
    if params[:search].present?
      search_term = "%#{params[:search]}%"
      @palpations = @palpations.where("notes ILIKE ?", search_term)
    end

    # Filtro por fecha
    if params[:date_from].present? && params[:date_to].present?
      @palpations = @palpations.where(palpation_date: params[:date_from]..params[:date_to])
    end
  end

  def show
  end

  def new
    @palpation = @animal.palpations.build
  end

  def create
    @palpation = @animal.palpations.build(palpation_params)
    @palpation.company = @company
    
    if @palpation.save
      redirect_to animal_palpations_path(@animal), notice: 'Palpación registrada exitosamente.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @palpation.update(palpation_params)
      redirect_to animal_palpations_path(@animal), notice: 'Palpación actualizada exitosamente.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @palpation.destroy
    redirect_to animal_palpations_path(@animal), notice: 'Palpación eliminada exitosamente.'
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

  def set_palpation
    @palpation = @animal.palpations.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to animal_palpations_path(@animal), alert: 'Palpación no encontrada.'
  end

  def ensure_company_access
    unless @company
      redirect_to root_path, alert: 'No tienes acceso a esta sección.'
    end
  end

  def palpation_params
    params.require(:palpation).permit(
      :palpation_date, :result, :veterinarian, :notes
    )
  end
end
