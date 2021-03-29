// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.


app.checkout_orders = new function () {

  this.init = function () {
    $('@order-form').houdini()
  }

  this.findServicepoint = function (e) {
    var stamp = Date.now()
    var target = $('@checkout-find-servicepoint')[0]
    $('@checkout-find-servicepoint-search').addClass('hidden')
    $('@checkout-find-servicepoint-spinner').removeClass('hidden')
    target.dataset.stamp = stamp
    setTimeout(function () {
      if (target.dataset.stamp == stamp) {
        $.get('/checkout/servicepoints?query=' + target.value, function (result) {
          $('@order-servicepoints').html(result)
          $('@checkout-find-servicepoint-search').removeClass('hidden')
          $('@checkout-find-servicepoint-spinner').addClass('hidden')
        })
      }
    }, 300)
  }

  this.chooseServicepoint = function (e) {
    $('@checkout-selected-servicepoint-address').html(e.currentTarget.dataset.name + ', ' + e.currentTarget.dataset.street + ', ' + e.currentTarget.dataset.city)
    $('@checkout-servicepoint-id').val(e.currentTarget.dataset.id)
    $('@checkout-servicepoint-name').val(e.currentTarget.dataset.name)
    $('@checkout-servicepoint-street').val(e.currentTarget.dataset.street)
    $('@checkout-servicepoint-zip-code').val(e.currentTarget.dataset.zipCode)
    $('@checkout-servicepoint-city').val(e.currentTarget.dataset.city)
    $('@checkout-servicepoint-country-code').val(e.currentTarget.dataset.countryCode)
    $('@servicepoints-modal').modal('hide')
  }

  this.clientTypeChange = function () {
    $("@order-delivery-method:visible")[0].checked = true
    $("@order-delivery-method:visible").trigger('change')
    // if ($('@order-client-type:checked').val() === 'business') {
    //   $('@order-delivery-method-door')[0].checked = true
    //   $('@order-delivery-method-door').trigger('change')
    // }
  }

  this.copyAddressChange = function () {
    if ($(this).is(':checked')) {
      app.checkout_orders.copyAddress()
    }
    else {
      app.checkout_orders.clearAddress()
    }
  }

  this.copyAddress = function () {
    $('@checkout-address input').each(function () {
      var name = this.name.replace('[', '[delivery_')
      var elem = $('@checkout-delivery-address input[name="' + name + '"]')
      elem.val($(this).val())
    })
  }

  this.chooseDeliveryAddress = function () {
    $('@checkout-selected-servicepoint-address').html($('@delivery-address-modal input[name="delivery_name"]').val() + ', ' + $('@delivery-address-modal input[name="delivery_address"]').val() + ', ' + $('@delivery-address-modal input[name="delivery_city"]').val())

    $('@delivery-address-modal input').each(function () {
      var name = this.name
      var elem = $('@checkout-delivery-address input[name="order[' + name + ']"]')
      elem.val($(this).val())
    })
    $('@delivery-address-modal').modal('hide')
  }

  this.clearAddress = function () {
    $('@checkout-address input').each(function () {
      var name = this.name.replace('[', '[delivery_')
      var elem = $('@checkout-delivery-address input[name="' + name + '"]')
      elem.val('')
    })
  }

  this.vatNumberChange = function () {
    $('@checkout-vat-number').val(this.value)
  }

  this.quantityBlur = function () {
    $(this).parents('@quantity-form').trigger('submit')
  }

  this.quantityChange = function () {
    $(this).trigger('submit')
  }

  this.quantityUpdated = function (e, data) {

    $('@order').html(data.order_html)
    $('@to_pay').html(data.to_pay_html)
  }

  this.formSubmitted = function (e, data) {
    // openPaymentWindow(data.paymentwindow)
  }

  this.validateForm = function () {
    var elements = $('@order-form input[required]:not(:visible)')

    elements.each(function () {
      this.required = false
    })

    var validity = $('@order-form')[0].checkValidity()

    elements.each(function () {
      this.required = true
    })

    return validity
  }

  this.servicepointsModalShown = function () {
    $('@checkout-find-servicepoint').val($('@order-zip-code').val() + ' ' + $('@order-address').val())
    app.checkout_orders.findServicepoint()
  }

  this.formSubmitting = function () {

    if (!app.checkout_orders.validateForm()) {
      $('@order-form input:invalid').first().focus()
      $('@order-form input:invalid').parents('.form-group').addClass('has-error').attr('dirty', '')
      return false
    }

    if ($('@accept-terms:checked').length === 0) {
      alert($('@accept-terms').data('message'))
      $('@accept-terms').focus()
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

  this.formFailed = function (e, data) {
    window.alert(data.responseText)
  }

  this.deliveryMethodChange = function() {
    updateField( { order: { delivery_method: this.value } })
  }

  this.paymentMethodChange = function() {
    updateField( { order: { payment_method: this.value } })
  }

  this.courierChange = function() {
    updateField( { order: { courier: this.value } })
  }

  // PRIVATE

  var updateField = function (data) {
    $.ajax({
      url: $('@order-form').data('update-path'),
      type: 'PATCH',
      data: data,
      success: function (result) {
        $('@order').html(result.order_html)
        $('@to_pay').html(result.to_pay_html)
      }
    })
  }

  var openPaymentWindow = function (data) {
    app.checkout_orders.paymentWindow = new PaymentWindow(data)
    app.checkout_orders.paymentWindow.open()
  }
}

$(document).on('stepper:changed', '@quantity-form', app.checkout_orders.quantityChange)
$(document).on('blur', '@quantity-input', app.checkout_orders.quantityBlur)
$(document).on('ajax:success', '@quantity-form, @remove-order-item', app.checkout_orders.quantityUpdated)
$(document).on('ajax:success', '@order-form', app.checkout_orders.formSubmitted)
$(document).on('ajax:error', '@order-form', app.checkout_orders.formFailed)
$(document).on('change', '@order-delivery-method', app.checkout_orders.deliveryMethodChange)
$(document).on('change', '@order-payment-method', app.checkout_orders.paymentMethodChange)
$(document).on('change', '@order-courier', app.checkout_orders.courierChange)
$(document).on('ajax:before', '@order-form', app.checkout_orders.formSubmitting)
$(document).on('keyup', '@order-form [dirty] input', app.checkout_orders.validateInput)
$(document).on('change', '@checkout-vat-number', app.checkout_orders.vatNumberChange)
$(document).on('change', '@checkout-copy-address', app.checkout_orders.copyAddressChange)
$(document).on('change', '@order-client-type', app.checkout_orders.clientTypeChange)
$(document).on('keyup', '@checkout-find-servicepoint', app.checkout_orders.findServicepoint)
$(document).on('click', '@checkout-choose-servicepoint', app.checkout_orders.chooseServicepoint)
$(document).on('shown.bs.modal', '@servicepoints-modal', app.checkout_orders.servicepointsModalShown)
$(document).on('click', '@checkout-choose-delivery-address', app.checkout_orders.chooseDeliveryAddress)
