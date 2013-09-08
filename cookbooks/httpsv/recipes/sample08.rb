base_dir = ENV['PWD']

httpsv_auth_basic 'var/www/site1' do
  action :discard
  user 'delete_dummy'
  path File.join(base_dir, self.name, '.htpasswd')
  name [self.name, self.user].join(':')
end

