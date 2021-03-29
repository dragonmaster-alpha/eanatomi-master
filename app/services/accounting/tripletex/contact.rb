class Accounting::Tripletex::Contact
  attr_accessor :id, :name

  def self.create!(args)
    contact = self.new(args)
    contact.save!
    contact
  end

  def initialize(args={})
    @name = args[:name]
    @id = args[:id]
  end

  def save!
    result = Accounting::Tripletex::Client.new.post('contact', self.serialize)
    @id = result['value']['id']
    true
  end

  def serialize
    names = @name.split(' ')
    first_name = names.shift
    last_name = names.join(' ')

    {
      firstName: first_name,
      lastName: last_name
    }
  end

end
