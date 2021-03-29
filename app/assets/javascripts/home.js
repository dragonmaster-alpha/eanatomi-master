// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.


app.home = new function () {

  this.init = function () {

    conversion()

  }

  var conversion = function () {
    if (window.google_trackConversion) {
      window.google_trackConversion({
        google_conversion_id: 989808321,
        google_custom_params: {
          ecomm_pagetype: 'home'
        },
        google_remarketing_only: true
      })
    }
  }

}
