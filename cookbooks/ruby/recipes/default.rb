APP_DIR = "/vagrant"
TEMP_DIR = "/tmp"

# Install a modern Ruby version
execute "Create Temp Dir" do
  command "mkdir -p #{TEMP_DIR}"
end

execute "Get ruby source"do
  cwd TEMP_DIR
  command "wget http://cache.ruby-lang.org/pub/ruby/2.1/ruby-2.1.2.tar.gz"
end

execute "Extract Ruby Source" do
  cwd TEMP_DIR
  command "tar -xvzf ruby-2.1.2.tar.gz && rm ruby-2.1.2.tar.gz"
end

execute "Configure ruby for build" do
  cwd "#{TEMP_DIR}/ruby-2.1.2"
  command "./configure --prefix=/opt/vagrant_ruby"
end

execute "Make and Install Ruby" do
  cwd "#{TEMP_DIR}/ruby-2.1.2"
  command "make && sudo make install"
end

# Add ruby and gems to PATH
file "/etc/profile.d/rubygems.sh" do
  content "export PATH=/opt/vagrant_ruby/bin:`/opt/vagrant_ruby/bin/gem env path`:$PATH"
end

# Install gems
gem_package "bundler"

# Install bundles
# Note: Old provisioning code was taking care to execute this as the vagrant user, not sure if this is necessary
execute "install-bundle" do
  cwd APP_DIR
  command "bundle check || bundle --local || bundle"
end
