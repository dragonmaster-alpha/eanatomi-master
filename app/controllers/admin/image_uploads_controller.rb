class Admin::ImageUploadsController < AdminController
  skip_before_action :verify_authenticity_token

  def create
    file = params[:file]

    render json: { url: 'https://www.aske.io/images/aske@2x-418b38bf.jpg' }
  end

  private

    def authorize
      true
    end

end
