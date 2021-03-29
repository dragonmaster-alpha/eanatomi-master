module HasZipAndCity
  extend ActiveSupport::Concern

  class_methods do
    def has_zip_and_city(name, zip:, city:)
      define_method name do
        [self.send(zip), self.send(city)].compact.join(' ')
      end

      define_method "#{name}=" do |value|
        match = /(\d*) *(.+)/.match(value)
        if match
          self.send("#{zip}=", match[1])
          self.send("#{city}=", match[2])
        else
          self.send("#{zip}=", '')
          self.send("#{city}=", '')
        end
      end
    end
  end

end
