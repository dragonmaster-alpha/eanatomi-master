app.admin_orders = new function () {

  this.init = function () {
    $('@admin-order-form').houdini()
  }

  this.findServicepoint = function (e) {
    var stamp = Date.now()
    var courier = $('@admin-order-courier:checked')[0].value
    var market = $("@admin-order-market option:selected")[0].value
    var target = $('@admin-find-servicepoint')[0]
    $('@admin-find-servicepoint-spinner').removeClass('hidden')
    target.dataset.stamp = stamp
    setTimeout(function () {
      if (target.dataset.stamp == stamp) {
        $.get('/checkout/servicepoints?query=' + target.value + '&courier=' + courier + '&market=' + market, function (result) {
          $('@admin-order-servicepoints').html(result)
          $('@admin-find-servicepoint-spinner').addClass('hidden')
        })
      }
    }, 300)
  }

  this.chooseServicepoint = function (e) {
    $('@admin-servicepoint-id').val(e.currentTarget.dataset.id)
    $('@admin-servicepoint-name').val(e.currentTarget.dataset.name)
    $('@admin-servicepoint-street').val(e.currentTarget.dataset.street)
    $('@admin-servicepoint-zip-code').val(e.currentTarget.dataset.zipCode)
    $('@admin-servicepoint-city').val(e.currentTarget.dataset.city)
    $('@admin-servicepoint-country-code').val(e.currentTarget.dataset.countryCode)
  }

}


$(document).on('keyup', '@admin-find-servicepoint', app.admin_orders.findServicepoint)
$(document).on('click', '@checkout-choose-servicepoint', app.admin_orders.chooseServicepoint)
