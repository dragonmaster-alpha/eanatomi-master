app.marketNotice = new function () {

  this.close = function () {
    $('@market-notice').remove()

    var expire = new Date()
    expire.setDate(expire.getDate() + 7)
    expire = expire.toUTCString()

    document.cookie = 'hide_market_notice=yes; path=/; expires=' + expire
  }

}

$(document).on('click', '@market-notice-close', app.marketNotice.close)
