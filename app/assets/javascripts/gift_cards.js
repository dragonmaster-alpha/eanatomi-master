
app.giftCards = new function () {

  this.formSubmitted = function (e, data) {
    openPaymentWindow(data.paymentwindow)
  }

  this.formSubmitting = function () {
    if (!$('@new-giftcard-form')[0].checkValidity()) {
      $('@new-giftcard-form input:invalid').first().focus()
      $('@new-giftcard-form input:invalid').parents('.form-group').addClass('has-error').attr('dirty', '')
      return false
    }
  }

  this.validateInput = function (e) {
    var group = $(e.target).parents('.form-group')
    if (e.target.checkValidity()) {
      group.removeClass('has-error').addClass('has-success')
    }
    else {
      group.removeClass('has-success').addClass('has-error')
    }
  }

  var openPaymentWindow = function (data) {
    app.giftCards.paymentWindow = new PaymentWindow(data)
    app.giftCards.paymentWindow.on('close', app.giftCards.closedPaymentWindow)
    app.giftCards.paymentWindow.open()
  }
}

$(document).on('ajax:success', '@new-giftcard-form', app.giftCards.formSubmitted)
$(document).on('ajax:before', '@new-giftcard-form', app.giftCards.formSubmitting)
$(document).on('keyup', '@new-giftcard-form [dirty] input', app.giftCards.validateInput)
