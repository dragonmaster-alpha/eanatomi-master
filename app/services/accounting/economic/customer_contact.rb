class Accounting::Economic::CustomerContact < Accounting::Base::CustomerContact

  def serialize
    {
      name: name.to_s
    }
  end

  def save!
    self.id = Accounting::Economic.new(@market).create_customer_contact(self)
    self
  end

end
