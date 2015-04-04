# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->

  $('form#new_answer').bind 'ajax:success', (e, data, status, xhr) ->
    answer = $.parseJSON(xhr.responseText)
    $('.answers').append(HandlebarsTemplates['answers/create'](answer))
  .bind 'ajax:error', (e, xhr, status, error) ->
    errors = $.parseJSON(xhr.responseText)
    $('.answer-errors').html('')
    $.each errors, (index, value) ->
      $('.answer-errors').append(value)

  $('form.edit_answer').bind 'ajax:success', (e, data, status, xhr) ->
    answer = $.parseJSON(xhr.responseText)
    $(this).hide()
    $('#answer-' + answer.id).find("p:first-child").html(answer.body)
    $('.edit-answer-link').show()
  .bind 'ajax:error', (e, xhr, status, error) ->
    errors = $.parseJSON(xhr.responseText)
    $('.answer-errors').html('')
    $.each errors, (index, value) ->
      $('.answer-errors').append(value)