#!/bin/bash
#Author: Manohar Endla
#Date: 3/22/2018 16:00
#
function puppet_server_installation
{
sudo apt-get update
sudo apt-get install -y puppetserver
sudo ufw allow 8140
sudo systemctl start puppetserver
sudo systemctl enable puppetserver
}

function puppet_server_installation
{
sudo apt-get install -y puppet-agent
sudo systemctl start puppet
sudo systemctl enable puppet
}

function download_packages
{
if [ grep "xenial" /etc/lsb-release ];
then
    curl -O https://apt.puppetlabs.com/puppetlabs-release-pc1-xenial.deb
    sudo dpkg -i puppetlabs-release-pc1-xenial.deb
elif [ grep "trusty"  /etc/lsb-release ];
then 
   curl -O https://apt.puppetlabs.com/puppetlabs-release-pc1-trusty.deb
   sudo dpkg -i puppetlabs-release-pc1-trusty.deb
else
  echo "Scripts currently support Puppet install on ubuntu14.0.4 and ubuntu 16.0.4"
  exit 1
fi
}

function confirmation{
 read -p "Are you sure you want to proceed with the installation ? Y/N: "  -n 1 -r 
echo " " 
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
 echo "Aborting installation"
 exit 1
}

echo "Script performs puppet server and agent installation on Ubuntu14.0.4 and Ubunut16.0.4"
echo "Please choose one of the options to proceed with the installation"
echo " 1. Installs both puppet master and puppet agent on the server "
echo " 2. Installs only puppet master"
echo " 3. Installs only puppet agent"

read -p "Choose type of installation. 1, 2 or 3 : " installationType

case $installationType in
   1)
   echo "You have opted for Puppet master and puppet agent installation"
   confirmation
   if [$? == 0 ];
   then
     download_packages
     puppet_server_installation
     puppet_agent_installation
   else
    echo "Aborting installation"
   ;;
   2)
   echo "You have opted for only Puppet master installation"
   confirmation
   if [$? == 0 ];
   then
     download_packages
     puppet_server_installation
   else
    echo "Aborting installation"
   ;;
   3)
   echo "You have opted for only Puppet agent installation"
   confirmation
   if [$? == 0 ];
   then
     download_packages
     puppet_agent_installation
   else
    echo "Aborting installation"
    ;;
   *)
   echo "Selected invalid installation type"
   exit 1
