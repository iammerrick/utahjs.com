# the COPY constant
COPY = {}
Dir.foreach 'content/copy' do |file|
  path = 'content/copy/' + file
  COPY[file.gsub /.html/, ''] = File.new(path).read if File.file? path
end
