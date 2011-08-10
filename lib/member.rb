class Member
  attr_accessor :filename

  def initialize(filename)
    @filename = filename
    attrs = YAML.load_file('content/members/' + filename + '.yml')
    md5 = Digest::MD5.hexdigest attrs['email']
    attrs['gravatar'] = 'http://www.gravatar.com/avatar/' + md5
    set_instance_variables(attrs)
  end

  def set_instance_variables(hash)
    hash.each do |k,v|
      instance_variable_set("@#{k}",v)
      eigenclass = class<<self; self; end
      eigenclass.class_eval do
        attr_accessor k
      end
    end
  end

  def articles
    # TODO: use this instead of the member_articles helper
  end

  def self.all
    members = []
    dir = 'content/members'
    Dir.new(dir).each do |file|
      name = dir + '/' + file
      if File.file?(name)
        members << Member.new(file.gsub(/.yml$/, ''))
      end
    end
    members
  end
end