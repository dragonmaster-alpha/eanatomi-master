$(document).on('click', '@stepper-up, @stepper-down', function () {
  var sender = $(this)
  var parent = sender.parents('@stepper')
  var target = parent.find('@stepper-input')
  var val = parseInt(target.val())

  if (sender.is('@stepper-up')) {
    val++
  } else {
    val--
  }

  target.val(val)
  parent.trigger('stepper:changed', val)
})
