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
      wordList = [
        'foo'
        'bar'
        'baz'
      ]
      callback null, wordList.map((word) ->
        {
        caption: word
        value: word
        meta: 'static'
        }
      )
      return

    editor.completers = [ staticWordCompleter ]
    editor.commands.addCommand
      name: 'myCommand'
      bindKey:
        win: 'Ctrl-S'
        mac: 'Command-S'
      exec: (editor) ->
        alert 'a'
        return