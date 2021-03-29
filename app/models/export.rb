class Export

  def initialize(items, fields)
    @items = items
    @fields = fields
  end

  def workbook
    book = Spreadsheet::Workbook.new
    sheet = book.create_worksheet

    sheet.row(0).concat @fields.map(&:to_s)

    @items.each_with_index do |product, i|
      data = @fields.map do |field|
        product.send(field)
      end

      sheet.row(i+1).concat data
    end

    book
  end

  def raw
    content = write
    content.rewind

    content.read
  end

  def write
    content = StringIO.new
    workbook.write content

    content
  end

  def io
    workbook.io
  end

end
