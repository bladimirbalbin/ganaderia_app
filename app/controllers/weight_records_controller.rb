class WeightRecordsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_company
  before_action :set_animal
  before_action :set_weight_record, only: [:show, :edit, :update, :destroy]
  before_action :ensure_company_access

  def index
    @weight_records = @animal.weight_records
      .order(weight_date: :desc)
      .page(params[:page]).per(20)

    # Filtros
    @weight_records = @weight_records.where(method: params[:method]) if params[:method].present?
    @weight_records = @weight_records.where(condition: params[:condition]) if params[:condition].present?
    
    # Búsqueda por notas
    if params[:search].present?
      search_term = "%#{params[:search]}%"
      @weight_records = @weight_records.where("notes ILIKE ?", search_term)
    end

    # Filtro por fecha
    if params[:date_from].present? && params[:date_to].present?
      @weight_records = @weight_records.where(weight_date: params[:date_from]..params[:date_to])
    end
  end

  def show
  end

  def new
    @weight_record = @animal.weight_records.build
  end

  def create
    @weight_record = @animal.weight_records.build(weight_record_params)
    @weight_record.company = @company
    
    if @weight_record.save
      redirect_to animal_weight_records_path(@animal), notice: 'Peso registrado exitosamente.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @weight_record.update(weight_record_params)
      redirect_to animal_weight_records_path(@animal), notice: 'Peso actualizado exitosamente.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @weight_record.destroy
    redirect_to animal_weight_records_path(@animal), notice: 'Peso eliminado exitosamente.'
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

  def set_weight_record
    @weight_record = @animal.weight_records.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to animal_weight_records_path(@animal), alert: 'Registro de peso no encontrado.'
  end

  def ensure_company_access
    unless @company
      redirect_to root_path, alert: 'No tienes acceso a esta sección.'
    end
  end

  def weight_record_params
    params.require(:weight_record).permit(
      :weight_date, :weight, :method, :condition, :notes
    )
  end
end
