#
# Cookbook Name:: kafka-config
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

template "/opt/kafka/bin/kafka-server-start.sh" do
  source "kafka-server-start.sh.erb"
  mode  "0755"
  variables({
     :heap_opts => JvmOptsHelper.gen_heap_opts(node[:memory][:total])
  })
  notifies :restart, "service[kafka]"
end

service "kafka" do
  supports :restart => true, :status => true, :reload => true
  action [:enable, :start]
end
