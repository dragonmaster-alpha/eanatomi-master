// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

app.products = new function () {
  this.init = function () {
    $('@product-photos').each(function() {
      var el = $(this)
      console.log('[role=' + el.data('delegate') + ']')
      el.magnificPopup({
        type: 'image',
        delegate: '[role=' + el.data('delegate') + ']',
        gallery: { enabled: true }
      })
    })

    conversion()
  }

  var conversion = function () {
    var product_schema = JSON.parse($('script[type="application/ld+json"]').html())
    fbq('track', 'ViewContent', {
        content_ids: product_schema.sku,
        content_type: 'product',
    })
    if (window.google_trackConversion) {
      window.google_trackConversion({
        google_conversion_id: 989808321,
        google_custom_params: {
          ecomm_pagetype: 'product',
          ecomm_prodid: gon.product.sku,
          ecomm_totalvalue: gon.product.price
        },
        google_remarketing_only: true
      })
    }
  }

}
