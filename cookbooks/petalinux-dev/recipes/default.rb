#
# Cookbook Name:: petalinux-dev
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

packages = %w[
  vim
  vim-gnome
  emacs
  git
  tofrodos
  iproute
  gawk
  gcc
  git-core
  make
  net-tools
  ncurses-dev
  libncurses5-dev
  tftpd
  zlib1g-dev
  flex
  bison
  lib32z1
  lib32ncurses5
  lib32bz2-1.0
  lib32stdc++6
  libselinux1
]

# Install prerequisite packages
packages.each do |pkg|
  package pkg
end

# Install tftpd config file
template "/etc/xinetd.d/tftp" do
  source "tftp"
  mode "0777"
  owner "root"
  group "root"
end

directory "/tftpboot" do
  action :create
end

service "xinetd" do
  action :stop
  action :start
end

# Download petalinux installer
petalinux_installer = "petalinux-v2014.4-final-installer.run"
petalinux_installer_cache = "#{Chef::Config[:file_cache_path]}/" + petalinux_installer
remote_file petalinux_installer_cache do
  source "file:///var/" + petalinux_installer
  mode "0755"
  not_if { ::File.exists?(petalinux_installer_cache) }
end

# Create location to put petalinux
directory "/opt/xilinx" do
  action :create
end

ruby_block "install_" + petalinux_installer do
  block do
    software_license_agreement = system("cd /opt/xilinx && yes | " + petalinux_installer_cache )
  end
  not_if { ::File.exists?("/opt/xilinx/petalinux-v2014.4-final/settings.sh") }
end
