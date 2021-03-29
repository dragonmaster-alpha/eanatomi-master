class CategoryGridDecorator < CategoryDecorator
  delegate_all

  def sortable?
    context[:sortable]
  end

  def to_partial_path
    'categories/grid_item'
  end

  def action
    products_size.zero? ? 'view_categories' : 'view_products'
  end

  def offer?
  end

  def label
  end

  def size?
  end

  def in_stock?
  end

  def stock_info
  end

  def purchasable?
  end

  def shipping_time_description
  end

  def products_size
    object.products_count.to_i
  end

  def categories_size
    object.regular_categories_count.to_i
  end

end
