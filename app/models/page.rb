class Page < ApplicationRecord
  include Sortable
  include Activatable

  PLACEMENTS = ['customer_service', 'information', 'none', 'top', 'footer']

  translates :name, :body, :slug, :meta_title, :meta_description, accessors: I18n.available_locales

  scope :in_top, -> { where(placement: 'top') }
  scope :in_footer, -> { where(placement: 'footer') }
  scope :root, -> { where(page_id: nil) }
  scope :active, -> { where(is_active: true) }

  PLACEMENTS.each do |placement|
    scope "in_#{placement}", -> { where(placement: placement) }
  end

  belongs_to :page, optional: true
  has_many :pages, dependent: :nullify
  has_many :banners, class_name: 'PageBanner', dependent: :destroy
  has_many :sorted_banners, -> { sorted }, class_name: 'PageBanner'
  has_many :translation_changes, dependent: :destroy, as: :object


  enum template: {
    standard: 0,
    terms: 1,
    contact: 2,
    timeline: 3,
    information: 4,
    returns: 5,
    home: 6,
    services: 7,
    content: 8,
    about: 9
  }


  def self.slug(slug)
    find(/\d+\z/.match(slug).to_s)
  end

  def self.terms_page
    terms.first
  end

  def self.timeline_page
    timeline.first
  end

  def self.info_page
    information.first
  end

  def self.contact_page
    contact.first
  end

  def self.returns_page
    returns.first
  end

  def self.home_page
    home.first
  end

  def self.content_page
    content.first
  end

  def self.about_page
    about.first
  end
  def to_s
    name || super
  end


  def to_param
    "#{name.to_s.parameterize}-#{id}"
  end

end
