#!/bin/bash

# Update fresh image
sudo apt update
sudo apt upgrade -y
sudo apt dist-upgrade

# Install initial tools
sudo apt install git apt-transport-https btop pip -y

# Install python and remove environment requirement
sudo apt install python3-full
sudo rm /usr/lib/python3.11/EXTERNALLY-MANAGED
sudo rm /usr/lib/python3.12/EXTERNALLY-MANAGED

# Add the kali packages
sudo sh -c "echo 'deb https://http.kali.org/kali kali-rolling main non-free contrib' > /etc/apt/sources.list.d/kali.list"

# Add the public key for kali
wget -qO - 'https://archive.kali.org/archive-key.asc' | sudo apt-key add -

# Add the low priority to the kali packages
sudo touch /etc/apt/preferences.d/kali.pref
sudo sh -c "echo 'Package: *'>/etc/apt/preferences.d/kali.pref; echo 'Pin: release a=kali-rolling'>>/etc/apt/preferences.d/kali.pref; echo 'Pin-Priority: 50'>>/etc/apt/preferences.d/kali.pref"

# Install aptitude
sudo apt install aptitude
# This now means you can use the following command to install tools from kali 
# sudo aptitude install -t kali-rolling PACKAGE-NAME 

# Install ansible
python3 -m pip install ansible

# Add sublime gpg and source
wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/sublimehq-archive.gpg > /dev/null
echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list

# Install sublime
sudo apt-get update
sudo apt-get install sublime-text

# Installing go 
wget "https://go.dev/dl/go1.21.6.src.tar.gz"
rm -rf /usr/local/go && tar -C /usr/local -xzf go1.21.6.linux-amd64.tar.gz

# Setup go paths and other paths
mkdir '/home/$USER/software'
echo 'export PATH=$PATH:/home/$USER/.local/bin 
export PATH=$PATH:/usr/local/go/bin
export PATH=$PATH:/home/$USER/software/go/bin
export GOMODCACHE=/home/$USER/software/go/pkg/mod
export GOPATH=/home/$USER/software/go
export LC_ALL=en_NZ.UTF-8
export LANG=en_NZ.UTF-8' >> .zshrc


# Download the ansible playbook
cd $HOME
git clone https://github.com/Flobeey/kali-ansible-build.git
cd kali-ansible-build

# Run the playbook
ansible-playbook main.yml
