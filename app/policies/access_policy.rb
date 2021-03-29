class AccessPolicy
  include AccessGranted::Policy

  def configure

    role :admin, proc { |u| u.admin? } do
      can :manage, Order
      can :manage, Invoice
      can :manage, OrderItem
      can :manage, Category
      can :manage, CategoryBanner
      can :manage, CategoryMegaimage
      can :manage, Product
      can :manage, ProductPhoto
      can :manage, Manufacturer
      can :manage, ShippingTime
      can :manage, Page
      can :manage, PageBanner
      can :manage, TimelineEvent
      can :manage, User
      can :manage, Translation
      can :manage, Logistics
      can :manage, FeaturedProduct
      can :manage, FeaturedCategory
      can :manage, Campaign
      can :manage, Import
      can :manage, Voucher
      can :manage, TranslationChange
      can :manage, GiftCard
      can :manage, PurchaseOrder
      can :manage, Notice
      can :manage, ProductSale
      can :manage, Market
      can :manage, DeliveryMethod
      can :read, :admin
    end

    role :translator, proc { |u| u.translator? } do
      can :manage, TranslationChange
      can :manage, TimelineEvent
      can :manage, Translation
      can :read, :admin
      can :update, Page
      can :update, Product
      can :update, Category
    end

  end
end
