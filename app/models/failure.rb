class Failure < ApplicationRecord
  belongs_to :order

  enum status: {
    unseen: 0,
    seen: 1,
    fixed: 2
  }
end
