# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

#= require application

privlock.onReadyDocument = ->
  $("#ccl_select").change (event) ->
    privlock.displayOne('.help-block-license', '#ccl_description_'+ $(this).val())

$(document).ready(privlock.onReadyDocument)
$(document).on('page:load', privlock.onReadyDocument)
