class GiftCardsMailer < ApplicationMailer

  def created(gift_card)
    @gift_card = gift_card

    attachments['gavekort.pdf'] = @gift_card.file.read
    attachments['faktura.pdf'] = @gift_card.invoice.file.read

    mail to: gift_card.email, subject: 'Gavekort til eAnatomi', bcc: 'info@eanatomi.dk'
  end

end
