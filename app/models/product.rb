class Product < ApplicationRecord
  include Sortable
  include Activatable
  include FileUploader[:datasheet]

  translates :name, :description, :slug, :keywords, :meta_title, :meta_description, :label, :size, accessors: I18n.available_locales

  searchkick(
    :callbacks   => (Rails.env.production? ? :queue : false),
    :batch_size  => 200,
    word_start: [:name_da, :name_sv, :name_nb],
    word_end: [:name_da, :name_sv, :name_nb],
    settings: { number_of_shards: 1, number_of_replicas: 1 }
  )

  belongs_to :category, optional: true, touch: true
  belongs_to :shipping_time, optional: true
  belongs_to :manufacturer, optional: true

  has_many :purchase_order_items, dependent: :destroy

  has_many :additional_descriptions, class_name: 'ProductDescription', dependent: :destroy

  belongs_to :product, optional: true
  has_many :variants, class_name: 'Product', dependent: :destroy

  has_many :product_addons, dependent: :destroy, foreign_key: 'owner_id'
  has_many :addons_to_product, dependent: :destroy, foreign_key: 'addon_id', class_name: 'ProductAddon'
  has_many :addons, through: :product_addons, class_name: 'Product'

  has_many :product_components, dependent: :destroy, foreign_key: 'owner_id'
  has_many :components_to_product, dependent: :destroy, foreign_key: 'component_id', class_name: 'ProductComponent'
  has_many :components, through: :product_components, class_name: 'Product'

  has_many :translation_changes, dependent: :destroy, as: :object

  has_many :photos, class_name: 'ProductPhoto', dependent: :destroy
  has_many :sorted_photos, -> { sorted }, class_name: 'ProductPhoto'
  has_many :vendor_prices, dependent: :destroy
  has_many :featured_products, dependent: :destroy

  has_many :complementary_products, dependent: :destroy, foreign_key: 'owner_id'
  has_many :complementary_relations, dependent: :destroy, foreign_key: 'target_id', class_name: 'ComplementaryProduct'
  has_many :complementaries, through: :complementary_products, source: :target

  has_many :volume_prices, dependent: :destroy

  before_create :set_ean_number
  before_save :nullify_product_or_category
  after_save :update_counter_cache
  after_destroy :update_counter_cache

  scope :translated, -> { where.not("name_translations -> 'da' = ?", '').where.not("name_translations -> 'nb' = ?", '').where.not("name_translations -> 'sv' = ?", '') }
  scope :not_translated, -> { where("name_translations -> 'da' = ?", '').or(where("name_translations -> 'nb' = ?", '')).or(where("name_translations -> 'sv' = ?", '')) }
  scope :active, -> { where.not(status: 10).translated }
  scope :not_variant, -> { where(product_id: nil) }
  scope :on_offer, -> { where('offer_price > ?', 0) }
  scope :cheapest_first, -> { order(offer_price: :asc).order(price: :asc) }
  scope :latest, -> { order(created_at: :desc) }
  scope :purchaseable, -> { where('price > ?', 0) }
  scope :sku_includes, -> (term) { where("lower(sku) LIKE ?", "%#{term.downcase}%") }
  scope :no_components, -> { left_outer_joins(:product_components).where(product_components: { id: nil }) }

  accepts_nested_attributes_for :volume_prices, allow_destroy: true, reject_if: proc { |attributes| attributes['quantity'].blank? }
  accepts_nested_attributes_for :additional_descriptions, allow_destroy: true, reject_if: proc { |attributes| attributes["body_#{ENV['DEFAULT_LOCALE']}"].blank? }

  enum status: {
    active: 0,
    inactive: 10
  }

  validates :sku, presence: true, uniqueness: true
  # validates :name_da, presence: true

  def self.sku(sku)
    find_by('lower(sku) = ?', sku.downcase)
  end

  def self.slug(slug)
    find(/\d+\z/.match(slug).to_s)
  end

  def option_name
    name
  end

  def is_variant?
    !!product_id
  end

  def has_variants?
    variants.any?
  end

  def has_components?
    product_components.any?
  end

  def ean_number
    reference
  end

  def set_ean_number
    self.reference = sku
  end

  def to_param
    "#{name.to_s.parameterize}-#{id}"
  end

  def photo
    photos.sorted.first || ProductPhoto.new
  end

  def to_s
    name || super
  end

  def offer_percentage
    ((1 - offer_price / price) * 100).round
  end

  def offer?
    offer_price.to_i > 0
  end

  def parents
    if category
      [category] + category.parents
    else
      []
    end
  end

  def shipping_time
    super || ShippingTime.default
  end

  def sales_price
    offer? ? offer_price : price
  end

  def should_restock?
    return false if has_components?
    presumable_stock < restocking_threshold
  end

  def restocking_threshold
    super || 0
  end

  def restocking_amount
    super || 0
  end

  def purchase_order_amount
    presumable_stock * -1 + restocking_amount
  end

  def stock
    if has_components?
      components.map(&:stock).sort.first
    else
      super
    end
  end

  def presumable_stock
    if has_components?
      components.map(&:presumable_stock).sort.first
    else
      val = stock.to_i
      val = val - unshipped_order_items.map(&:quantity).inject(&:+).to_i
      # val = val + PurchaseOrderItem.joins(:purchase_order).merge(PurchaseOrder.pending).where(product_id: id).map(&:quantity).inject(&:+).to_i

      val
    end
  end

  def unshipped_order_items
    OrderItem.joins(:order).merge(Order.unshipped).where(product_id: id)
  end

  def search_data
    SearchEncoder.new.encode({
      name_da: name_da,
      name_sv: name_sv,
      name_nb: name_nb,

      keywords_da: keywords_da,
      keywords_sv: keywords_sv,
      keywords_nb: keywords_nb,

      variant_names_da: variant_names_da,
      variant_names_sv: variant_names_sv,
      variant_names_nb: variant_names_nb,

      sku: sku,
      active_in: active_in_market.active_markets,
      is_variant: is_variant?
    })
  end

  def variant_names_da
    variants.map(&:name_da)
  end

  def variant_names_sv
    variants.map(&:name_sv)
  end

  def variant_names_nb
    variants.map(&:name_nb)
  end

  def update_counter_cache
    if category
      category.inline_categories.each do |c|
        c.update products_count: c.products.active_in_markets.count
      end

      category.update products_count: category.products.active_in_markets.count + category.inline_categories.pluck(:products_count).inject(&:+).to_i
    end
  end

  def nullify_product_or_category
    if product_id_changed? && product_id
      self.category_id = nil
    elsif category_id_changed? && category_id
      self.product_id = nil
    end
  end

end
