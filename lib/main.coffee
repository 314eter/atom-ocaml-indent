{CompositeDisposable, BufferedProcess} = require 'atom'

module.exports =
  subscriptions: null

  activate: (state) ->
    @subscriptions = new CompositeDisposable

    target = 'atom-text-editor[data-grammar="source ocaml"]'
    @subscriptions.add atom.commands.add target,
      'ocaml-indent:selection': => @indentSelection(),
      'ocaml-indent:file': => @indentFile()

    @subscriptions.add atom.workspace.observeTextEditors (editor) =>
      didInsertTextDisposable = null
      @subscriptions.add editor.observeGrammar (grammar) =>
        if didInsertTextDisposable?
          @subscriptions.remove didInsertTextDisposable
          didInsertTextDisposable.dispose()
          didInsertTextDisposable = null
        return unless grammar.scopeName == 'source.ocaml'
        didInsertTextDisposable = editor.onDidInsertText ({text, range}) =>
          return unless text == '\n'
          @indentNewline editor, range
        @subscriptions.add didInsertTextDisposable

  indentRange: (editor, {start, end}, text) ->
    @ocpIndent ['--numeric', '--lines', "#{start.row + 1}-#{end.row + 1}"], text
    .then (output) =>
      indents = (parseInt s for s in output.trim().split '\n')
      @doIndents editor, start.row, indents

  indentNewline: (editor, range) ->
    text = editor.getTextInBufferRange [[0, 0], range.end]
    line = editor.lineTextForBufferRow range.end.row
    text += if line.trim().length then line else "(**)"
    @indentRange editor, range, text

  indentSelection: ->
    return unless editor = atom.workspace.getActiveTextEditor()
    for range in editor.getSelectedBufferRanges()
      @indentRange editor, range, editor.getText()

  indentFile: ->
    return unless editor = atom.workspace.getActiveTextEditor()
    @indentRange editor, editor.getBuffer().getRange(), editor.getText()

  ocpIndent: (args, text) ->
    new Promise (resolve, reject) ->
      command = atom.config.get 'ocaml-indent.ocp-indentPath'
      stdout = (output) -> resolve output
      exit = (code) -> reject code if code
      bp = new BufferedProcess {command, args, stdout, exit}
      bp.process.stdin.write text
      bp.process.stdin.end()

  doIndents: (editor, startRow, indents) ->
    for indent, i in indents
      row = startRow + i
      col = editor.lineTextForBufferRow(row)?.match(/^\s*/)[0].length ? 0
      indentString =  " ".repeat indent
      editor.setTextInBufferRange([[row, 0], [row, col]], indentString)

  deactivate: ->
    @subscriptions.dispose()
