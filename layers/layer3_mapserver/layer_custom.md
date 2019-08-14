{% extends "layer.md" %}

{% block overview %}

.. index:: MapServer C APIs
The `mapserver` layer is a set of libraries and tools for using and invoking [MapServer](http://mapserver.org).

It provides MapServer command-line ([mapserv](https://mapserver.org/cgi/mapserv.html) and [Metwork MapServer C APIs](https://github.com/metwork-framework/mapserverapi) library to invoke [MapServer](http://mapserver.org) engine as a library (with no daemon or CGI).

.. note::
    In order to use Metwork MapServer C APIs, standard compilation tools must be installed (gcc, make...).
    
.. seealso::
    :ref:`C mapserverapi tutorial <mfextaddon_mapserverapi_tutorial:C mapserverapi tutorial>`
{% endblock %}
