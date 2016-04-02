# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready ->
  $('#menu-toggle').click (e) ->
    e.preventDefault()
    $('#wrapper').toggleClass 'toggled'
    return

  $(window).resize ->
    $('#wrapper').toggleClass 'toggled'
    $('#wrapper').toggleClass 'toggled'
    return

  $('.img-circle').each (index, element) ->
    email = $(element).data('email')
    $(element).attr 'src', Gravtastic(email, default: 'identicon')
    return

  $('#tree').treeview
    data: getTree()
    backColor: '#225079'
    color: '#fff'
    enableLinks: true
    onhoverColor: '#225079'
    selectedBackColor: '#225079'
    emptyIcon: 'fa fa-laptop'
    showBorder: false
