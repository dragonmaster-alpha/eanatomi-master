class Country
  
  # https://github.com/umpirsky/country-list

  def initialize(locale)
    @locale = locale
  end

  def all
    data
  end

  def find(code)
    data[code.to_s.upcase]
  end

  private

  def data
    @_data ||= JSON.parse(read_file)
  end

  def read_file
    File.read(file_path)
  end

  def file_path
    File.expand_path("../country/#{@locale}/country.json", __FILE__)
  end

end
