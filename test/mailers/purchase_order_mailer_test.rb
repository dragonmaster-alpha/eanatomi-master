require 'test_helper'

class PurchaseOrderMailerTest < ActionMailer::TestCase
  test "restock" do
    mail = PurchaseOrderMailer.restock
    assert_equal "Restock", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
