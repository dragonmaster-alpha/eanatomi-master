class ProductSearch
  def initialize(context:, query:, limit: nil)
    self.context = context
    self.query = query
    self.limit = limit
  end

  def call
    products_with_query_in_sku + products_from_search
  end

  private

  attr_accessor :context, :query, :limit

  def products_from_search
    Product.search(
      SearchEncoder.new.encode(query),
      where: {
        id: { not: products_with_query_in_sku.ids },
        active_in: context.market.key,
        is_variant: false
      },
      fields: [
        "#{locale_name}^10",
        { "#{locale_name}^5" => :word_start },
        { "#{locale_name}^1" => :word_end },
        "#{locale_variants}^9",
        { "#{locale_variants}^4" => :word_start },
        { "#{locale_variants}^1" => :word_end },
        "#{locale_keywords}^8",
        { "#{locale_keywords}^2" => :word_start },
        { "#{locale_keywords}^1" => :word_end },
        "#{locale_sku}^7",
        { "#{locale_sku}^5" => :word_start },
        { "#{locale_sku}^1" => :word_end },
      ],
      limit: products_from_search_limit
    )
  end

  def products_with_query_in_sku
    @products_with_query_in_sku ||= Product.active_in(context.market.key).
      not_variant.
      sku_includes(query).
      limit(limit).
      order(:sku)
  end

  def locale_name
    "name_#{context.market.locale}"
  end

  def locale_variants
    "variant_names_#{context.market.locale}"
  end

  def locale_keywords
    "keywords_#{context.market.locale}"
  end

  def locale_sku
    "sku"
  end

  def products_from_search_limit
    if limit
      limit - products_with_query_in_sku.count
    end
  end
end
