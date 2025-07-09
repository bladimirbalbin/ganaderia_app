class BirthsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_company
  before_action :set_animal
  before_action :set_birth, only: [:show, :edit, :update, :destroy]
  before_action :ensure_company_access

  def index
    @births = @animal.births
      .order(birth_date: :desc)
      .page(params[:page]).per(20)

    # Filtros
    @births = @births.where(calf_gender: params[:calf_gender]) if params[:calf_gender].present?
    @births = @births.where(complications: params[:complications]) if params[:complications].present?
    
    # Búsqueda por ternero o notas
    if params[:search].present?
      search_term = "%#{params[:search]}%"
      @births = @births.where("calf_name ILIKE ? OR notes ILIKE ?", search_term, search_term)
    end

    # Filtro por fecha
    if params[:date_from].present? && params[:date_to].present?
      @births = @births.where(birth_date: params[:date_from]..params[:date_to])
    end
  end

  def show
  end

  def new
    @birth = @animal.births.build
  end

  def create
    @birth = @animal.births.build(birth_params)
    @birth.company = @company
    
    if @birth.save
      redirect_to animal_births_path(@animal), notice: 'Parto registrado exitosamente.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @birth.update(birth_params)
      redirect_to animal_births_path(@animal), notice: 'Parto actualizado exitosamente.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @birth.destroy
    redirect_to animal_births_path(@animal), notice: 'Parto eliminado exitosamente.'
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

  def set_birth
    @birth = @animal.births.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to animal_births_path(@animal), alert: 'Parto no encontrado.'
  end

  def ensure_company_access
    unless @company
      redirect_to root_path, alert: 'No tienes acceso a esta sección.'
    end
  end

  def birth_params
    params.require(:birth).permit(
      :birth_date, :calf_name, :calf_gender, :calf_weight, :complications, :notes
    )
  end
end
