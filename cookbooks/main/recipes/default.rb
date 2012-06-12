package "git-core"
package "python-software-properties"
package "zsh"

include_recipe "nginx::source"


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
end

service "nginx" do
  action :start
end

package "mysql-server"
package "mysql-client"
package "libmysqlclient-dev"

execute "add-apt-repository ppa:chris-lea/node.js" do
  action :run
endend

include_recipe "apt"

package "nodejs"