class ProductComponent < ApplicationRecord
  belongs_to :component, class_name: 'Product'
  belongs_to :owner, class_name: 'Product'
end
