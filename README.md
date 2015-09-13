OVSInstallHelper
================

This is a automatic installation script for install OpenvSwitch on Ubuntu 12.04+.

To make installation easiest. This helper script which should get all 
dependencies and download, build, and install OpenvSwitch.

we can intall specified OVS version by parsing argument of version. If input without version, OVS V2.3.1 will be installed.

```
 git clone https://github.com/muzixing/ovsinstallhelper.git
 cd ovsinstallhelper
 sudo ./ovsinstallhelper.sh [version]

```

Note: This script has only been tested on the most recent stable version of Ubuntu.

Contributor
===========

- [muzixing](https://github.com/muzixing)
- [Kimi Yang](https://github.com/Shouren)
