class CategoryDecorator < Draper::Decorator
  delegate_all

  def meta_title
    object.meta_title.blank? ? object.name : object.meta_title
  end

  def products
    case object.template
    when 'offers'
      Product.active_in(context[:market_id]).on_offer.cheapest_first
    when 'latest'
      Product.active_in(context[:market_id]).latest.limit(20)
    else
      object.products.sorted
    end
  end

  def sortable?
    object.template == 'default'
  end


  def url
    h.category_url(object)
  end

  def parent
    object.category
  end

end
