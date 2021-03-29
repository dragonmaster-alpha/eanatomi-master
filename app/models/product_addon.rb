class ProductAddon < ApplicationRecord
  include Sortable

  belongs_to :addon, class_name: 'Product'
  belongs_to :owner, class_name: 'Product'
end
