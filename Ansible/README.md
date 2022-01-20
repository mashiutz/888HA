# Ansible Assignment

## Background

Ansible Assignment was done on VMWare Workstation, with 3 VM's:

- LNX01 (192.168.72.128)  - CentOS 8 linux server as Ansible managed host
- WS01 (192.168.72.130) - Windows Server 2022 as Ansible managed host
- LNX02 (192.168.72.129) - CentOS 8 linux server as Ansible Control node

LNX01 and WS01 were added to the hosts file in LNX02

## Ansible Control Node installation on LNX02

Ansible Control node was installed on LNX02.
ansible was installed using pip3

```language
pip3 install ansible
```

on top of that, I installed pywinrm to so ansible could use WinRM to connect to the windows host:

```language
pip3 install pywinrm
```

installed the community.windows collection as well:

```language
ansible-galaxy collection install community.windows
```

for the purpose of this assignment, host_key_checking was set to False so I can connect with user password in cleartext with ansible_user and ansible_pass

## Building Inventory Group

Created the AnsibleFiles directory in my home directory,
and created an inventory file:

    `cd ~`
    `mkdir AnsibleFiles`
    `cd AnsibleFiles`
    `nano inventory`

created the two groups according to the assignment, 
with the user and password as cleartext (a big no no in production environment!)

    [linux]
    lnx01

    [win]
    ws01

    [win:vars]
    ansible_user=SomeUser
    ansible_password=SomePass
    ansible_connection=winrm
    ansible_winrm_server_cert_validation=ignore

    [linux:vars]
    ansible_user=SomeUser
    ansible_password=SomePass

## Other tasks

added test.txt with content of "test content", on the same AnsibleFiles directory:

```language
echo "test content" >> test.txt
```

for the httpd.conf jinja file,
I have copied the file from a working apache machine, and edited what is needed.