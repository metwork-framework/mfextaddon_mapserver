[![logo](https://raw.githubusercontent.com/metwork-framework/resources/master/logos/metwork-white-logo-small.png)](http://www.metwork-framework.org)
#  mfextaddon_mapserver

[//]: # (automatically generated from https://github.com/metwork-framework/resources/blob/master/cookiecutter/_%7B%7Bcookiecutter.repo%7D%7D/README.md)

**Status (master branch)**



[![Drone CI](http://metwork-framework.org:8000/api/badges/metwork-framework/mfextaddon_mapserver/status.svg)](http://metwork-framework.org:8000/metwork-framework/mfextaddon_mapserver)
[![Maintenance](https://github.com/metwork-framework/resources/blob/master/badges/maintained.svg)]()
[![Gitter](https://github.com/metwork-framework/resources/blob/master/badges/community-en.svg)](https://gitter.im/metwork-framework/community-en?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge)
[![Gitter](https://github.com/metwork-framework/resources/blob/master/badges/community-fr.svg)](https://gitter.im/metwork-framework/community-fr?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge)


**Table of contents**

* [1\. What is it?](#1-what-is-it)
* [2\. Provided layers](#2-provided-layers)
* [3\. Provides packages](#3-provides-packages)
* [4\. Quickstart](#4-quickstart)
* [5\. Full list of components](#5-full-list-of-components)
* [6\. Reference documentation](#6-reference-documentation)
* [7\. Installation guide](#7-installation-guide)
* [8\. Configuration guide](#8-configuration-guide)
* [9\. Contributing guide](#9-contributing-guide)
* [10\. Code of Conduct](#10-code-of-conduct)
* [11\. Sponsors](#11-sponsors)



## 1. What is it?

This module is a [mfext](https://github.com/metwork-framework/mfext) add-on which
provides [Mapserver](https://mapserver.org) software and libraries around 
([mapserverapi](https://github.com/metwork-framework/mapserverapi) and 
[mapserverapi_python](https://github.com/metwork-framework/mapserverapi_python)).

## 2. Provided layers

This add-on provides three layers:

- `mapserver@mfext` (the mapserver software and mapserverapi C library)
- `python3_mapserverapi@mfext` (the Python3 version of mapserverapi_python library)
- `python2_mapserverapi@mfext` (the Python2 version of mapserverapi_python library)

## 3. Provides packages

So, to install this add-on, you have to install:

- `metwork-mfext-layer-mapserver` package
- (and/or) `metwork-mfext-layer-python2_mapserverapi` package
- (and/or) `metwork-mfext-layer-python3_mapserverapi` package

## 4. Quickstart

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







## 5. Full list of components

| Name | Version | Layer |
| --- | --- | --- |
| [certifi](https://certifi.io/) | 2019.3.9 | python2_mapserverapi |
| [certifi](https://certifi.io/) | 2019.3.9 | python3_mapserverapi |
| [mapserver](http://mapserver.org) | 7.2.1 | mapserver |
| [mapserverapi](https://github.com/metwork-framework/mapserverapi) | 0.1.3 | mapserver |
| [mapserverapi](https://github.com/metwork-framework/mapserverapi_python) | custom | python2_mapserverapi |
| [mapserverapi](https://github.com/metwork-framework/mapserverapi_python) | custom | python3_mapserverapi |

*(6 components)*








## 6. Reference documentation

- (for **master (development)** version), see [this dedicated site](http://metwork-framework.org/pub/metwork/continuous_integration/docs/master/mfextaddon_mapserver/) for reference documentation.
- (for **latest released stable** version), see [this dedicated site](http://metwork-framework.org/pub/metwork/releases/docs/stable/mfextaddon_mapserver/) for reference documentation.

For very specific use cases, you might be interested in
[reference documentation for integration branch](http://metwork-framework.org/pub/metwork/continuous_integration/docs/integration/mfextaddon_mapserver/).

And if you are looking for an old released version, you can search [here](http://metwork-framework.org/pub/metwork/releases/docs/).



## 7. Installation guide

See [this document](.metwork-framework/install_a_metwork_package.md).


## 8. Configuration guide

See [this document](.metwork-framework/configure_a_metwork_package.md).



## 9. Contributing guide

See [CONTRIBUTING.md](CONTRIBUTING.md) file.



## 10. Code of Conduct

See [CODE_OF_CONDUCT.md](CODE_OF_CONDUCT.md) file.



## 11. Sponsors

*(If you are officially paid to work on MetWork Framework, please contact us to add your company logo here!)*

[![logo](https://raw.githubusercontent.com/metwork-framework/resources/master/sponsors/meteofrance-small.jpeg)](http://www.meteofrance.com)
