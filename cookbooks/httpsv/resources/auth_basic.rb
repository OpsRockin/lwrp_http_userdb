actions :create, :delete, :discard
default_action :create

attribute :user, :kind_of => String, :required => true
attribute :password, :kind_of => String
attribute :path, :kind_of => String, :required => true
attribute :filemode, :default => 0600

attr_accessor :crypted_passwd
attr_accessor :db_exists

