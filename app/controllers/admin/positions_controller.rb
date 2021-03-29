class Admin::PositionsController < AdminController

  def update
    klass = params[:model].constantize
    authorize! :update, klass

    params[:items].each_with_index do |id, position|
      klass.find(id).update! position: position
    end

    head :ok
  end

  private

    def authorize
      true
    end

end
