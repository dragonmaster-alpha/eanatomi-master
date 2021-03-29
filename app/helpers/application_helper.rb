module ApplicationHelper

  def defer_js?
    Rails.env.production?
  end

  def flash_class(kind)
    case kind
    when 'success'
      'bg-green'
    else
      'bg-black'
    end
  end

  def enabled?(feature)
    Flipper.enabled?(feature, current_user)
  end

  def left_header_campaign
    @_left_header_campaign ||= Campaign.active_in(context.market.key).in_header_left.first
  end

  def right_header_campaign
    @_right_header_campaign ||= Campaign.active_in(context.market.key).in_header_right.first
  end

  def notice
    @_notice ||= Notice.active_in(context.market.key).first
  end

  def image_2x_tag(img, opts={})
    x2_img = img.gsub(/(.+)(\.\w+)/, '\1@2x\2')
    x2_path = image_path(x2_img)
    opts[:srcset] = "#{x2_path} 2x"

    image_tag(img, opts)
  end

  def short_number_to_currency(amount)
    "#{amount.to_i},-"
  end

  def show_vat?
    context.user.show_vat? && context.market.vat?
  end

  def customer_service_pages
    Page.in_customer_service
  end

  def information_pages
    Page.in_information
  end

  def active_if(path)
    'active' if controller_path == path
  end

  def t(key, options={})
    if params[:translation] == 'keys'
      if key.to_s.first == "."
        path = controller_path.tr("/", ".")
        defaults = [:"#{path}#{key}"]
        defaults << options[:default] if options[:default]
        options[:default] = defaults
        key = "#{path}.#{action_name}#{key}"
      end

      key
    else
      super
    end
  end

  def page_class
    controller_name
  end

  def errors_for(item)
    render partial: 'errors', locals: { item: item }
  end

  def top_categories
    @_top_categories ||= Category.active_in(context.market.key).top.sorted
  end

  def context
    @_context ||= Context.new(session.id, request.host, current_user)
  end

  def fa(icon, options={})
    class_names = ['fa', "fa-#{icon}", options[:class]]
    class_names << "fa-#{options[:size]}" if options[:size]
    class_names << "fa-state-#{options[:state]}" if options[:size]

    content_tag('i', nil, class: class_names.join(' '))
  end

  def all_markets
    @_all_markets ||= Market.active
  end

  def all_locales
    @_all_locales ||= Market.sorted.map(&:locale).map { |l| l.first(2) }.uniq
  end

  def top_pages
    @_top_pages ||= Page.active_in(context.market.key).in_top.sorted
  end

  def footer_pages
    @_footer_pages ||= Page.active_in(context.market.key).in_footer.sorted
  end

  def root_pages
    @_parent_pages ||= Page.active_in(context.market.key).root.sorted
  end

  def terms_page
    @_terms_page ||= Page.terms_page
  end

  def returns_page
    @_returns_page ||= Page.returns_page
  end

  def info_page
    @_info_page ||= Page.info_page
  end

  def contact_page
    @_contact_page ||= Page.contact_page
  end

  def latest_blogpost
    @_latest_blogpost ||= Blogpost.latest(context.market).first
  end

  def currency(amount)
    Currency.new(amount, context.market.rate, context.market.vat)
  end

  def enums_for(klass, field)
    klass.defined_enums[field.to_s].to_a.map do |k, v|
      name = t(k, scope: [:activerecord, [:attributes], klass.model_name.i18n_key, field.to_s.pluralize])
      [name, k]
    end
  end

  def variants_for(product)
    i = -1
    product.variants.map do |variant|
      i = i.next 
      content_tag 'div', class: ('hidden' if i.nonzero?), 'data-target': 'choose-variant.variant', 'data-id': variant.id do
        yield(variant, i)
      end
    end.join("\n").html_safe
  end

end
