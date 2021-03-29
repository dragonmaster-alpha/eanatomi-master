class Accounting::Base::CustomerContact
  attr_accessor :id, :name, :customer, :market

  def initialize(options={})
    options.each do |k, v|
      instance_variable_set("@#{k}", v)
    end
  end

  def save!
    raise NotImplementedError
  end

end
