app.admin_translations = new function () {

  this.init = function () {
    $('@translations-form').houdini()
  }

  this.updateField = function () {
    var field = this
    $(field).addClass('translations-saving')
    $.ajax({
      url: $('@translations-form')[0].action,
      type: 'PATCH',
      data: {
        translation: {
          locale: field.dataset.locale,
          key: field.dataset.key,
          value: field.value
        }
      },
      success: function () {
        $(field).removeClass('translations-saving')
      }
    })
  }

}

$(document).on('turbolinks:load', app.admin_translations.init)
$(document).on('change', '@translations-field', app.admin_translations.updateField)
