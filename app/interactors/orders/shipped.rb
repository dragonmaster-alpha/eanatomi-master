class Orders::Shipped
  include Interactor::Organizer

  organize(
    Orders::UpdateShipping,
    Billing::Capture,
    Accounting::CreateInvoice,
    Accounting::BookInvoice,
    Orders::SendTrackingAndInvoice,
    Orders::CheckDelivery
  )

end
