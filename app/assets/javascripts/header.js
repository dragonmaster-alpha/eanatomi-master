app.header = new function () {
  this.showNavigation = function () {
    $('@header-navigation').addClass('header-navigation-open')
    $('body').addClass('overflow-hidden')
  }
  this.hideNavigation = function () {
    $('@header-navigation').removeClass('header-navigation-open')
    $('body').removeClass('overflow-hidden')
  }
  this.changeBgWhite = function (e) {
    $('.navigation-menu__overlay').addClass('active')
    // $('.navigation-menu').addClass('bg-white')
  }
  this.changeBgTransparent = function (e) {
    $('.navigation-menu__overlay').removeClass('active')
    // $('.navigation-menu').removeClass('bg-white')
  }
}

$(document).on('click', '@header-show-navigation', app.header.showNavigation)
$(document).on('click', '@header-hide-navigation', app.header.hideNavigation)
$(document).on('mouseover', '.navigation-head__item.has-submenu', function (e) {
  app.header.changeBgWhite()
  $(this).addClass('opened')
  if ($(e.target).hasClass('level-1')) {
    $('.level-1').removeClass('active');
    $(e.target).addClass('active');
    var id = $(e.target).attr('ref_id')
    $('.navigation_sub_list-cont').hide()
    $('.navigation_sub_list-cont[data-parent|=' + id + ']').show()
  }
})
$(document).on('mouseover', '.has-subcategories', function () {
  var id = $(this).attr('data-id');
  $(this).parents('.navigation-head__item').attr('data-active', id)
  $('.navigation_sub_list-cont[data-parent|=' + id + ']').show()
})

$(document).on('mouseout', '.navigation-head__item.has-submenu', function () {
  app.header.changeBgTransparent()
  $(this).removeClass('opened')
})
var isNowAni = false;
$(window).scroll(function () {
  if (!isNowAni) {
    if ($(this).scrollTop() >= 80) {
      isNowAni = true
      $('@header-d-navigation').addClass('collapsed')
    } else {
      isNowAni = true
      $('@header-d-navigation').removeClass('collapsed')
    }
    setTimeout(function () {
      isNowAni = false;
    }, 300);
  }
})
// // scroll functionality
// window.onscroll = function(e) {
//   scrollFunction()
// };
//
// function scrollFunction() {
//   if (document.documentElement.scrollTop > 50) {
//     $('@header-d-navigation').addClass('collapsed')
//   } else {
//     $('@header-d-navigation').removeClass('collapsed')
//   }
// }