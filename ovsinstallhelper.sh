#!/bin/bash

# Make sure only root can run our script
if [ "$(id -u)" != "0" ]; then
   echo "You need to be 'root' dude." 1>&2
   exit 1
fi

#install
#apt-get update
#apt-get install -y build-essential


echo "====================INSTALL OpenvSwitch-2.3.0===================="
#apt-get install -y   uml-utilities libtool python-qt4 python-twisted-conch debhelper python-all

if [  -f openvswitch-2.3.0.tar.gz ]
then 
    echo "openvswitch-2.3.0.tar.gz has exist"
else
    wget http://openvswitch.org/releases/openvswitch-2.3.0.tar.gz
fi

if [  -d openvswitch-2.3.0 ]
then
   rm -r openvswitch-2.3.0
fi
tar -xzf openvswitch-2.3.0.tar.gz

# Install openvswitch
cd openvswitch-2.3.0
make clean
./configure --with-linux=/lib/modules/`uname -r`/build 2>/dev/null
make && make install

# install Open vSwitch kernel module
insmod datapath/linux/openvswitch.ko
make modules_install


mkdir -p /usr/local/etc/openvswitch
ovsdb-tool create /usr/local/etc/openvswitch/conf.db vswitchd/vswitch.ovsschema  2>/dev/null

# start ovs server

#sh /usr/local/share/openvswitch/scripts/ovs-ctl stop
sh /usr/local/share/openvswitch/scripts/ovs-ctl restart

# you can use the below commands instead.

#ovsdb-server -v --remote=punix:/usr/local/var/run/openvswitch/db.sock \
#             --remote=db:Open_vSwitch,Open_vSwitch,manager_options \
#             --private-key=db:Open_vSwitch,SSL,private_key \
#             --certificate=db:Open_vSwitch,SSL,certificate \
#             --bootstrap-ca-cert=db:Open_vSwitch,SSL,ca_cert \
#             --pidfile --detach

#ovs-vsctl --no-wait init
#ovs-vswitchd --pidfile --detach

ovs-vsctl show
depmod -A openvswitch
