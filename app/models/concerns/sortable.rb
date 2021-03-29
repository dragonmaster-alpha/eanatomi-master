module Sortable
  extend ActiveSupport::Concern

  included do
    scope :sorted, -> { order(:position) }
    before_create :set_position
  end

  def set_position
    self.position ||= last_position + 1
  end

  def last_position
    klass = self.model_name.name.constantize
    klass.unscoped.order(position: :desc).where.not(position: nil).limit(1).pluck(:position).first.to_i
  end

end
