#!/bin/bash

ansible-playbook reboot.yml -i inventory/proxmox-pve1/hosts.ini
