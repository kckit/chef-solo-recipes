include_recipe "apt"
package "git-core"
package "python-software-properties"
package "zsh"
package "emacs23-nox"

include_recipe "nginx::source"


group "admin" do
  gid 113
end

user node["user"]["name"] do
  password node["user"]["password"]
  gid "admin"
  home "/home/#{node["user"]["name"]}"
  supports manage_home: true
  shell "/bin/zsh"
end

template "/home/#{node["user"]["name"]}/.zshrc" do
  source "zshrc.erb"
  owner node["user"]["name"]
  group "admin"
end

service "nginx" do
  action :start
end

package "mysql-server"
package "mysql-client"
package "libmysqlclient-dev"

execute "add-apt-repository ppa:chris-lea/node.js" do
  action :run
end

include_recipe "apt"

package "nodejs"

package "imagemagick"

#opencc
package "cmake"
package "gettext"
remote_file "/home/deployer/opencc-0.3.0.tar.gz" do
  source "http://opencc.googlecode.com/files/opencc-0.3.0.tar.gz"
  action :create_if_missing
end

bash "compile_opencc" do
  cwd "/home/deployer"
  code <<-EOH
    tar zxf opencc-0.3.0.tar.gz
    cd opencc-0.3.0
    mkdir build
    cd build
    cmake -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_BUILD_TYPE=Release -D ENABLE_GETTEXT:BOOL=ON ..
    make & make install
  EOH
end