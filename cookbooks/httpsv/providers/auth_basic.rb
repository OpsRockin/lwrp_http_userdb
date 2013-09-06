action :create do
  ::FileUtils.touch(@new_resource.name)
  @new_resource.updated_by_last_action(true)
end
