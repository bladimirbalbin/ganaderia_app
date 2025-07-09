class MedicalRecordsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_company
  before_action :set_animal
  before_action :set_medical_record, only: [:show, :edit, :update, :destroy]
  before_action :ensure_company_access
  before_action :ensure_medical_access, except: [:index, :show]

  def index
    @medical_records = @animal.medical_records
      .order(date: :desc)
      .page(params[:page]).per(20)

    # Filtros
    @medical_records = @medical_records.where(veterinarian: params[:veterinarian]) if params[:veterinarian].present?
    
    # Búsqueda por diagnóstico
    if params[:search].present?
      search_term = "%#{params[:search]}%"
      @medical_records = @medical_records.where("diagnosis ILIKE ? OR notes ILIKE ?", search_term, search_term)
    end

    # Filtro por fecha
    if params[:date_from].present? && params[:date_to].present?
      @medical_records = @medical_records.where(date: params[:date_from]..params[:date_to])
    end
  end

  def show
  end

  def new
    @medical_record = @animal.medical_records.build
  end

  def create
    @medical_record = @animal.medical_records.build(medical_record_params)
    
    if @medical_record.save
      redirect_to animal_medical_records_path(@animal), notice: 'Registro médico creado exitosamente.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @medical_record.update(medical_record_params)
      redirect_to animal_medical_records_path(@animal), notice: 'Registro médico actualizado exitosamente.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @medical_record.destroy
    redirect_to animal_medical_records_path(@animal), notice: 'Registro médico eliminado exitosamente.'
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

  def set_medical_record
    @medical_record = @animal.medical_records.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to animal_medical_records_path(@animal), alert: 'Registro médico no encontrado.'
  end

  def ensure_company_access
    unless @company
      redirect_to root_path, alert: 'No tienes acceso a esta sección.'
    end
  end

  def ensure_medical_access
    # Solo veterinarios y administradores pueden modificar la historia clínica
    unless current_user.admin? || current_user.veterinario?
      redirect_to animal_medical_records_path(@animal), 
                  alert: 'Solo veterinarios y administradores pueden modificar la historia clínica.'
    end
  end

  def medical_record_params
    params.require(:medical_record).permit(
      :date, :diagnosis, :treatment, :veterinarian, :notes
    )
  end
end
