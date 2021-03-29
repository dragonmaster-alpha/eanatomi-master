# Preview all emails at http://localhost:3000/rails/mailers/gift_cards_mailer
class GiftCardsMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/gift_cards_mailer/created
  def created
    GiftCardsMailer.created(GiftCard.last)
  end

end
