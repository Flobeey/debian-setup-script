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

# Add sublime gpg and source - Install sublime - uncomment if wanted
# wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/sublimehq-archive.gpg > /dev/null
# echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list
# sudo apt-get update
# sudo apt-get install sublime-text -y

# Installing Go
curl -sS https://webi.sh/golang | sh

# Download the ansible playbook
mkdir $HOME/software
cd $HOME/software && git clone https://github.com/Flobeey/debian-ansible-build.git

# Run the playbook
/usr/local/bin/ansible-playbook $HOME/software/debian-ansible-build/main.yml
