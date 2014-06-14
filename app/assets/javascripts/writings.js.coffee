# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

#= require application
#= require hmd/hmd
#= require hmd/hmd.ricaleinline

privlock.onReadyDocument = ->
  $("#open-preview-modal-button").click (event) ->
    height = $(window).height() * 0.7
    height = 400 if height < 400
    $("#preview-modal .modal-body").css "max-height", height
    $("#preview-modal .modal-body").html hmd.decode($("#writing_content").val())


$(document).ready(privlock.onReadyDocument)
$(document).on('page:load', privlock.onReadyDocument)
