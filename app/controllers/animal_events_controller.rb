class AnimalEventsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_company
  before_action :set_animal
  before_action :set_animal_event, only: [:show, :edit, :update, :destroy]
  before_action :ensure_company_access

  def index
    @animal_events = @animal.animal_events
      .order(event_date: :desc)
      .page(params[:page]).per(20)

    # Filtros
    @animal_events = @animal_events.where(event_type: params[:event_type]) if params[:event_type].present?
    
    # Búsqueda por descripción o notas
    if params[:search].present?
      search_term = "%#{params[:search]}%"
      @animal_events = @animal_events.where("description ILIKE ? OR notes ILIKE ?", search_term, search_term)
    end

    # Filtro por fecha
    if params[:date_from].present? && params[:date_to].present?
      @animal_events = @animal_events.where(event_date: params[:date_from]..params[:date_to])
    end
  end

  def show
  end

  def new
    @animal_event = @animal.animal_events.build
  end

  def create
    @animal_event = @animal.animal_events.build(animal_event_params)
    @animal_event.company = @company
    @animal_event.user = current_user
    
    if @animal_event.save
      redirect_to animal_animal_events_path(@animal), notice: 'Evento registrado exitosamente.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @animal_event.update(animal_event_params)
      redirect_to animal_animal_events_path(@animal), notice: 'Evento actualizado exitosamente.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @animal_event.destroy
    redirect_to animal_animal_events_path(@animal), notice: 'Evento eliminado exitosamente.'
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

  def set_animal_event
    @animal_event = @animal.animal_events.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to animal_animal_events_path(@animal), alert: 'Evento no encontrado.'
  end

  def ensure_company_access
    unless @company
      redirect_to root_path, alert: 'No tienes acceso a esta sección.'
    end
  end

  def animal_event_params
    params.require(:animal_event).permit(
      :event_date, :event_type, :description, :notes
    )
  end
end
