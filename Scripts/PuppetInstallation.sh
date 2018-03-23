#!/bin/bash
#Author: Manohar Endla
#Date: 3/22/2018 16:00
#
alias puppet=/opt/puppetlabs/bin/puppet

function puppet_server_installation
{
sudo apt-get update
sudo apt-get install -y puppetserver
sudo ufw allow 8140
sudo systemctl start puppetserver
sudo systemctl enable puppetserver
}

function puppet_agent_installation
{
sudo apt-get install -y puppet-agent
sudo systemctl start puppet
sudo systemctl enable puppet
}

function download_packages
{
if  cat /etc/lsb-release | grep "xenial"
then
    curl -O https://apt.puppetlabs.com/puppetlabs-release-pc1-xenial.deb
    sudo dpkg -i puppetlabs-release-pc1-xenial.deb
elif cat /etc/lsb-release | grep "trusty"
then 
   curl -O https://apt.puppetlabs.com/puppetlabs-release-pc1-trusty.deb
   sudo dpkg -i puppetlabs-release-pc1-trusty.deb
else
  echo "Scripts currently support Puppet install on ubuntu14.0.4 and ubuntu 16.0.4"
  exit 1
fi
}

function check_puppet_service
{
service=$1
if (( $(ps -ef | grep -v grep | grep $service | wc -l) > 0 ))
then
echo 0
else
echo 1
#/etc/init.d/$service start
fi
}
function install_module_from_forge
{
cd /etc/puppetlabs/code/environments/production/modules
echo "Installing puppet module from puppetforge"
puppet module install rtyler-jenkins --version '1.7.0'
echo "Puppet moudle installation completed"
echo ""
}

function  create_site_pp
{
echo <<< EOL
node '$(hostname)'
{
include jenkins
}
EOL >> cd /etc/puppetlabs/code/environments/production/modules/site.pp ;
}

function apply_jenkins_module
{
echo "Applying jenkins module"
puppet apply /etc/puppetlabs/code/environments/production/modules/site.pp
echo "Jenkins should be up and running. Jenkins is also configured to run on bootup"
}

download_packages
puppet_server_installation
puppet_agent_installation
server_status=$(check_puppet_service puppetserver)
if [ $server_status -eq 0 ]
then
echo "puppet service is in running state. Proceeding with installation of Jenkins"
install_module_from_forge
create_site_pp
apply_jenkins_module
else
echo "Puppet service is not running. Exiting from installation"
exit 1
fi



: '
#echo "Script performs puppet server and agent installation on Ubuntu14.0.4 and Ubunut16.0.4"
#echo "Please choose one of the options to proceed with the installation"
#echo " 1. Installs both puppet master and puppet agent on the server "
#echo " 2. Installs only puppet master"
#echo " 3. Installs only puppet agent"

# read -p "Choose type of installation. 1, 2 or 3 : " installationType

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
   fi
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
   fi
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
   fi
    ;;
   *)
   echo "Selected invalid installation type"
   exit 1
   
   '
