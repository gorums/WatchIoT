# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready ->
  if $('#editor').length != 0
    editor = ace.edit('editor')
    editor.setTheme 'ace/theme/clouds_midnight'
    editor.session.setMode 'ace/mode/yaml'
    editor.setOptions enableBasicAutocompletion: true
    staticWordCompleter = getCompletions: (editor, session, pos, prefix, callback) ->
      wordList = tokens
      callback null, wordList.map((word) ->
        {
        caption: word
        value: word
        meta: 'static'
        }
      )
      return

    editor.completers = [ staticWordCompleter ]
    #editor.commands.addCommand
    #  name: 'myCommand'
    #  bindKey:
    #    win: 'Ctrl-S'
    #    mac: 'Command-S'
    #  exec: (editor) ->
    #    alert 'a'
    #    return

    $("#evaluator-form")
    .on("ajax:before", (e, data, status, xhr) ->
      $( "#evaluator" ).val editor.getValue()
      $( "#result-evaluator" ).html '')
    .on("ajax:success", (e, data, status, xhr) ->
      if xhr.responseText.length != 0
        json = JSON.parse(xhr.responseText);
        newJson = []

        for key, value of json
          newJson.push(value);

        alert("You have " + newJson.length + " error(s) in your yaml. Please, fix them!!" )
        editor.getSession().setAnnotations newJson )

    $("#deploy-form")
    .on("ajax:before", (e, data, status, xhr) ->
      $( "#deploy" ).val editor.getValue()
      $( "#result-evaluator" ).html '')

    $("#deploy-btn").click ->
      $("#myModal").modal('hide')

    $("#readme-form")    
    .on("ajax:success", (e, data, status, xhr) ->
      $("#readmeModal").modal('show')
    )