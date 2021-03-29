class Accounting::Tripletex::Customer < Accounting::Base::Customer

  def save!
    result = Accounting::Tripletex::Client.new.post('customer', self.serialize)
    @id = result['value']['id']
    self
  end

  def serialize
    {
      name: @name,
      email: @email,
      phoneNumber: @phone,
      organizationNumber: vat_number,
      postalAddress: address,
      isPrivateIndividual: !business?
    }
  end

  def address
    {
      addressLine1: @address,
      postalCode: @zip,
      city: @city
    }
  end

  private

  def business?
    vat_number.present?
  end

  def vat_number
    @vat_number if /\A[0-9]{9}\z/ =~ @vat_number
  end

end
