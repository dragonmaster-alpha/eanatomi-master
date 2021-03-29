class Importer

  def initialize(file)
    @file = Rails.root.join('data', "#{file}.xml")
  end

  def doc
    @_doc ||= Oga.parse_xml(File.open(@file))
  end

  def items(path)
    doc.css(path).map do |item|
      Item.new(item)
    end
  end

  class Item

    def initialize(item)
      @item = item
    end

    def field(key)
      @item.at_css(key).text
    end

  end

end
