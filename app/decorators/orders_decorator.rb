class OrdersDecorator < Draper::CollectionDecorator
  delegate :total_pages, :current_page, :limit_value
end
