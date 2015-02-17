#!/bin/bash

if [[ ! -f /etc/redhat-release ]]; then
    echo "This is not CentOS - exiting." && exit 1
fi

yum install -y -q lvm2 xfsprogs.x86_64

# hs1.8xlarge - 24 local volumes
if [ -b /dev/xvdf -a -b /dev/xvdg -a -b /dev/xvdi -a -b /dev/xvdj  -a -b /dev/xvdk  -a -b /dev/xvdl  -a -b /dev/xvdm  -a -b /dev/xvdn  -a -b /dev/xvdo1  -a -b /dev/xvdo2  -a -b /dev/xvdo3  -a -b /dev/xvdo4  -a -b /dev/xvdo5 -a -b /dev/xvdo6 -a -b /dev/xvdo7 -a -b /dev/xvdo8 -a -b /dev/xvdo9 -a -b /dev/xvdp1 -a -b /dev/xvdp2 -a -b /dev/xvdp3 -a -b /dev/xvdp4 -a -b /dev/xvdp5 -a -b /dev/xvdp6 -a -b /dev/xvdp7 ] ; then
  pvcreate -ff -y /dev/xvdf
  pvcreate -ff -y /dev/xvdg
  pvcreate -ff -y /dev/xvdi
  pvcreate -ff -y /dev/xvdj
  pvcreate -ff -y /dev/xvdk
  pvcreate -ff -y /dev/xvdl
  pvcreate -ff -y /dev/xvdm
  pvcreate -ff -y /dev/xvdn
  pvcreate -ff -y /dev/xvdo1
  pvcreate -ff -y /dev/xvdo2
  pvcreate -ff -y /dev/xvdo3
  pvcreate -ff -y /dev/xvdo4
  pvcreate -ff -y /dev/xvdo5
  pvcreate -ff -y /dev/xvdo6
  pvcreate -ff -y /dev/xvdo7
  pvcreate -ff -y /dev/xvdo8
  pvcreate -ff -y /dev/xvdo9
  pvcreate -ff -y /dev/xvdp1
  pvcreate -ff -y /dev/xvdp2
  pvcreate -ff -y /dev/xvdp3
  pvcreate -ff -y /dev/xvdp4
  pvcreate -ff -y /dev/xvdp6
  pvcreate -ff -y /dev/xvdp6
  pvcreate -ff -y /dev/xvdp7
  vgcreate vg-ephem /dev/xvdf /dev/xvdg /dev/xvdi /dev/xvdj /dev/xvdk /dev/xvdl /dev/xvdm /dev/xvdn /dev/xvdo1 /dev/xvdo2 /dev/xvdo3 /dev/xvdo4 /dev/xvdo5 /dev/xvdo6 /dev/xvdo7 /dev/xvdo8 /dev/xvdo9 /dev/xvdp1 /dev/xvdp2 /dev/xvdp3 /dev/xvdp4 /dev/xvdp5 /dev/xvdp6 /dev/xvdp7
# i2.8xlarge - 8 local volumes
elif [ -b /dev/xvdb -a -b /dev/xvdc -a -b /dev/xvde -a -b /dev/xvdf -a -b /dev/xvdg -a -b /dev/xvdh -a -b /dev/xvdi -a -b /dev/xvdj ] ; then
  pvcreate -ff -y /dev/xvdb
  pvcreate -ff -y /dev/xvdc
  pvcreate -ff -y /dev/xvde
  pvcreate -ff -y /dev/xvdf
  pvcreate -ff -y /dev/xvdg
  pvcreate -ff -y /dev/xvdh
  pvcreate -ff -y /dev/xvdi
  pvcreate -ff -y /dev/xvdj
  vgcreate vg-ephem /dev/xvdb /dev/xvdc /dev/xvde /dev/xvdf /dev/xvdg /dev/xvdh /dev/xvdi /dev/xvdj
# r3.8xlarge - 2 local SSD volumes
elif [ -b /dev/xvdb -a -b /dev/xvdc ] ; then
  pvcreate -ff -y /dev/xvdb
  pvcreate -ff -y /dev/xvdc
  vgcreate vg-ephem /dev/xvdb /dev/xvdc
# r3 instances - 1 local SSD volume
elif [ -b /dev/xvdb ] ; then
  pvcreate -ff -y /dev/xvdb
  vgcreate vg-ephem /dev/xvdb
# anything with 4 local volumes
elif [ -b /dev/xvdf -a -b /dev/xvdg -a -b /dev/xvdh -a -b /dev/xvdi ] ; then
  pvcreate -ff -y /dev/xvdf
  pvcreate -ff -y /dev/xvdg
  pvcreate -ff -y /dev/xvdh
  pvcreate -ff -y /dev/xvdi
  vgcreate vg-ephem /dev/xvdf /dev/xvdg /dev/xvdh /dev/xvdi
# anything with 2 local volumes
elif [ -b /dev/xvdf -a -b /dev/xvdg ] ; then
  pvcreate -ff -y /dev/xvdf
  pvcreate -ff -y /dev/xvdg
  vgcreate vg-ephem /dev/xvdf /dev/xvdg
# anything with 1 local volume
elif [ -b /dev/xvdf ]; then
  pvcreate -ff -y /dev/xvdf
  vgcreate vg-ephem /dev/xvdf
fi

lvcreate -n lv-ephem -l 100%FREE vg-ephem
mkdir /mnt/ephemeral
mkfs.xfs /dev/vg-ephem/lv-ephem
sed -i "/lv-ephem/d" /etc/fstab && sed -i "$ a\/dev\/vg-ephem\/lv-ephem     \/mnt\/ephemeral  xfs     defaults,noatime        0 0" /etc/fstab
mount /mnt/ephemeral

