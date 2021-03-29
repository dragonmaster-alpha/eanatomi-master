class ProductGridDecorator < ProductDecorator
  delegate_all

  def sortable?
    context[:sortable]
  end

  def to_partial_path
    'products/grid_item'
  end

end
