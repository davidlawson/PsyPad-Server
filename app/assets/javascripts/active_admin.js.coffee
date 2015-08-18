#= require active_admin/base
#= require jquery

#= require jquery.minicolors.js

f2hex = (f) ->
  hex = Number(parseInt(f, 10)).toString(16)
  hex = '0' + hex if hex.length == 1
  hex

jQuery ($) ->
  $('.colorpicker').each( ->
    input = $(this)
    input.minicolors(
      opacity: true
    )
  )
  return

#= require underscore
#= require json2
#= require judge