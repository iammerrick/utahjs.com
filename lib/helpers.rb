def pages
  @items.select { |item| item.page? }.sort_by{ |item| item[:order] }
end

def articles
  @items.select { |item| item.article? }.sort_by{ |item| item[:date] }
end

def codeblock(path)
  language = path.match(/\.([^\.]+)$/)[1]
  code     = "<pre><code data-language='#{language}'>"
  file     = File.new('content/articles/' + path, 'r')
  while (line = file.gets)
    code += "#{line}"
  end
  code += "</code></pre>"
  file.close

  code
end

def gravatar_for(email)
  md5 = Digest::MD5.hexdigest email
  'http://www.gravatar.com/avatar/' + md5
end

# need to move this to an instance method of Member
def member_articles(member)
  articles.select do |item|
    item[:author] == member.filename
  end
end
