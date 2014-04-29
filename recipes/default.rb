#
# Cookbook Name:: kafka-config
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

case node[:platform]
  when "redhat","centos","fedora","scientific", "amazon"
  remote_file "#{Chef::Config[:file_cache_path]}/kafka.rpm" do 
    not_if "rpm -qa | grep -qx 'kafka'"
    source node["kafka"]["rpm_url"]
    notifies :install, "rpm_package[kafka]", :immediately
  end

  rpm_package "kafka" do
    source "#{Chef::Config[:file_cache_path]}/kafka.rpm" 
    only_if {::File.exists?("#{Chef::Config[:file_cache_path]}/kafka.rpm")} 
    action :nothing
  end

#  package "kafka" do
#    action :install
#    source node["kafka"]["rpm_url"]
#    provider Chef::Provider::Package::Rpm
#    not_if "rpm -qa | grep -qx 'kafka'"
#  end
end

template "/opt/kafka/bin/kafka-server-start.sh" do
  source "kafka-server-start.sh.erb"
  mode  "0755"
  variables({
     :heap_opts => JvmOptsHelper.gen_heap_opts(node[:memory][:total])
  })
end

template "/etc/init.d/kafka-mirror" do
  source "kafka-mirror.erb"
  mode  "0755"
end

service "kafka" do
  supports :restart => true, :status => true, :reload => true
  action [:enable]
end

service "kafka-mirror" do
  supports :restart => true, :status => true, :reload => true
  action :nothing
end

directory "/var/log/kafka" do
  owner "kafka"
  group "kafka"
  action :create
end
