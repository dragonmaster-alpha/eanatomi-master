class Blogpost
  attr_accessor :title, :published_at, :photo_url, :url, :author

  def self.latest(market)
    return [] unless market.blog_url.present?

    url = "#{market.blog_url}/feeds/posts/default"

    Oga.parse_xml(self.feed(url)).css('entry').map do |entry|
      self.build(entry)
    end
  end

  def self.feed(url)
    Rails.cache.fetch(url, expires_in: 1.hours) do
      begin
        HTTP.timeout(connect: 1, read: 1).get(url).body.to_s
      rescue HTTP::TimeoutError
      end
    end
  end

  def self.build(entry)
    self.new.tap do |post|
      post.title = entry.at_css('title').text
      post.author = entry.at_css('author name').text
      post.published_at = DateTime.parse(entry.at_css('published').text)
      post.photo_url = entry.at_css('thumbnail').get('url')
      post.url = entry.at_css('link[rel="alternate"]').get('href')
    end
  end

end
