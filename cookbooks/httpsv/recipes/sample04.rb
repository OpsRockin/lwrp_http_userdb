# coding: utf-8
base_dir = ENV['PWD']
file_path = File.join(base_dir, 'var/www/site1/.htpasswd')

def mode_to_log(file_path)
  Chef::Log.warn "========= new resource mode is " + resources("file[#{file_path}]").mode
end

## >> レシピ部分
file file_path do ; mode '0660' ; end ; mode_to_log(file_path)
file file_path do ; mode '0666' ; end ; mode_to_log(file_path)
file file_path do ; mode '0644' ; end ; mode_to_log(file_path)
file file_path do ; mode '0640' ; end ; mode_to_log(file_path)
## << レシピ部分

require 'chef/handler'

class Chef::Handler::LogReport < ::Chef::Handler
  def report
    Chef::Log.warn '======= Update Resources are following...'
    data[:updated_resources].each.with_index do |r,idx|
      Chef::Log.warn [idx, r.to_s].join(':')
    end
  end
end

Chef::Config[:report_handlers] << Chef::Handler::LogReport.new
