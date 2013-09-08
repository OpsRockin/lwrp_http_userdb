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

action :discard do
  if @current_resource.db_exists
    converge_by("====== Discard http_auth userdb #{@new_resource.path}") do
      backup!
      ::File.unlink(@new_resource.path)
    end
  else
    Chef::Log.warn "====== http_auth user database #{@new_resource.path} was not found. Nothing to do. (up to date)"
  end
end

def update_user!
  backup!
  htpasswd = WEBrick::HTTPAuth::Htpasswd.new(@new_resource.path)
  htpasswd.set_passwd nil, @new_resource.user, @new_resource.password
  htpasswd.flush
  fix_permission!
end

def delete_user!
  backup!
  htpasswd = WEBrick::HTTPAuth::Htpasswd.new(@new_resource.path)
  htpasswd.delete_passwd nil, @new_resource.user
  htpasswd.flush
  fix_permission!
end

def fix_permission!
  FileUtils.chmod(@new_resource.filemode.to_i, @new_resource.path)
end

def backup!
  htpasswd_file = Chef::Resource::File.new(@new_resource.path)
  htpasswd_file.instance_variable_set(:@backup, 30)
  backup = Chef::Util::Backup.new(htpasswd_file)
  backup.send(:backup_filename)
  backup.instance_variable_set(:@backup_filename,backup.instance_variable_get(:@backup_filename).gsub(/[\d]+$/,Time.now.strftime("%Y%m%d%H%M%S.%6N")))
  backup.backup!
end

def load_current_resource
  @current_resource = Chef::Resource::HttpsvAuthBasic.new(@new_resource.name)
  unless ::File.exists?(@new_resource.path)
    @current_resource.db_exists = false
    @current_resource.crypted_passwd = nil
    return
  end
  htpasswd = WEBrick::HTTPAuth::Htpasswd.new(@new_resource.path)
  @current_resource.crypted_passwd = htpasswd.get_passwd nil, @new_resource.user, true
  @current_resource.db_exists = true
end
