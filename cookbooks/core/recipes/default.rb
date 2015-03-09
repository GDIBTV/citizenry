# Update package list, but only if stale
execute "update-apt" do
  timestamp = "/root/.apt-get-updated"
  command "apt-get update && touch #{timestamp}"
  only_if do
    ! File.exist?(timestamp) || (File.stat(timestamp).mtime + 60*60) < Time.now
  end
end

# Install packages
for name in %w[nfs-common git build-essential libsqlite3-dev mysql-server libmysqlclient-dev libxml2 libxml2-dev libxslt1.1 libxslt1-dev sphinxsearch imagemagick]
  package name
end
