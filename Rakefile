task :default => ['test']

task :test do
  Dir.glob('test/*').each do |testfile|
    ruby testfile
  end
end
