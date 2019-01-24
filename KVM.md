# KVM

## Hướng dẫn cài đặt KVM Hypervisor trên CentOS 7 

Đầu tiên kiểm tra xem CPU có hỗ trợ không.
```sh
$ sudo grep -E '(vmx|svm)' /proc/cpuinfo
```

**Bước 1**: Cài đặt KVM và liên kết các packages.
```sh
$ sudo yum install qemu-kvm qemu-img virt-manager libvirt libvirt-python libvirt-client virt-install virt-viewer bridge-utils
```

Chấp nhận cho service bắt đầu và chạy ẩn.
```sh 
$ sudo systemctl start libvirtd
$ sudo systemctl enable libvirtd
```

Kiểm tra KVM module đã được loadẻ hay chưa.
```sh
$ sudo lsmod | grep kvm
kvm_intel             162153  0
kvm                   525409  1 kvm_intel
```

Trong trường hợp không khởi tạo được GUI:
```sh
$ sudo yum install "@X Window System" xorg-x11-xauth xorg-x11-fonts-* xorg-x11-utils -y
```

Để khởi chạy giao diện GUI 
```sh
$ sudo yum install "@X Window System" xorg-x11-xauth xorg-x11-fonts-* xorg-x11-utils -y
```

**Bước 2**: Cấu hình Bridge Interface 
Trước khi khởi tạo VMs. Chúng ta phải khởi tạo ra Bridge Interface để có thể truy cập từ bên ngoài vào được.
```sh
$ sudo cd /etc/sysconfig/network-scripts/
$ sudo cp ifcfg-eno49 ifcfg-br0
```

và cấu hình như sau
```sh
$ sudo vi ifcfg-eno49
```

Sửa thông tin card lên mạng chính.
```sh
TYPE=Ethernet
BOOTPROTO=static
DEVICE=eno49
ONBOOT=yes
BRIDGE=br0
```

Sửa thông tin của Bridge file:
```sh
$ sudo vi ifcfg-br0
```

```sh
TYPE=Bridge
BOOTPROTO=static
DEVICE=br0
ONBOOT=yes
IPADDR=192.168.10.21
NETMASK=255.255.255.0
GATEWAY=192.168.10.1
DNS1=192.168.10.11
```

Khởi động lại dịch vụ mạng:
```sh
$ sudo systemctl restart network
```

# Hướng dẫn cài đặt KVM Hypervisor trên Ubuntu 18.04
## Cài đặt 
Kiểm tra xem CPU có hỗ trợ hay không
```sh
$ egrep -c '(vmx|svm)' /proc/cpuinfo
1
```

Cài đặt KVM
```sh
$ sudo apt update
$ sudo apt install qemu qemu-kvm libvirt-bin  bridge-utils  virt-manager
```

Khởi chạy libvirtd service.
```sh
$ sudo service libvirtd start
$ sudo update-rc.d libvirtd enable
$ service libvirtd status		//Nếu thấy trạng thái active tức là đã thành công.
```
## Configure
Khởi tạo file 01-netcfg.yaml và cấu hình như sau.
```sh
network:
  version: 2
  renderer: networkd
  ethernets:
    enp3s0f1:
      dhcp4: no
      dhcp6: no
  bridges:
    br0:
      interfaces: [enp3s0f1]
      dhcp4: yes
      dhcp6: no
```
**_(*)_**Tùy vào yêu cầu bài toán mà cấu hình br0 động hay tĩnh. Ở đây tôi cấu hình động.  

```sh
$ netplan apply
```

Để xem kết quả:
```sh
$ sudo networkctl status -a
```
Nếu thấy xuất hiện **br0** tức là cài đặt đã thành công.

Cuối cùng configure nốt file /etc/network/interfaces giống như sau:
```sh
interfaces(5) file used by ifup(8) and ifdown(8)
auto lo
iface lo inet loopback

auto br0
iface br0 inet dhcp
	bridge_port enp3s0f1
	bridge_stp off
        bridge_fd 0
        bridge_maxwait 0
```


## Cách tạo một VM bằng Command 
```sh
virt-install --name <Tên VMs> --memory <Số Ram> --vcpu <số nhân> \
--cdrom=<Link đến file iso> --disk size=<số GB ổ đĩa> \ 
--os-variant=<Loại OS>
```

Ví dụ: 
```sh
virt-install \
--name centos7 \
--memory 1024 \
--disk path=/home/centos7.img,size=8 \
--vcpus 1 \
--os-type linux \
--os-variant rhel7 \
--network bridge=br0 \
--graphics none \
--console pty,target_type=serial \
--cdrom=/home/CentOS.iso \
--extra-args 'console=ttyS0,115200n8 serial'
```
```sh
virt-install --name ubuntu18.04 --memory 1024 --vcpu 1 --cdrom=./ubuntu.iso --disk size=5 --os-variant=generic 
'''

## Các command cơ bản
Chạy một VM:
```sh
$ virsh start <tên VM>
```

Chạy và truy cập vào Console
```sh
$ virsh start <ten VM> --console
```

Tắt một máy ảo
```sh
$ virsh shutdown <Tên VM>
```

Stop fourcely Virtual Machine
```sh
$ virsh destroy <Tên VM>
```

Tự động bắt đầu khi khởi động máy.
```sh
$ virsh autostart <Tên VM>
```

Tắt chế độ tự khởi động. 
```sh
$ virsh autostart --disable <Tên VM>
```

Hiển thị danh sách 
```sh
$ virsh list --all
```

Kết nối đến một VM
```sh

```




