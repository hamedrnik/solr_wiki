# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

#jQuery ->
#  $("#page_type_names").select2({
#    width: "element"
#    multiple: true
#    minimumInputLength: 1
#    dropdownCssClass: "bigdrop"
#    ajax:
#      url: "/types.json"
#      dataType: 'json'
#      data: (term, page)->
#          type_search: term
#          page: 1

#      results: (types, page)->
#        results: types

#    id: (types)->
#      types.name

#    formatResult: (types) ->
#      types.name

#    formatSelection: (types) ->
#      types.name

#    initSelection: (element, callback)->
#      elementText = $(element).data('types')
#      callback(elementText)

#    createSearchChoice: (term, data) ->
#      {id: term, name: term}
#    })
