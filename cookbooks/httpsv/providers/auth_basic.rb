require 'webrick'

def whyrun_supported?
  true
end

action :create do
  converge_by("====== Create http_auth user #{@new_resource.user}") do
    htpasswd = WEBrick::HTTPAuth::Htpasswd.new(@new_resource.name)
    htpasswd.set_passwd nil, @new_resource.user, @new_resource.password
    htpasswd.flush

    file @new_resource.name do
      owner 'guest'
      mode  0644
    end
  end
end
