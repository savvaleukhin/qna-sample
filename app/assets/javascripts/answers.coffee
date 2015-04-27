# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

newAnswerSuccess = (e) ->
  $('.new_answer').find("#answer_body").val('')
  $('.new_answer #attachment').find("input").val('')
  $(".new_answer #attachment .fields:not(:first)").remove()

newAnswerError = (e, xhr, status, error) ->
  errors = $.parseJSON(xhr.responseText).errors
  $('.answer-errors').html('')
  $.each errors, (index, value) ->
    $('.answer-errors').append("#{index} #{value}")

editAnswerSuccess = (e) ->
  $(this).hide()
  $('.edit-answer-link').show()

editAnswerError = (e, xhr, status, error) ->
  errors = $.parseJSON(xhr.responseText).errors
  $('.answer-errors').html('')
  $.each errors, (index, value) ->
    $('.answer-errors').append("#{index} #{value}")

subscribeToAnswers = (e) ->
  questionId = $('.answers').data('questionId')
  channel = '/questions/' + questionId + '/answers'
  currentUser = $('.authentication-data').data("userId")

  PrivatePub.subscribe channel, (data, channel) ->
    answer = $.parseJSON(data['answer'])
    method = data['method']

    switch method
      when "POST"
        $('.answers').append(HandlebarsTemplates['answers/create'](answer))
      when "PATCH"
        $('#answer-' + answer.id).find(".answer_body").html(answer.body)
      when "DELTE"
        console.log(method)

    if (currentUser != answer.user_id)
      $('#answer-' + answer.id).find('.author').remove()

$(document).on 'ajax:success', 'form#new_answer', newAnswerSuccess
$(document).on 'ajax:error', 'form#new_answer', newAnswerError

$(document).on 'ajax:success', 'form.edit_answer', editAnswerSuccess
$(document).on 'ajax:error', 'form.edit_answer', editAnswerError

$(document).ready subscribeToAnswers
