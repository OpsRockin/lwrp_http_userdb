base_dir = ENV['PWD']

httpsv_auth_basic 'var/www/site1' do
  action :delete
  user 'hoge1'
  path File.join(base_dir, self.name, '.htpasswd')
  name [self.name, self.user].join(':')
end

httpsv_auth_basic 'var/www/site1' do
  action :delete
  user 'hoge2'
  path File.join(base_dir, self.name, '.htpasswd')
  name [self.name, self.user].join(':')
end
