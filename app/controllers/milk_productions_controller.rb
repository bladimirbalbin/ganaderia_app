class MilkProductionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_company
  before_action :set_animal
  before_action :set_milk_production, only: [:show, :edit, :update, :destroy]
  before_action :ensure_company_access

  def index
    @milk_productions = @animal.milk_productions
      .order(production_date: :desc)
      .page(params[:page]).per(20)

    # Filtros
    @milk_productions = @milk_productions.where(period: params[:period]) if params[:period].present?
    @milk_productions = @milk_productions.where(quality: params[:quality]) if params[:quality].present?
    
    # Búsqueda por notas
    if params[:search].present?
      search_term = "%#{params[:search]}%"
      @milk_productions = @milk_productions.where("notes ILIKE ?", search_term)
    end

    # Filtro por fecha
    if params[:date_from].present? && params[:date_to].present?
      @milk_productions = @milk_productions.where(production_date: params[:date_from]..params[:date_to])
    end
  end

  def show
  end

  def new
    @milk_production = @animal.milk_productions.build
  end

  def create
    @milk_production = @animal.milk_productions.build(milk_production_params)
    @milk_production.company = @company
    
    if @milk_production.save
      redirect_to animal_milk_productions_path(@animal), notice: 'Producción láctea registrada exitosamente.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @milk_production.update(milk_production_params)
      redirect_to animal_milk_productions_path(@animal), notice: 'Producción láctea actualizada exitosamente.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @milk_production.destroy
    redirect_to animal_milk_productions_path(@animal), notice: 'Producción láctea eliminada exitosamente.'
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

  def set_milk_production
    @milk_production = @animal.milk_productions.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to animal_milk_productions_path(@animal), alert: 'Producción láctea no encontrada.'
  end

  def ensure_company_access
    unless @company
      redirect_to root_path, alert: 'No tienes acceso a esta sección.'
    end
  end

  def milk_production_params
    params.require(:milk_production).permit(
      :production_date, :quantity, :period, :quality, :notes
    )
  end
end
