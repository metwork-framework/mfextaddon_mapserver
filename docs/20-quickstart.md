# Quickstart

!!! note
    **This guide is for CentOS/Fedora Linux distributions.**

    See mfext installation guide for adapt it for other distributions.

```console

$ ##### As root user #####

$ # We install the Python3 enabled version of mapserverapi
$ # (for CentOS/Fedore Linux distributions, see mfext installation guide
$ #  for other options)
$ yum -y install metwork-mfext-layer-python3_mapserverapi


$ ##### As lambda user #####

$ # We load the mfext environment (if it is not already done)
$ . /opt/metwork-mfext/share/interactive_profile

$ # We check that the layer is installed and loaded
$ layers |grep mapserver
- (*) mapserver@mfext [/opt/metwork-mfext/opt/mapserver]
- python2_mapserverapi@mfext [/opt/metwork-mfext/opt/python2_mapserverapi]
- (*) python3_mapserverapi@mfext [/opt/metwork-mfext/opt/python3_mapserverapi]

$ # note: we should have the `(*)` sign before each **loaded** layers
$ #       in that example, this is normal not to have the `(*)` sign before
$ #       python2_mapserverapi@mfext layer because both pythonX layers are mutually
$ #       exclusive

$ python
>>> import mapserverapi
>>> # See https://github.com/metwork-framework/mapserverapi_python#example
>>> # for a full example
```
