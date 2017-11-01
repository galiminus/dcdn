class S3Controller < ActionController::Base
  include Knock::Authenticable
  before_action :authenticate_user

  AWS_SERVICE = 's3'

  def sign
    self.response_body = hmac_data
  end

  def hmac_data
    timestamp = params[:datetime]

    date = hmac("AWS4#{ENV["S3_SECRET"]}", timestamp[0..7])
    region = hmac(date, ENV["S3_REGION"])
    service = hmac(region, AWS_SERVICE)
    signing = hmac(service, 'aws4_request')

    hexhmac(signing, params[:to_sign])
  end

  private

  def hmac(key, value)
    OpenSSL::HMAC.digest(OpenSSL::Digest.new('sha256'), key, value)
  end

  def hexhmac(key, value)
    OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha256'), key, value)
  end
end
