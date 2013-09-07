base_dir = ENV['PWD']

httpsv_auth_basic File.join(base_dir, 'var/www/site1/.htpasswd') do
  user 'hoge1'
  path self.name.to_s
  name [self.path, self.user].join(':')
  password 'password'
end

httpsv_auth_basic File.join(base_dir, 'var/www/site1/.htpasswd') do
  user 'hoge2'
  path self.name.to_s
  name [self.path, self.user].join(':')
  password 'password'
end
