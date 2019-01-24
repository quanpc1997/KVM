clear
virt-install --name=Centos7Command \
 --memory 2048 \
 --vcpu 2 \
--cdrom=/home/unknown/Downloads/CentOS-7-x86_64-Minimal-1810.iso \
--disk size=20 \
--os-variant rhel7 \
