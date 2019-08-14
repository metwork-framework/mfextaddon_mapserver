#include <mapserverapi.h>
#include <stdio.h>
#include <stdlib.h>
#include <glib.h>

int main(void) {

    // Read the mapfile content.
    // We assume tuto_mapserver.map is in the same directory as that the code
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

    // Invoke mapserver
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

    // Invoke mapserver
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