# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: thtp://coffeescript.org/

newCommentSuccess = (e) ->
  $(this).hide()
  $('.new_comment').find("#comment_body").val('')
  $('.add-comment-link').show()

newCommentError = (e, xhr, status, error) ->
  errors = $.parseJSON(xhr.responseText).errors
  $('.alert-default').html('')
  $.each errors, (index, value) ->
    $('.alert-default').append("#{index} #{value}").show()

addCommentFunction = (e) ->
  e.preventDefault();
  $(this).hide();
  commentableId = $(this).data('commentableId')
  commentableType = $(this).data('commentableName')
  $('form#add-comment-' + commentableType + '-' + commentableId).show()

editCommentSuccess = (e, data, status, xhr) ->
  $(this).hide()
  $('.edit-comment-link').show()

editCommentError = (e, xhr, status, error) ->
  errors = $.parseJSON(xhr.responseText).errors
  $('.alert-default').html('')
  $.each errors, (index, value) ->
    $('.alert-default').append("#{index} #{value}").show()

editCommentFunction = (e) ->
  e.preventDefault()
  $(this).hide()
  commentId = $(this).data('commentId')
  $('form#edit-comment-' + commentId).show()

subscribeToComments = (e) ->
  questionId = $('.answers').data('questionId')
  channel = '/questions/' + questionId + '/comments'

  PrivatePub.subscribe channel, (data, channel) ->
    if (typeof data != 'undefined') and (data['comment'])
      comment = $.parseJSON(data['comment'])
      method = data['method']
      commentableId = comment.commentable_id
      commentableType = comment.commentable_type.toLowerCase()
      selector = '#comments-' + commentableType + '-' + commentableId

      switch method
        when "POST"
          $(selector).append(HandlebarsTemplates['comments/create'](comment))
        when "PATCH"
          $('#comment-' + comment.id).find('.comment_body').html(comment.body)
        when "DELETE"
          $('#comment-' + comment.id).remove()

$(document).on 'ajax:success', 'form.new_comment', newCommentSuccess
$(document).on 'ajax:error', 'form.new_comment', newCommentError
$(document).on 'click', '.add-comment-link', addCommentFunction

$(document).on 'ajax:success', 'form.edit_comment', editCommentSuccess
$(document).on 'ajax:error', 'form.edit_comment', editCommentError
$(document).on 'click', '.comments .edit-comment-link', editCommentFunction

$(document).ready subscribeToComments
