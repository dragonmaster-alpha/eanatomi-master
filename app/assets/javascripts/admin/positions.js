app.admin_positions = new function () {
  this.init = function () {
    $('@sortable').each(function () {
      Sortable.create(this, {
        onUpdate: update
      })
    })
  }

  var update = function (e) {
    console.log(e)
    var data = {
      model: e.target.dataset.model,
      items: []
    }

    $(e.target).addClass('loading')

    $(e.target).children().each(function () {
      data.items.push(this.dataset.id)
    })

    $.ajax({
      url: '/admin/positions',
      type: 'PUT',
      data: data,
      success: updated
    })
  }

  var updated = function (result) {
    $('@sortable.loading').removeClass('loading')
  }
}

$(document).on('turbolinks:load', app.admin_positions.init)
