class StaticProductComparisonsController < ApplicationController
  def show
    @pages = Page.find([22, 23, 24, 25, 26, 27])
  end
end
