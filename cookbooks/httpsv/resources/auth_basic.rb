actions :create
default_action :create

attribute :user, :kind_of => String, :required => true
attribute :password, :kind_of => String
attribute :path, :kind_of => String, :required => true

