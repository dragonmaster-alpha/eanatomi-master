class Admin::TimelineEventsController < AdminController
  before_action :set_event, only: [:edit, :update, :destroy]

  def index
    @events = TimelineEvent.all
  end

  def new
    @slider_types = TimelineEvent::SLIDER_TYPES
    @event = TimelineEvent.new
  end

  def edit
    @slider_types = TimelineEvent::SLIDER_TYPES
  end

  def create
    @event = TimelineEvent.create! event_params
    redirect_to Page.timeline_page, notice: "#{@event} blev oprettet"
  end

  def update
    @event.update! event_params
    redirect_to Page.timeline_page, notice: "#{@event} blev opdateret"
  end                               

  def destroy
    @event.destroy
    redirect_to '/', notice: "#{@event} blev slettet"
  end
  def event_params
    params[:timeline_event].permit!
  end
  private

    def authorize
      authorize! :update, TimelineEvent
    end



    def set_event
      @event = TimelineEvent.find(params[:id])
    end
end
