## What is it?

This module is a [mfext](https://github.com/metwork-framework/mfext) add-on which
provides [Mapserver](https://mapserver.org) software and libraries around 
([mapserverapi](https://github.com/metwork-framework/mapserverapi) and 
[mapserverapi_python](https://github.com/metwork-framework/mapserverapi_python)).

## Provided layers

This add-on provides three layers:

- `mapserver@mfext` (the mapserver software and mapserverapi C library)
- `python3_mapserverapi@mfext` (the Python3 version of mapserverapi_python library)
- `python2_mapserverapi@mfext` (the Python2 version of mapserverapi_python library)

## Provides packages

So, to install this add-on, you have to install:

- `metwork-mfext-layer-mapserver` package
- (and/or) `metwork-mfext-layer-python2_mapserverapi` package
- (and/or) `metwork-mfext-layer-python3_mapserverapi` package

## Quickstart

```console

$ ##### As root user #####

$ # We install the Python3 enabled version of VIM
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
