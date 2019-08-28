[![logo](https://raw.githubusercontent.com/metwork-framework/resources/master/logos/metwork-white-logo-small.png)](http://www.metwork-framework.org)
# mfextaddon_mapserver

[//]: # (automatically generated from https://github.com/metwork-framework/resources/blob/master/cookiecutter/_%7B%7Bcookiecutter.repo%7D%7D/README.md)

## Status (master branch)
[![Drone CI](http://metwork-framework.org:8000/api/badges/metwork-framework/mfextaddon_mapserver/status.svg)](http://metwork-framework.org:8000/metwork-framework/mfextaddon_mapserver)
[![Maintenance](https://github.com/metwork-framework/resources/blob/master/badges/maintained.svg)]()
[![Gitter](https://github.com/metwork-framework/resources/blob/master/badges/community-en.svg)](https://gitter.im/metwork-framework/community-en?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge)
[![Gitter](https://github.com/metwork-framework/resources/blob/master/badges/community-fr.svg)](https://gitter.im/metwork-framework/community-fr?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge)


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

$ # We install the Python3 enabled version of mapserverapi
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




## Contributing guide

See [CONTRIBUTING.md](CONTRIBUTING.md) file.



## Code of Conduct

See [CODE_OF_CONDUCT.md](CODE_OF_CONDUCT.md) file.



## Sponsors

*(If you are officially paid to work on MetWork Framework, please contact us to add your company logo here!)*

[![logo](https://raw.githubusercontent.com/metwork-framework/resources/master/sponsors/meteofrance-small.jpeg)](http://www.meteofrance.com)
