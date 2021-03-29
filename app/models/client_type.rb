class ClientType

  CLIENT_TYPES = %w( private business ).freeze

  def self.all
    CLIENT_TYPES
  end

  def self.default
    'private'
  end

end
