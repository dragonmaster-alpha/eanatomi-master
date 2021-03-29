class SearchEncoder

  def encode(val)
    case val
    when Hash
      encode_hash(val)
    when Array
      encode_array(val)
    when String
      encode_string(val)
    else
      Rails.logger.debug("no encoder for class #{val.class}")
      val
    end
  end

  private

  def encode_string(string)
    ActiveSupport::Inflector.transliterate(string)
  end

  def encode_array(array)
    array.map do |item|
      encode(item)
    end
  end

  def encode_hash(hash)
    hash.map do |key, val|
      [key, encode(val)]
    end.to_h
  end

end
