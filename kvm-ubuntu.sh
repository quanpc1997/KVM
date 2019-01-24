virt-install --name=Ubuntu18.04 \
 --memory 2048 \
 --vcpu 2 \
--cdrom=/home/unknown/Downloads/ubuntu-18.04.1.0-live-server-amd64.iso \
--disk size=50 \
--os-variant ubuntu18.04 \
--network bridge=br0
