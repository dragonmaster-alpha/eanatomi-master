class GiftCards::CreatePDF
  include Interactor

  def call
    html = ActionController::Base.new.render_to_string(partial: "gift_cards/pdf", locals: { gift_card: context.gift_card })

    pdf = HyPDF.htmltopdf(
      html,
      test: Rails.env.development?
    )

    tmpfile = Tempfile.new(['gavekort', '.pdf'], encoding: 'ascii-8bit')
    tmpfile.write pdf[:pdf]

    tmpfile.rewind

    context.gift_card.update file: tmpfile
  end
end
