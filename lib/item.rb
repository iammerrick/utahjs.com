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
    self.kind == 'page'
  end

  def article?
    self.kind == 'article'
  end

  def author
    if !@author_meta
      @author_meta = YAML.load_file('content/authors/' + self[:author] + '.yml')
      md5 = Digest::MD5.hexdigest @author_meta['email']
      @author_meta['gravatar'] = 'http://www.gravatar.com/avatar/' + md5
    end
    
    @author_meta
  end

  def year
    date = Date.parse self.attributes[:date]
    date.year
  end
end