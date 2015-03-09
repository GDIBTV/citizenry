APPDIR = "/vagrant"
USER = "vagrant"
TEMPDIR = "/tmp"

# Install a modern Ruby version
execute "Create Temp Dir" do
  command "mkdir -p #{TEMPDIR}"
end

execute "Get ruby source"do
  cwd TEMPDIR
  command "wget http://cache.ruby-lang.org/pub/ruby/2.1/ruby-2.1.2.tar.gz"
end

execute "Extract Ruby Source" do
  cwd TEMPDIR
  command "tar -xvzf ruby-2.1.2.tar.gz && rm ruby-2.1.2.tar.gz"
end

execute "Configure ruby for build" do
  cwd "#{TEMPDIR}/ruby-2.1.2"
  command "./configure --prefix=/opt/vagrant_ruby"
end

execute "Make and Install Ruby" do
  cwd "#{TEMPDIR}/ruby-2.1.2"
  command "make && sudo make install"
end

# Add ruby and gems to PATH
file "/etc/profile.d/rubygems.sh" do
  content "export PATH=/opt/vagrant_ruby/bin:`/opt/vagrant_ruby/bin/gem env path`:$PATH"
end

# Install gems
gem_package "bundler"

# Copy in sample YML files, if needed:
for name in %w[settings database]
  source = "#{APPDIR}/config/#{name}-sample.yml"
  target = "#{APPDIR}/config/#{name}.yml"

  execute "cp -a #{source} #{target}" do
    not_if "test -e #{target}"
  end
end

# Fix permissions on homedir
execute "chown -R #{USER}:#{USER} ~#{USER}"

# Install bundles
execute "install-bundle" do
  cwd APPDIR
  command "su vagrant -l -c 'bundle check || bundle --local || bundle'"
end

# Setup database
execute "setup-db" do
  cwd APPDIR
  command "su vagrant -l -c 'bundle exec rake db:create:all db:migrate db:test:prepare'"
end
