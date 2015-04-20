# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

editQuestionFunction = (e) ->
  e.preventDefault();
  $(this).hide();
  $('#edit-question').show();

editAnswerFunction = (e) ->
  e.preventDefault();
  $(this).hide();
  answer_id = $(this).data('answerId');
  $('form#edit-answer-' + answer_id).show();

subscribeToQuestions = (e) ->
  PrivatePub.subscribe "/questions", (data, channel) ->
    question = $.parseJSON(data['question'])
    $('.questions').append(HandlebarsTemplates['questions/create'](question))

$(document).on 'click', '.answers .edit-answer-link', editAnswerFunction
$(document).on 'click', '.question .edit-question-link', editQuestionFunction
$(document).ready subscribeToQuestions
