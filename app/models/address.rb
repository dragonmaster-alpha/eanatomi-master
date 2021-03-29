class Address
  attr_accessor :code, :name, :att, :street, :zip_code, :city, :country, :country_code

  def initialize(args={})
    args.each do |k, v|
      instance_variable_set("@#{k}", v)
    end
  end
end
