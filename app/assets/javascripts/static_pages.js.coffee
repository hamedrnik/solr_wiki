# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
jQuery ->
  $("#term_search").select2({
    width: "element"
    minimumInputLength: 1
    ajax:
      url: "/pages.json"
      dataType: 'json'
      data: (term, page)->
        term_search: term
        type_id: $("#selected_type").val()
        page: page || 1

      results: (terms, page)->
        results: terms

    formatResult: (term) ->
      term.highlight

    escapeMarkup: (text) ->
      text

    formatSelection: (term) ->
      term.title

    id: (object)->
      object.title
  })

  $("#term_search").on("change", (e)->
    $('.form-search').submit()
    )

  $("#type_name").change( ->
    $("#selected_type").val($("#type_name").val())
  ).trigger('change')

  $("#type_name").select2({
    width: "element"
  })
