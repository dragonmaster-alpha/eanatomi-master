class Subscription

  def initialize(email, market, opts={})
    @email = email
    @market = market

    opts.each do |k, v|
      instance_variable_set("@#{k}", v)
    end
  end

  def subscribed?
    begin
      gibbon_member.retrieve['status'] == 'subscribed'
    rescue Gibbon::MailChimpError
      false
    end
  end

  def subscribe
    call do
      subscribe_mailchimp
    end
  end


  class RequestError < StandardError
  end

  private

    def subscribe_mailchimp
      merge_fields = {}
      merge_fields['FNAME'] = first_name if first_name.present?
      merge_fields['LNAME'] = last_name if last_name.present?

      gibbon_member.upsert body: { email_address: email, status: 'subscribed', merge_fields: merge_fields }
    end

    def call
      begin
        yield
      rescue Gibbon::MailChimpError => e
        raise RequestError, e.message
      end
    end

    def gibbon_member
      Gibbon::Request.lists(mc_list_id).members(email_hash)
    end

    def email
      @email.downcase
    end

    def email_hash
      md5 = Digest::MD5.new
      md5.update email
      md5.hexdigest
    end

    def first_name
      names.first
    end

    def last_name
      last_names = names
      last_names.shift
      last_names.to_a.join(' ')
    end

    def names
      @name.to_s.split(' ')
    end

    def mc_list_id
      id = {
        dk: 'MAILCHIMP_DK_LIST_ID',
        no: 'MAILCHIMP_NO_LIST_ID',
        se: 'MAILCHIMP_SE_LIST_ID'
      }[@market.to_sym]

      ENV[id]
    end

end
