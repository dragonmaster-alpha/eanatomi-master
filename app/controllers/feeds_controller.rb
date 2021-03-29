class FeedsController < ApplicationController

  def index

    feeds = [
      { name: 'Google Shopping', path: 'google_shopping.xml' },
      { name: 'Sitemap', path: 'sitemap.xml' }
    ]

    doc = Nokogiri::XML::Builder.new(encoding: 'UTF-8') do |xml|
      xml.feeds do
        feeds.each do |feed|
          xml.feed do
            xml.name feed[:name]
            xml.url "#{root_url}feeds/#{feed[:path]}"
          end
        end
      end
    end

    render xml: doc
  end

  def google_shopping
    doc = Nokogiri::XML::Builder.new(encoding: 'UTF-8') do |xml|
      xml.rss('xmlns:g' => 'http://base.google.com/ns/1.0', 'version' => '2.0') {
        xml.channel {
          xml.title 'eAnatomi'
          xml.link root_url
          xml.description 'Produkt feed'

          category_tree = Category.all.map do |category|
            [category.id, [category] + category.parents]
          end.to_h

          products = Product.includes(:sorted_photos, :manufacturer)
            .active_in(context.market.key)
            .purchaseable.decorate(with: ProductFeedDecorator, context: { market: context.market, category_tree: category_tree })
            .reject(&:gift_card?)

          products.each do |product|
            xml.item do
              xml['g'].id                      product.id
              xml.title                        product.title
              xml.description                  product.description
              xml.link                         product.link
              xml['g'].price                   product.price
              xml['g'].condition               product.condition
              xml['g'].availability            product.availability
              xml.gtin                         product.gtin
              xml.brand                        product.brand
              xml['g'].google_product_category product.google_product_category
              xml['g'].product_type            product.product_type

              xml['g'].image_link              product.image_link if product.photo?
              xml['g'].sale_price             product.sales_price if product.offer?

              product.additional_image_links.each { |link| xml['g'].additional_image_link(link) }

              xml['g'].shipping do
                delivery = DeliveryMethod.for_market(context.market.key).first
                xml['g'].country context.market.country_code
                xml['g'].service delivery.id
                xml['g'].price view_context.number_to_currency(Currency.new(delivery.cost, context.market.rate, context.market.vat).net_amount, format: '%n %u')
              end
            end
          end
        }
      }
    end

    render xml: doc
  end

  def sitemap
    doc = Nokogiri::XML::Builder.new(encoding: 'UTF-8') do |xml|
      xml.urlset('xmlns' => 'http://www.sitemaps.org/schemas/sitemap/0.9') do
        Category.active_in(context.market.key).decorate.each do |category|
          xml.url { xml.loc(category.url) }
        end
        Product.active_in(context.market.key).decorate.each do |product|
          xml.url { xml.loc(product.url) }
        end
      end
    end

    render xml: doc
  end

end
