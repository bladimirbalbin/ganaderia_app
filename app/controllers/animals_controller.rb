class AnimalsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_company
  before_action :set_animal, only: [:show, :edit, :update, :destroy]
  before_action :ensure_company_access

  def index
    @animals = @company.animals
      .includes(:inseminations, :palpations, :births, :milk_productions, :weight_records)
      .order(:name)
      .page(params[:page]).per(20)

    # Filtros
    @animals = @animals.where(gender: params[:gender]) if params[:gender].present?
    @animals = @animals.where(status: params[:status]) if params[:status].present?
    @animals = @animals.where(breed: params[:breed]) if params[:breed].present?
    
    # Búsqueda por nombre o arete
    if params[:search].present?
      search_term = "%#{params[:search]}%"
      @animals = @animals.where("name ILIKE ? OR ear_tag ILIKE ?", search_term, search_term)
    end

    # Estadísticas
    @total_animals = @company.animals.count
    @active_animals = @company.animals.active.count
    @female_animals = @company.animals.females.count
    @male_animals = @company.animals.males.count
    @pregnant_animals = @company.animals.females.joins(:palpations)
      .where(palpations: { result: 'pregnant' }).distinct.count
  end

  def show
    @recent_inseminations = @animal.inseminations.recent.limit(5)
    @recent_palpations = @animal.palpations.recent.limit(5)
    @recent_births = @animal.births.recent.limit(5)
    @recent_milk_productions = @animal.milk_productions.recent.limit(10)
    @recent_weight_records = @animal.weight_records.recent.limit(10)
    @recent_events = @animal.animal_events.recent.limit(10)
  end

  def new
    @animal = @company.animals.build
  end

  def create
    @animal = @company.animals.build(animal_params)
    
    if @animal.save
      redirect_to @animal, notice: 'Animal registrado exitosamente.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @animal.update(animal_params)
      redirect_to @animal, notice: 'Animal actualizado exitosamente.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @animal.destroy
    redirect_to animals_path, notice: 'Animal eliminado exitosamente.'
  end

  private

  def set_company
    @company = current_user.company
    redirect_to root_path, alert: 'No tienes una empresa asignada.' unless @company
  end

  def set_animal
    @animal = @company.animals.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to animals_path, alert: 'Animal no encontrado.'
  end

  def ensure_company_access
    unless @company
      redirect_to root_path, alert: 'No tienes acceso a esta sección.'
    end
  end

  def animal_params
    params.require(:animal).permit(
      :name, :breed, :birth_date, :weight, :gender, 
      :ear_tag, :status, :animal_type, :observations
    )
  end
end
