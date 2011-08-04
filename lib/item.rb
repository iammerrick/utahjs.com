require 'yaml'
require 'digest/md5'
require 'date'

class Nanoc3::Item

  def kind
    kinds = {
      'pages' => 'page',
      'articles' => 'article'
    }
    split = self.identifier.split('/')
    kinds[split[1]] || 'none'
  end

  def page?
    self.readable? && self.kind == 'page'
  end

  def article?
    self.readable? && self.kind == 'article'
  end

  def readable?
    readable = %w[html md haml txt]
    readable.include? self.attributes[:extension]
  end

  def author
    @author_meta ||= get_author
  end

  def get_author
    @author_meta = YAML.load_file('content/members/' + self[:author] + '.yml')
    md5 = Digest::MD5.hexdigest @author_meta['email']
    @author_meta['gravatar'] = 'http://www.gravatar.com/avatar/' + md5
    @author_meta
  end

  def year
    date = Date.parse(self.readable? ? self.attributes[:date] : self.parent.attributes[:date])
    date.year
  end
end