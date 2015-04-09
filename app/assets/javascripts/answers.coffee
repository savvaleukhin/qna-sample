# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

newAnswerSuccess = (e, data, status, xhr) ->
  #answer = $.parseJSON(xhr.responseText)
  #$('.answers').append(HandlebarsTemplates['answers/create'](answer))

newAnswerError = (e, xhr, status, error) ->
  errors = $.parseJSON(xhr.responseText)
  $('.answer-errors').html('')
  $.each errors, (index, value) ->
    $('.answer-errors').append(value)

editAnswerSuccess = (e, data, status, xhr) ->
  answer = $.parseJSON(xhr.responseText)
  $(this).hide()
  $('#answer-' + answer.id).find("p:first-child").html(answer.body)
  $('.edit-answer-link').show()

editAnswerError = (e, xhr, status, error) ->
  errors = $.parseJSON(xhr.responseText)
  $('.answer-errors').html('')
  $.each errors, (index, value) ->
    $('.answer-errors').append(value)

$(document).on 'ajax:success', 'form#new_answer', newAnswerSuccess
$(document).on 'ajax:error', 'form#new_answer', newAnswerError

$(document).on 'ajax:success', 'form.edit_answer', editAnswerSuccess
$(document).on 'ajax:error', 'form.edit_answer', editAnswerError

$ ->
  questionId = $('.answers').data('questionId');
  channel = '/questions' + questionId + '/answers'
  PrivatePub.subscribe channel, (data, channel) ->
    console.log(data);