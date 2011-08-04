def pages
  @items.select { |item| item.page? }.sort_by{ |item| item[:order] }
end

def articles
  @items.select { |item| item.article? }.sort_by{ |item| item[:date] }.reverse
end

def codeblock(path)
  code     = ''
  language = path.match(/\.([^\.]+)$/)[1]

  file     = File.new('content/articles/' + path, 'r')
  while (line = file.gets)
    code += "\t#{line}"
  end
  file.close

  code
end