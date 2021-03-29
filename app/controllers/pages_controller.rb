class PagesController < ApplicationController
  def show
    begin
      @page = Page.slug(params[:id]).decorate
      @banners = @page.sorted_banners.to_a
    rescue ActiveRecord::RecordNotFound
      return not_found
    end

    if @page.home?
      return redirect_to '/'
    end

    ensure_url(@page)

    @pages = @page.pages.active_in(context.market.key)

    self.send @page.template
  end

  private

  def standard
  end

  def contact
    @enquiry = Enquiry.new(url: request.url)
  end

  def terms
  end

  def timeline
    @events = TimelineEvent.all
  end

  def information
  end

  def returns
  end

  def services
    @enquiry = Enquiry.new(url: request.url)
  end

  def content
    @about = Page.about_page.decorate
    @events = TimelineEvent.all.to_a
    @web_events = TimelineEvent.where(slider_type: 'web_design').to_a
    @history_events = TimelineEvent.where(slider_type: 'historical_events').to_a
  end
  def about
  end

end
