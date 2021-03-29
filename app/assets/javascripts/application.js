//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require bootstrap-sprockets
//= require load-css
//= require jquery.role.min
//= require redactor.min
//= require redactor.alignment
//= require redactor.uploadcare
//= require redactor.source
//= require redactor.properties
//= require autotrack
//= require jquery.slick
//= require article-editor.min
//= require article-editor.uploadcare
//= require article-editor.selector
//= require reorder
// Bower
//= require houdini/src/houdini
//= require Sortable/Sortable.min
//= require magnific-popup/dist/jquery.magnific-popup.min
//= require selectize/dist/js/standalone/selectize.min
//= require garlicjs/dist/garlic-standalone.min

//= require_self
//= require_tree .


var app = new function () {

  this.visit = function () {
    var path = window.location.pathname + window.location.search
    hj('vpv', path)
  }
  this.beforeCache = function () {
    $('.slick-initialized').slick('unslick')
  }
  this.tabLink = function (e) {
    e.preventDefault()
    $(this).tab('show')
  }

  this.init = function () {
    initSelectize()
    if (app[gon.controller_name]) {
      app[gon.controller_name].init()
    }
  }

  // private

  var initSelectize = function () {
    $('@selectize').selectize()
    $('.full_banner-slider').not('.slick-initialized').slick(
      {
        infinite: true,
        slidesToShow: 1,
        prevArrow: $('.prev'),
        nextArrow: $('.next'),
      }
    )
    $('.event-slider').not('.slick-initialized').slick(
      {
        infinite: true,
        dots: true,
        slidesToShow: 1,
        adaptiveHeight: true
      }
    )
    $('.history-slider').not('.slick-initialized').slick(
      {
        infinite: true,
        adaptiveHeight: true,
        dots: true,
        slidesToShow: 1,
      }
    )
    $('.scroller').not('.slick-initialized').slick(
      {
        infinite: true,
        slidesToShow: 3,
        slidesToScroll: 1,
        responsive: [
          {
            breakpoint: 768,
            settings: {
              slidesToShow: 2
            }
          },
          {
            breakpoint: 480,
            settings: {
              slidesToShow: 1
            }
          }
        ]
      }
    )
    $('.menu_dropdown_item')
      .mouseover(function () {
        var id = $(this).attr('data-id')
        $('.menu_item--img-' + id).removeClass('hidden')
      })
      .mouseout(function () {
        var id = $(this).attr('data-id')
        $('.menu_item--img-' + id).addClass('hidden')
      });
  }
}


$(document).on('click', '@tab-link', app.tabLink)
$(document).on('turbolinks:load', app.init)
$(document).on('turbolinks:visit', app.visit)
$(document).on('turbolinks:before-cache', app.beforeCache)