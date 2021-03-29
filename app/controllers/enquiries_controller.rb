class EnquiriesController < ApplicationController
  def create
    @enquiry = Enquiry.new(params[:enquiry].permit!)

    if (verify_recaptcha(model: @enquiry) && @enquiry.save)
      UserMailer.enquiry(@enquiry).deliver_later
      redirect_to @enquiry
    else
      redirect_back fallback_location: root_path, notice: 'CAPTCHA not verified'
    end
  end

  def show
    @enquiry = Enquiry.find(params[:id])
  end
end
