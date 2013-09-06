require 'webrick'

action :create do
  Chef::Log.warn "====== Create http_auth user #{@new_resource.user}"

  htpasswd = WEBrick::HTTPAuth::Htpasswd.new(@new_resource.name)
  htpasswd.set_passwd nil, @new_resource.user, @new_resource.password
  htpasswd.flush
  @new_resource.updated_by_last_action(true)
end
