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
          page: 1

      results: (terms, page)->
        results: terms

    formatResult: (terms) ->
      terms.title

    formatSelection: (terms) ->
      terms.title
  })

  $("#term_search").on("change", (e)->
    $('.form-search').submit()
    )
