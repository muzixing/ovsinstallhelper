#!/bin/bash

# Make sure only root can run our script
if [ "$(id -u)" != "0" ]; then
   echo "You need to be 'root' dude." 1>&2
   exit 1
fi

version = "2.3.1"
if ["$1" != "" ]; then
   version = $1
fi


#install
#apt-get update
#apt-get install -y build-essential


echo "====================INSTALL OpenvSwitch-$1===================="
#apt-get install -y   uml-utilities libtool python-qt4 python-twisted-conch debhelper python-all

if [  -f openvswitch-$1.tar.gz ]
then 
	echo "openvswitch-$1.tar.gz has exist"
else
	wget http://openvswitch.org/releases/openvswitch-$1.tar.gz
fi

if [  -d openvswitch-$1 ]
then
   rm -r openvswitch-$1
fi
tar -xzf openvswitch-$1.tar.gz

# Install openvswitch
cd openvswitch-$1
make clean
./configure --with-linux=/lib/modules/`uname -r`/build 2>/dev/null
make && make install

# install Open vSwitch kernel module
insmod datapath/linux/openvswitch.ko
make modules_install


mkdir -p /usr/local/etc/openvswitch
ovsdb-tool create /usr/local/etc/openvswitch/conf.db vswitchd/vswitch.ovsschema  2>/dev/null

ovsdb-server -v --remote=punix:/usr/local/var/run/openvswitch/db.sock \
                 --remote=db:Open_vSwitch,Open_vSwitch,manager_options \
                 --private-key=db:Open_vSwitch,SSL,private_key \
                 --certificate=db:Open_vSwitch,SSL,certificate \
                 --bootstrap-ca-cert=db:Open_vSwitch,SSL,ca_cert \
                 --pidfile --detach

#ovsdb-server -v --remote=punix:/usr/local/var/run/openvswitch/db.sock --pidfile --detach --log-file

ovs-vsctl --no-wait init
ovs-vswitchd --pidfile --detach

ovs-vsctl show

depmod -A openvswitch
