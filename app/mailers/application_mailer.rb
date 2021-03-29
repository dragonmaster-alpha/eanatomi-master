class ApplicationMailer < ActionMailer::Base
  include Roadie::Rails::Automatic
  default from: 'eanatomi.dk <service@eanatomi.dk>'
  layout 'mailer'
end
