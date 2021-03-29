class Category < ApplicationRecord
  include Sortable
  include Activatable
  include ImgixUploader[:imgix_photo]
  include ImgixUploader[:imgix_icon]

  TEMPLATES = %i( default offers latest ).freeze

  translates :name, :meta_title, :meta_description, :slug, :body, :extended_body, accessors: I18n.available_locales
  belongs_to :category, optional: true, touch: true
  has_many :categories
  has_many :products
  has_many :featured_categories, dependent: :destroy
  has_many :translation_changes, dependent: :destroy, as: :object

  has_many :regular_categories, -> { regular }, class_name: 'Category'
  has_many :inline_categories, -> { inline }, class_name: 'Category'

  has_many :banners, class_name: 'CategoryBanner', dependent: :destroy
  has_many :sorted_banners, -> { sorted }, class_name: 'CategoryBanner'

  has_many :mega_images, class_name: 'CategoryMegaimage', dependent: :destroy
  has_many :sorted_mega_images, -> { sorted }, class_name: 'CategoryMegaimage'

  after_save :update_counter_cache
  after_destroy :update_counter_cache

  scope :top, -> { where(category: nil) }

  scope :regular, -> { where(is_inline: [nil, false]) }
  scope :inline, -> { where(is_inline: true) }


  enum status: {
    active:   0,
    inactive: 1
  }

  MEGAMENU_TYPES = ['one_large', 'two_large', 'half_height', 'large_small']

  def self.slug(slug)
    find(/\d+\z/.match(slug).to_s)
  end

  def self.offers
    self.find_by(template: 'offers')
  end

  def parameterize
    name.parameterize
  end

  def banner
    banners.sorted.first || CategoryBanner.new
  end

  def to_s
    name
  end

  def option_name
    is_inline ? "#{category.name} - #{self.name}" : self.name
  end

  def to_param
    "#{name.to_s.parameterize}-#{id}"
  end

  def path
    parents + [self]
  end

  def parents
    parents = []
    parent = self.category

    while parent
      parents << parent
      parent = parent.category
    end

    parents
  end

  def update_counter_cache
    category.update categories_count: category.categories.active_in_markets.count if category
    category.update regular_categories_count: category.regular_categories.active_in_markets.count if category
  end

end
