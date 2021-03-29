class Import

  def initialize(class_name, file)
    @file = file
    @class_name = class_name
  end

  def workbook
    @_workbook ||= Spreadsheet.open @file.path
  end

  def sheet
    @_sheet ||= workbook.worksheets.first
  end

  def headers
    @_headers ||= sheet.rows.first
  end

  def content
    sheet.rows[1..-1]
  end

  def item_size
    content.size
  end

  def klass
    @class_name.constantize
  end

  def data_for(row)
    data = {}

    row.each_with_index do |value, i|
      data[headers[i]] = value
    end

    permitted_data(data)
  end

  def update!
    content.each do |row|
      data = data_for(row)
      Rails.logger.info("Importing #{@class_name} #{finder(data)}")
      item = klass.find_by(finder(data))
      if item && item.update!(data)
        Rails.logger.info("Imported #{item} with #{data}")
      end
    end
  end

  def finder(data)
    [data.each_pair.first].to_h
  end

  def permitted_data(data)
    data.select { |k, v| permitted_attributes.include?(k) }
  end

  def permitted_attributes
    klass.attribute_names.map do |attr|
      if attr.ends_with?('_translations')
        I18n.available_locales.map do |locale|
          attr.gsub('_translations', "_#{locale}")
        end + [attr]
      else
        attr
      end
    end.flatten
  end

end
