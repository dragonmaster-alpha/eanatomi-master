class BreadcrumbSchema < ApplicationSchema
  include Rails.application.routes.url_helpers

  def initialize(path)
    @path = path
  end

  def structure
    {
      '@context' => 'http://schema.org',
      '@type' => 'BreadcrumbList',
      'itemListElement' => @path.map do |item|
        {
          '@type' => 'ListItem',
          'item' => {
            '@id' => url_for(item),
            'name' => item.to_s
          }
        }
      end
    }
  end

end
