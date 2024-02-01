#!/bin/bash

# Ask the user if this is Kali Linux
read -p "Is this Kali Linux? (y/n): " is_kali

# Update fresh image
sudo apt update
sudo apt upgrade -y
sudo apt dist-upgrade

# Install initial tools
sudo apt install git curl apt-transport-https btop pip vim gem rubygems -y

# Install python and remove environment requirement
sudo apt install python3-full -y
sudo rm /usr/lib/python3.11/EXTERNALLY-MANAGED
sudo rm /usr/lib/python3.12/EXTERNALLY-MANAGED

# Check user input
if [ "$is_kali" = "n" ]; then
    # Add the Kali packages
    sudo sh -c "echo 'deb https://http.kali.org/kali kali-rolling main non-free contrib' > /etc/apt/sources.list.d/kali.list"

    # Add the public key for Kali
    wget -qO - 'https://archive.kali.org/archive-key.asc' | sudo apt-key add -

    # Add the low priority to the Kali packages
    sudo touch /etc/apt/preferences.d/kali.pref
    sudo sh -c "echo 'Package: *'>/etc/apt/preferences.d/kali.pref; echo 'Pin: release a=kali-rolling'>>/etc/apt/preferences.d/kali.pref; echo 'Pin-Priority: 50'>>/etc/apt/preferences.d/kali.pref"

    # Update the package list
    sudo apt update

    # Install aptitude
    sudo apt install aptitude -y
    # This now means you can use the following command to install tools from kali 
    # sudo aptitude install -t kali-rolling PACKAGE-NAME 

else
    echo "Skipping Kali repo setup."
fi

# Install ansible
python3 -m pip install ansible

# Add sublime gpg and source
wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/sublimehq-archive.gpg > /dev/null
echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list

# Install sublime
sudo apt-get update
sudo apt-get install sublime-text -y

# Installing go 
wget "https://go.dev/dl/go1.21.6.linux-amd64.tar.gz"
sudo rm -rf /usr/local/go && sudo tar -C /usr/local -xvf /home/$USER/go1.21.6.linux-amd64.tar.gz
rm -rf /home/$USER/go1.21.6.linux-amd64.tar.gz

# Setup go paths and other paths
mkdir /home/$USER/software
mkdir /home/$USER/software/go
echo 'export PATH=$PATH:/home/$USER/.local/bin 
export PATH=$PATH:/usr/local/go/bin
export PATH=$PATH:/home/$USER/software/go/bin
export GOMODCACHE=/home/$USER/software/go/pkg/mod
export GOPATH=/home/$USER/software/go
export LC_ALL=en_NZ.UTF-8
export LANG=en_NZ.UTF-8' >> .bashrc
export PATH=$PATH:/home/$USER/.local/bin
export PATH=$PATH:/usr/local/go/bin
export PATH=$PATH:/home/$USER/software/go/bin
export GOPATH=/home/$USER/software/go
export GOMODCACHE=/home/$USER/software/go/pkg/mod


# Download the ansible playbook
cd $HOME/software && git clone https://github.com/Flobeey/debian-ansible-build.git

# Run the playbook
$HOME/.local/bin/ansible-playbook $HOME/software/debian-ansible-build/main.yml
