import mapserverapi as mapserver


def get_mapfile_content(mapfile_path):
    with open(mapfile_path, 'r') as file:
        data = file.read().replace('\n', '')
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
