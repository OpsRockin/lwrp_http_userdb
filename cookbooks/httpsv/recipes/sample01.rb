base_dir = ENV['PWD']

httpsv_auth_basic File.join(base_dir, 'var/www/site1/.htpasswd') do
  user 'hoge'
  password 'password'
end
