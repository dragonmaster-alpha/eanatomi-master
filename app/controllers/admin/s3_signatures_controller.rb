class Admin::S3SignaturesController < AdminController

  def show
    s3_key = ENV['BUCKETEER_AWS_ACCESS_KEY_ID']
    s3_secret = ENV['BUCKETEER_AWS_SECRET_ACCESS_KEY']
    s3_bucket = "/#{ENV['BUCKETEER_BUCKET_NAME']}"
    s3_url = 'http://s3.amazonaws.com'

    expire_time = 1.hour
    object_name = "/#{params[:name]}"
    mime_type = params[:type]
    expires = 1.hour.from_now
    amz_headers = 'x-amz-acl:public-read'
    string_to_sign = "PUT\n\n#{mime_type}\n#{expires}\n#{amz_headers}\n#{s3_bucket}#{object_name}"

    sig = CGI.escape(Base64.encode64("#{OpenSSL::HMAC.digest('sha1', s3_secret, string_to_sign)}\n"))

    url = CGI.escape("#{s3_url}#{s3_bucket}#{object_name}?AWSAccessKeyId=#{s3_key}&Expires=#{expires}&Signature=#{sig}")

    render plain: url
  end

  private

    def authorize
      true
    end

end
