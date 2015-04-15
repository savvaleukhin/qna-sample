# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

newCommentSuccess = (e, data, status, xhr) ->
  comment = $.parseJSON(xhr.responseText)
  commentableId = comment.commentable_id
  $('#comments-'+ commentableId).find('tbody').append(HandlebarsTemplates['comments/create'](comment));

$(document).on 'ajax:success', 'form#new_comment', newCommentSuccess
