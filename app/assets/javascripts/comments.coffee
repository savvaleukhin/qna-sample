# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

newCommentSuccess = (e) ->
  $(this).hide()
  $('.new_comment').find("#comment_body").val('')
  $('.add-comment-link').show()

newCommentError = (e, xhr, status, error) ->
  errors = $.parseJSON(xhr.responseText)
  $('.alert').html('')
  $.each errors, (index, value) ->
    $('.alert').append(value)

addCommentFunction = (e) ->
  e.preventDefault();
  $(this).hide();
  commentableId = $(this).data('commentableId')
  commentableType = $(this).data('commentableName')
  $('form#add-comment-' + commentableType + '-' + commentableId).show()

subscribeToComments = (e) ->
  questionId = $('.answers').data('questionId')
  channel = '/questions/' + questionId + '/comments'

  PrivatePub.subscribe channel, (data, channel) ->
    comment = $.parseJSON(data['comment'])
    commentableId = comment.commentable_id
    commentableType = comment.commentable_type.toLowerCase()
    selector = '#comments-' + commentableType + '-' + commentableId
    $(selector).find('tbody').append(HandlebarsTemplates['comments/create'](comment))

$(document).on 'ajax:success', 'form.new_comment', newCommentSuccess
$(document).on 'ajax:error', 'form.new_comment', newCommentError
$(document).on 'click', '.add-comment-link', addCommentFunction
$(document).ready subscribeToComments
