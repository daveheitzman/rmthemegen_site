class ApplicationController < ActionController::Base
  protect_from_forgery
  include ReCaptcha::AppHelper
  ReCaptcha::AppHelper::RCC_PRIV = '6Ldq5MQSAAAAAF6DG-vxtB0EG1xX-aAeu9W4ddlt'
  ReCaptcha::AppHelper::RCC_PUB = "6Ldq5MQSAAAAAPhIPsPljDzS3uCW-ZMbd6hrrCn5"

end
