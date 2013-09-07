base_dir = ENV['PWD']

httpsv_auth_basic 'var/www/site1' do
  user 'hoge1'
  path File.join(base_dir, self.name, '.htpasswd')
  name [self.name, self.user].join(':')
  password 'password1'
  filemode 0640
end

httpsv_auth_basic 'var/www/site1' do
  user 'hoge2'
  path File.join(base_dir, self.name, '.htpasswd')
  name [self.name, self.user].join(':')
  password rand.to_s
  filemode 0640
end
