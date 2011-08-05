def pages
  @items.select { |item| item.page? }.sort_by{ |item| item[:order] }
end

def articles
  @items.select { |item| item.article? }.sort_by{ |item| item[:date] }
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

def members
  members = []
  dir = 'content/members'
  Dir.new(dir).each do |file|
    name = dir + '/' + file
    if File.file?(name)
      member = YAML.load_file(name)
      member['filename'] = file
      member['gravatar'] = gravatar_for member['email']
      members << member
    end
  end
  members
end

def gravatar_for(email)
  md5 = Digest::MD5.hexdigest email
  'http://www.gravatar.com/avatar/' + md5
end

def member_articles(member)
  articles.select do |item|
    puts item[:author]
    puts member['filename']
    puts
    item[:author] + '.yml' == member['filename']
  end
end
