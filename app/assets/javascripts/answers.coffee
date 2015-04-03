# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->

  $('form#new_answer').bind 'ajax:success', (e, data, status, xhr) ->
    answer = $.parseJSON(xhr.responseText)
    $('.answers').append(
      "<div id='answer-#{answer.id}' class='answer'><p>#{answer.body}</p></div>")
    $("#answer-#{answer.id}").append("
      <div class='attachments'>
        <table>
          <tbody>
            <tr id='attachment-#{answer.attachments[0].id}'><td><a href='#{answer.attachments[0].url}'>#{answer.attachments[0].filename}</a></td></tr>
          </tbody>
        </table>
      </div>
    ")
  .bind 'ajax:error', (e, xhr, status, error) ->
    errors = $.parseJSON(xhr.responseText)
    $('.answer-errors').html('')
    $.each errors, (index, value) ->
      $('.answer-errors').append(value)