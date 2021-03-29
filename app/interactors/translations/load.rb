class Translations::Load
  include Interactor

  def call
    context.scopes = scopes
  end

  def scopes
    data = {}

    files.each do |file|
      YAML.load(File.open(file))[context.locale].each do |k, v|
        data[k] = flatten_hash(v).map { |item| "#{k}.#{item}" }
      end
    end

    data
  end

  def files
    Dir["config/locales/#{context.locale}/*.yml"]
  end

  def flatten_hash(my_hash, parent=[])
    my_hash.flat_map do |key, value|
      case value
        when Hash then flatten_hash( value, parent+[key] )
        else [(parent+[key]).join('.')]
      end
    end
  end

end
