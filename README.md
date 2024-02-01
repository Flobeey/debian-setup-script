This is a setup for a fresh Debian install to get it up and running quickly

Uses an ansible script at the end to finish the setup - this can be configured to any other ansible file on github

Currently sets up some basic things 

- updates vim
- installs go and paths
- installs full python, pip and ansible
- installs sublime text

This also adds the kali repositories and if you would like to install tools from the kali repo the below command can be used
```
sudo aptitude install -t kali-rolling PACKAGE-NAME 
```

If anything fails in the ansible script this can be found in the software folder
just run the below once any errors have been addressed
```
ansible-playbook ~/software/debian-ansible-build/main.yml
```

