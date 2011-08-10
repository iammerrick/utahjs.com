!function (){
  var languages = {}

  var hilite = this.hilite = function (node, language, lines) {
    if (!language)
      language = node.getAttribute('data-language')

    var text = hilite.convert(node.childNodes[0].nodeValue, language)
      , parent = node.parentNode

    if (lines || parent.tagName.toLowerCase() === 'pre') {
      lines = makeLines(text)
      parent.insertBefore(lines, node)
      parent.className = parent.className + ' lines'
      text += '<br style="clear:both">'
    }

    node.innerHTML = text
  }

  hilite.define = function (language, definition) {
    languages[language] = definition
  }

  hilite.convert = function (text, language) {
    var syntaxes = languages[language]
      , map = {}
    console.log(language)
    function applySyntax (i) {
      // applies a syntax to the string and mutates the string to a mess
      // of ids so that they won't be matched with subsequent rules
      var match  = syntaxes[i].match
        , name   = syntaxes[i].name
        , single = typeof name === 'string'

      return text.replace(match, function (){
        var matches  = [].slice.call(arguments, 0)
          , full     = matches.shift()
          , id

        if (single){
          id = guid()
          map[id] = [full, name]
          return id
        }

        // map the matched syntax and change the text to ids
        for (var i = 0, l = name.length; i < l; i++){
          id = guid()
          map[id] = [matches[i], name[i]]
          full = full.replace(matches[i], id)
        }

        // full is now a mess of ids
        return full
      })
    }

    // apply each syntax rule to the text, converting matches to IDs
    for (var i = 0, l = syntaxes.length; i < l; i++)
      text = applySyntax(i)

    // switch IDs back to normal stuff
    for (i in map)
      if (map.hasOwnProperty(i))
        text = text.replace(
          i,
          '<span class="'+map[i][1]+'">'+escape(map[i][0] || '')+'</span>'
        )

    return text
  }

  function escape (str) {
      return str.replace(/</g, '&lt;').replace(/>/g, '&gt;')
  }

  function guid () {
     return ("\u00ab" + slug() + slug() + slug() + slug() + "\u00bb")
  }

  function makeLines (text) {
    var lines = text.split("\n")
      , list = document.createElement('ol')
      , html = ''

    for (var i = 1, l = lines.length; i < l; i++)
      html += '<li></li>'

    list.innerHTML = html

    return list
  }

  function slug() {
     return (((1+Math.random())*0x10000)|0).toString(16).substring(1)
  }

  // NodeJS
  if (typeof module !== 'undefined')
    module && module.exports && (module.exports = hilite)
}()
