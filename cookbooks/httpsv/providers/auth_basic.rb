require 'webrick'

def whyrun_supported?
  true
end

action :create do
  if @current_resource.crypted_passwd
    Chef::Log.warn "====== Found http_auth user #{@new_resource.user}"
    salt = @current_resource.crypted_passwd[0..1]
    if @current_resource.crypted_passwd == @new_resource.password.crypt(salt)
      Chef::Log.warn "====== http_auth user #{@new_resource.user} was not modified. (up to date)"
    else
      converge_by("====== Update http_auth user #{@new_resource.user}") do
        Chef::Log.warn "====== Update http_auth user #{@new_resource.user}"
        update_user!
      end
    end
  else
    converge_by("====== Create http_auth user #{@new_resource.user}") do
      Chef::Log.warn "====== Create http_auth user #{@new_resource.user}"
      backup!
      update_user!
    end
  end
end

action :delete do
  unless @current_resource.crypted_passwd
    Chef::Log.warn "====== http_auth user #{@new_resource.user} was not found. Nothing to do. (up to date)"
  else
    converge_by("====== Delete http_auth user #{@new_resource.user}") do
      Chef::Log.warn "====== Delete http_auth user #{@new_resource.user}"
      delete_user!
    end
  end
end

def update_user!
  htpasswd = WEBrick::HTTPAuth::Htpasswd.new(@new_resource.path)
  htpasswd.set_passwd nil, @new_resource.user, @new_resource.password
  htpasswd.flush
  fix_permission!
end

def delete_user!
  htpasswd = WEBrick::HTTPAuth::Htpasswd.new(@new_resource.path)
  htpasswd.delete_passwd nil, @new_resource.user
  htpasswd.flush
  fix_permission!
end

def fix_permission!
  FileUtils.chmod(@new_resource.filemode.to_i, @new_resource.path)
end

def load_current_resource
  @current_resource = Chef::Resource::HttpsvAuthBasic.new(@new_resource.name)
  htpasswd = WEBrick::HTTPAuth::Htpasswd.new(@new_resource.path)
  @current_resource.crypted_passwd = htpasswd.get_passwd nil, @new_resource.user, true
end
