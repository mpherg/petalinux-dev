#!/usr/bin/env bash

which chef-solo || {
wget https://opscode-omnibus-packages.s3.amazonaws.com/ubuntu/13.04/x86_64/chef_12.0.3-1_amd64.deb
dpkg -i chef_12.0.3-1_amd64.deb
}

chef-solo -c solo.rb -j petalinux-dev.json 
