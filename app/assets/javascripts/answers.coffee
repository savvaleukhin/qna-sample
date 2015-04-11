# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

newAnswerSuccess = (e) ->
  #answer = $.parseJSON(xhr.responseText)
  #$('.answers').append(HandlebarsTemplates['answers/create'](answer))
  $('.new_answer').find("#answer_body").val('')
  $('.new_answer #attachment').find("input").val('')
  $(".new_answer #attachment .fields:not(:first)").remove()

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
  questionId = $('.answers').data('questionId')
  channel = '/questions/' + questionId + '/answers'
  author = $('.authentication-data').data("userId")

  PrivatePub.subscribe channel, (data, channel) ->
    answer = $.parseJSON(data['answer'])
    $('.answers').append(HandlebarsTemplates['answers/create'](answer));
    if (author != answer.user_id)
      $('.author').remove()
