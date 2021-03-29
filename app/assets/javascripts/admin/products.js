// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.


app.admin_products = new function() {

  this.init = function() {
    $('@related').selectize({
      plugins: ['remove_button'],
      valueField: 'id',
      labelField: 'name',
      searchField: ['name', 'sku'],
      options: gon.products
    })
  }
}
