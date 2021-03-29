require 'test_helper'

class UserMailerTest < ActionMailer::TestCase
  test "enquiry" do
    mail = UserMailer.enquiry
    assert_equal "Enquiry", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
