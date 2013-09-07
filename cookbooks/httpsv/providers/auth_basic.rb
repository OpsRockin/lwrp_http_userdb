require 'webrick'

def whyrun_supported?
  true
end

action :create do
  converge_by("====== Create http_auth user #{@new_resource.user}") do
    htpasswd = WEBrick::HTTPAuth::Htpasswd.new(@new_resource.path)
    htpasswd.set_passwd nil, @new_resource.user, @new_resource.password
    htpasswd.flush
  end
end
