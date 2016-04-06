(function() {
  $(document).ready(function() {
    var editor, staticWordCompleter;
    if ($('#editor').length !== 0) {
      editor = ace.edit('editor');
      editor.setTheme('ace/theme/clouds_midnight');
      editor.session.setMode('ace/mode/yaml');
      editor.setOptions({
        enableBasicAutocompletion: true
      });
      staticWordCompleter = {
        getCompletions: function(editor, session, pos, prefix, callback) {
          var wordList;
          wordList = ['foo', 'bar', 'baz'];
          callback(null, wordList.map(function(word) {
            return {
              caption: word,
              value: word,
              meta: 'static'
            };
          }));
        }
      };
      editor.completers = [staticWordCompleter];
      $("#evaluator-form").on("ajax:before", function(e, data, status, xhr) {
        $("#evaluator").val(editor.getValue());
        return $("#result-evaluator").html('');
      }).on("ajax:success", function(e, data, status, xhr) {
        var json, key, newJson, value;
        if (xhr.responseText.length !== 0) {
          json = JSON.parse(xhr.responseText);
          newJson = [];
          for (key in json) {
            value = json[key];
            newJson.push(value);
          }
          alert("You have " + newJson.length + " error(s) in your yaml. Please, fix them!!");
          return editor.getSession().setAnnotations(newJson);
        }
      });
      $("#deploy-form").on("ajax:before", function(e, data, status, xhr) {
        $("#deploy").val(editor.getValue());
        return $("#result-evaluator").html('');
      });
      return $("#deploy-btn").click(function() {
        return $('#myModal').modal('hide');
      });
    }
  });

}).call(this);
