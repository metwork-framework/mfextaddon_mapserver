# Using mapserverapi

in order to use Metwork mapserverapi:
- mfextaddon_mapserver must be :ref:`installed <install_mfextaddon_mapserver>`
- Metwork MFEXT environment must be :ref:`activated <mfextaddon_mapserver_intro:Usage (automatically for one user)>`. Note MFEXT is activated if you are working in another Metwork module, e.g. MFDATA, MFSERV, MFBASE...


.. index:: MapServer C APIs
## C mapserverapi tutorial

In this tutorial, we will learn how to use the :doc:`Metwork C Mapserver APIs <layer_mapserver>`.

In order to use Metwork MapServer C APIs, standard compilation tools must be installed (gcc, make...).

### Define your MapServer configuration
First, we have to define a [mapfile](https://www.mapserver.org/mapfile/)  to set where data are located and other MapServer configuration.

In this mapfile, we will use two vector layers : :download:`ocean </_downloads/ne_110m_ocean.zip>` and :download:`land </_downloads/ne_110m_land.zip>`, stored in a zip file containing shapefiles. 

For more convenience for ths tutorial, we use the [GDAL Virtual File Systems](https://gdal.org/user/virtual_file_systems.html) `/vsizip/`.  However, Virtual layers have a “cost” and are not as fast to display in MapServer as regular layers.

This :download:`tutorial  mapfile </_downloads/tuto_mapserver.map>` looks like this:

```cfg
MAP
    IMAGETYPE png
    SIZE 500 300
    UNITS DD
    EXTENT -180 -90 180 90
    WEB
        IMAGEPATH "/tmp/"
        METADATA
            "wms_title"           "WMS Demo Server"
            "wms_onlineresource"  "http://demo.mapserver.org/cgi-bin/mapserv?"
            "wms_srs"             "EPSG:4326"
            "ows_enable_request"  "*"
            'wfs_onlineresource' 'https://demo.mapserver.org/cgi-bin/mapserv/wfs?'
            'ows_enable_request' '*'
            'wfs_enable_request' '*'
        END
    END
    PROJECTION
        "init=epsg:4326"
    END

    LAYER
        NAME 'land'
        TYPE POLYGON
        STATUS ON
        CONNECTIONTYPE OGR
        # A full (absolute) path is required for the CONNECTION parameter, for these virtual layers.
        # e.g, /tmp/ne_110m_land.zip
        CONNECTION "/vsizip//tmp/ne_110m_land.zip"
        PROJECTION
            'init=epsg:4326'
        END
        DATA 'ne_110m_land'
        CLASS
            NAME "ne_110m_land"
            STYLE
                COLOR 238 236 223
                OUTLINECOLOR 255 255 0
                WIDTH 1.5
            END
        END
    END

    LAYER
        NAME 'ocean'
        TYPE POLYGON
        CONNECTIONTYPE OGR
        # A full (absolute) path is required for the CONNECTION parameter, for these virtual layers,
        # e.g, /tmp/ne_110m_ocean.zip
        CONNECTION "/vsizip//tmp/ne_110m_ocean.zip"
        STATUS ON
        PROJECTION
            'init=epsg:4326'
        END
        DATA 'ne_110m_ocean'
        CLASS
            NAME "ne_110m_ocean"
            STYLE
                COLOR 198 226 242
            END
        END
    END

END
```

You may need to change the absolute path of the `CONNECTION` argument.

For further, check the [mapfile](https://www.mapserver.org/mapfile/) documentation.

.. index:: WMS request, WFS request
### Write your C code

Let's now write :download:`C code </_downloads/tuto_mapserverapi.c>` to invoke MapServer throw the Metwork C mapserverapi:

```c
#include <mapserverapi.h>
#include <stdio.h>
#include <stdlib.h>
#include <glib.h>

int main(void) {

    FILE *f = fopen("tuto_mapserver.map", "rb");
    fseek(f, 0, SEEK_END);
    long fsize = ftell(f);
    fseek(f, 0, SEEK_SET);  /* same as rewind(f); */
    gchar *mapfile_content = malloc(fsize + 1);
    fread(mapfile_content, 1, fsize, f);
    fclose(f);

    mapfile_content[fsize] = 0;

    g_log_set_handler(NULL, G_LOG_LEVEL_DEBUG,  g_log_default_handler, NULL);

    // Init mapserver
    mapserverapi_init();

    g_setenv("REQUEST_METHOD", "GET", TRUE);


    // Set a GetFeature WFS query on 'land' layer with geometry intersection.
    gchar *query_string_wfs = "version=2.0.0&SERVICE=WFS&REQUEST=GetFeature&typename=land&filter=<Filter><Intersects><PropertyName>wkb_geometry</PropertyName><gml:Polygon><gml:outerBoundaryIs><gml:LinearRing><gml:posList>45.8362361184359 0.439239133054321 46.231579556351 2.99579336490519 46.073442181185 5.81590988869945 45.4211255086251 5.67753968542917 46.0207297227963 7.43681798415129 45.6583315713742 7.98370973993382 43.9188204445478 7.48953044253997 43.7804502412775 6.19148615471878 43.1479007406134 6.17830804012161 43.0622429957318 4.95933243988344 43.391695860661 3.62175380827074 43.3851068033624 2.20510648907502 43.9451766737421 1.07178863371845 44.7292744922737 0.538074992533092 45.2300428469662 0.22838929949961 45.8362361184359 0.439239133054321</gml:posList></gml:LinearRing></gml:outerBoundaryIs></gml:Polygon></Intersects></Filter>";

    void *body;
    gchar *content_type = NULL;
    gsize body_length;
    int i = 0;

    gboolean b = mapserverapi_invoke(mapfile_content, query_string_wfs, &body, &content_type, &body_length);

    if (b == TRUE) {
        // you have the full body (WFS XML response in this example) in body variable (this buffer is managed by the library, don't free it by yourself !)
        // you have the body length in body_length variable.
        // you have the content_type of the body in content_type variable (you have to free it after use).

        // Write the WFS response into a file
        FILE *fout = fopen("result_wfs.xml", "w");
        fprintf(fout,"%s", body);
        fclose(fout);

        g_free(content_type);
    }

    // Set a GetMap WMS query on 'ocean' layer
    gchar *query_string_wms = "LAYERS=ocean&TRANSPARENT=true&FORMAT=image%2Fpng&SERVICE=WMS&VERSION=1.1.1&REQUEST=GetMap&STYLES=&EXCEPTIONS=application%2Fvnd.ogc.se_xml&SRS=EPSG%3A4326&BBOX=-180.0,-90.0,180.0,90.0&WIDTH=500&HEIGHT=250";

    b = mapserverapi_invoke(mapfile_content, query_string_wms, &body, &content_type, &body_length);

    if (b == TRUE) {
        // you have the full body (PNG image in this example) in body variable (this buffer is managed by the library, don't free it by yourself !)
        // you have the body length in body_length variable.
        // you have the content_type of the body in content_type variable (you have to free it after use).

        // Write the WMS response into a file
        FILE *fout = fopen("result_wms.png", "wb");
        fwrite(body, body_length, 1, fout);
        fclose(fout);

        g_free(content_type);
        }

    // Release mapserver
    mapserverapi_destroy();
}
```

### Compile your C code
The library use :index:`pkg-config tool`. So you can use the following command to get the compilation flags:

```bash
pkg-config --cflags --libs mapserverapi
```

If not found, you may have to add PREFIX at the end of ${PKG_CONFIG_PATH} environnement variable.

Invoke `gcc` to compile the example, the command looks like this:

```bash
gcc -pthread -I/opt/metwork-mfext-master/opt/mapserver/include -I/opt/metwork-mfext-master/include/glib-2.0 -I/opt/metwork-mfext-master/lib/glib-2.0/include  -pthread -L/opt/metwork-mfext-master/opt/mapserver/lib  -L/opt/metwork-mfext-master/lib -lmapserverapi -lmapserver -lgobject-2.0 -lgthread-2.0 -lglib-2.0 tuto_mapserverapi.c
```
### Run the C example

Just enter:
```bash
./a.out
```
and check the generated files contents. You can download them to compare with yours: :download:`WFS XML response </_downloads/result_wfs.xml>` :download:`WMS PNG Response </_downloads/result_wms.png>`

.. seealso::
    | :doc:`MapServer Layer <layer_mapserver>`
    | `Metwork C mapserverapi on github <https://github.com/metwork-framework/mapserverapi>`_

.. index:: MapServer Python APIs
## Python mapserverapi tutorial

In this tutorial, we will learn how to use the :doc:`Metwork Python3 Mapserver APIs <layer_python3_mapserverapi>`.
 
We will build in Python 3 the same example as in the :ref:`mfextaddon_mapserverapi_tutorial:C mapserverapi tutorial`.
 
Define your MapServer configuration in the same way as in the [C example](#define-your-mapserver-configuration).

### Write your Python code

Let's now write :download:`Python code </_downloads/tuto_mapserverapi.py>` to invoke MapServer throw the Metwork Python mapserverapi:

```python
import mapserverapi as mapserver


def get_mapfile_content(mapfile_path):
    with open(mapfile_path, 'r') as mapfile:
        mapfile_content = mapfile.read()

    return mapfile_content


def invoke_mapserver_to_file(mapfile_content, query_string, output_file_path):
    # Invoke mapserver and save the output to a file
    content_type = mapserver.invoke_to_file(mapfile_content, query_string, output_file_path)
    if content_type is None:
        print("MapServer returned no content")


def invoke_mapserver(mapfile_content, query_string):
    # Invoke mapserver and print the output to stdout
    content_value, content_type = mapserver.invoke(mapfile_content, query_string)
    if content_value is None or content_value[0] is None:
        print("MapServer returned no content")
    else:
        print("Response:\nContent_type:{}\nContent:\n{}".format(content_type, content_value))


if __name__ == "__main__":
    # Read the mapfile content.
    # We assume tuto_mapserver.map is in the same directory as that the code
    mapfile_content = get_mapfile_content("tuto_mapserver.map")

    # Set a GetFeature WFS query on 'land' layer with geometry intersection.
    query_string_wfs = "version=2.0.0&SERVICE=WFS&REQUEST=GetFeature&typename=land&filter=<Filter><Intersects><PropertyName>wkb_geometry</PropertyName><gml:Polygon><gml:outerBoundaryIs><gml:LinearRing><gml:posList>45.8362361184359 0.439239133054321 46.231579556351 2.99579336490519 46.073442181185 5.81590988869945 45.4211255086251 5.67753968542917 46.0207297227963 7.43681798415129 45.6583315713742 7.98370973993382 43.9188204445478 7.48953044253997 43.7804502412775 6.19148615471878 43.1479007406134 6.17830804012161 43.0622429957318 4.95933243988344 43.391695860661 3.62175380827074 43.3851068033624 2.20510648907502 43.9451766737421 1.07178863371845 44.7292744922737 0.538074992533092 45.2300428469662 0.22838929949961 45.8362361184359 0.439239133054321</gml:posList></gml:LinearRing></gml:outerBoundaryIs></gml:Polygon></Intersects></Filter>";
    # Invoke mapserver and print the output to stdout
    invoke_mapserver(mapfile_content, query_string_wfs)

    # Set a GetMap WMS query on 'ocean' layer
    query_string_wms = "LAYERS=ocean&TRANSPARENT=true&FORMAT=image%2Fpng&SERVICE=WMS&VERSION=1.1.1&REQUEST=GetMap&STYLES=&EXCEPTIONS=application%2Fvnd.ogc.se_xml&SRS=EPSG%3A4326&BBOX=-180.0,-90.0,180.0,90.0&WIDTH=500&HEIGHT=250";
    # Invoke mapserver and print the output to stdout
    invoke_mapserver(mapfile_content, query_string_wms)

    # Set a GetFeature WFS query on 'land' layer with geometry intersection.
    query_string_wfs = "version=2.0.0&SERVICE=WFS&REQUEST=GetFeature&typename=land&filter=<Filter><Intersects><PropertyName>wkb_geometry</PropertyName><gml:Polygon><gml:outerBoundaryIs><gml:LinearRing><gml:posList>45.8362361184359 0.439239133054321 46.231579556351 2.99579336490519 46.073442181185 5.81590988869945 45.4211255086251 5.67753968542917 46.0207297227963 7.43681798415129 45.6583315713742 7.98370973993382 43.9188204445478 7.48953044253997 43.7804502412775 6.19148615471878 43.1479007406134 6.17830804012161 43.0622429957318 4.95933243988344 43.391695860661 3.62175380827074 43.3851068033624 2.20510648907502 43.9451766737421 1.07178863371845 44.7292744922737 0.538074992533092 45.2300428469662 0.22838929949961 45.8362361184359 0.439239133054321</gml:posList></gml:LinearRing></gml:outerBoundaryIs></gml:Polygon></Intersects></Filter>";
    # Invoke mapserver and save the output to a file
    invoke_mapserver_to_file(mapfile_content, query_string_wfs, "result_wfs.xml")

    # Set a GetMap WMS query on 'ocean' layer
    query_string_wms = "LAYERS=ocean&TRANSPARENT=true&FORMAT=image%2Fpng&SERVICE=WMS&VERSION=1.1.1&REQUEST=GetMap&STYLES=&EXCEPTIONS=application%2Fvnd.ogc.se_xml&SRS=EPSG%3A4326&BBOX=-180.0,-90.0,180.0,90.0&WIDTH=500&HEIGHT=250";
    # Invoke mapserver and save the output to a file
    invoke_mapserver_to_file(mapfile_content, query_string_wms, "result_wms.png")

```

### Run the Python example

In order to run the example, you may have choice between running it in a Metwork plugin or as a single python script.

- If you run it in a Metwork plugin, you have to add the :ref:`mapserverapi Python3 layer <layer_python3_mapserverapi:label>` in the `.layer_dependencies` file of your plugin (in order to load the `python3_mapserverapi@mfext` layer):

    ```cfg
    python3_mapserverapi@mfext
    ```

- If you run it as a single python script, you have to load the :ref:`MFEXT environment <mfextaddon_mapserver_intro:Usage (automatically for one user)>` and run the :download:`Python script </_downloads/tuto_mapserverapi.py>` through the :ref:`layer_wrapper utility <mfext:layerapi2:Utilities>` in order to load the :ref:`mapserverapi Python3 layer <layer_python3_mapserverapi:label>`.
The :download:`shell commands </_downloads/tuto_mapserverapi.sh>` look like that:

    ```bash
    #!/bin/bash
    
    # Activate MFEXT environment
    MFEXT_HOME=/opt/metwork-mfext
    export MFEXT_HOME
    source ${MFEXT_HOME}/share/interactive_profile
    
    # Load the python3_mapserverapi@mfext layer and run the mapserverapi.py script
    layer_wrapper --layers=python3_mapserverapi@mfext -- python tuto_mapserverapi.py
    ```

Then, check the generated content and files. You can download them to compare with yours: :download:`WFS XML response </_downloads/result_wfs.xml>` :download:`WMS PNG Response </_downloads/result_wms.png>`

.. seealso::
    | :doc:`MapServer Python2 Layer <layer_python2_mapserverapi>`
    | :doc:`MapServer Python3 Layer <layer_python3_mapserverapi>`
    | `Metwork Python mapserverapi on github <https://github.com/metwork-framework/mapserverapi_python>`_
    
# Using MapServer command-line

You can also invoke MapServer through the command-line [mapserv](https://mapserver.org/cgi/mapserv.html).

In order to use [mapserv](https://mapserver.org/cgi/mapserv.html):
- mfextaddon_mapserver must be :ref:`installed <install_mfextaddon_mapserver>`
- Metwork MFEXT environment must be :ref:`activated <mfextaddon_mapserver_intro:Usage (automatically for one user)>`. Note MFEXT is activated if you are working in another Metwork module, e.g. MFDATA, MFSERV, MFBASE...

The you can invoke the command, e.g. :
```bash
mapserv -nh "QUERY_STRING=LAYERS=ocean&TRANSPARENT=true&FORMAT=image%2Fpng&SERVICE=WMS&VERSION=1.1.1&REQUEST=GetMap&STYLES=&EXCEPTIONS=application%2Fvnd.ogc.se_xml&SRS=EPSG%3A4326&BBOX=-180.0,-90.0,180.0,90.0&WIDTH=500&HEIGHT=250&map=/tmp/tuto_mapserver.map" >/tmp/test_mapserv.png
```
Notice the `map` parameter of the above command refers to the path of the :download:`tutorial  mapfile </_downloads/tuto_mapserver.map>` 

.. seealso::
    For more details on the `mapserv` command_line, check `mapserv documentation <https://mapserver.org/cgi/mapserv.html>`_
    
<!--
Intentional comment to prevent m2r from generating bad rst statements when the file ends with a block .. xxx ::
-->        