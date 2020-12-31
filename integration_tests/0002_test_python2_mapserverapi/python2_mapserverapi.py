import os
import mapserverapi


qs_wms = "LAYERS=ocean&TRANSPARENT=true&FORMAT=image%2Fpng&SERVICE=WMS&" \
    "VERSION=1.1.1&REQUEST=GetMap&STYLES=&EXCEPTIONS=application%2Fvnd.ogc." \
    "se_xml&SRS=EPSG%3A4326&BBOX=-180.0,-90.0,180.0,90.0&WIDTH=500&HEIGHT=250"
datadir = os.path.realpath(os.path.dirname(os.path.realpath(__file__)) +
                           "/datas")
qs_wfs = "version=2.0.0&SERVICE=WFS&REQUEST=GetFeature&typename=land&filter=<Filter><Intersects><PropertyName>wkb_geometry</PropertyName><gml:Polygon><gml:outerBoundaryIs><gml:LinearRing><gml:posList>45.8362361184359 0.439239133054321 46.231579556351 2.99579336490519 46.073442181185 5.81590988869945 45.4211255086251 5.67753968542917 46.0207297227963 7.43681798415129 45.6583315713742 7.98370973993382 43.9188204445478 7.48953044253997 43.7804502412775 6.19148615471878 43.1479007406134 6.17830804012161 43.0622429957318 4.95933243988344 43.391695860661 3.62175380827074 43.3851068033624 2.20510648907502 43.9451766737421 1.07178863371845 44.7292744922737 0.538074992533092 45.2300428469662 0.22838929949961 45.8362361184359 0.439239133054321</gml:posList></gml:LinearRing></gml:outerBoundaryIs></gml:Polygon></Intersects></Filter>"

def test_invoke_wms():
    with open("%s/test.map" % datadir, "r") as f:
        mapfile = f.read().replace('{DATAPATH}', datadir)
    buf, content_type = mapserverapi.invoke(mapfile, qs_wms)
    assert buf is not None
    assert content_type == b"image/png"
    assert len(buf) > 1000
    print("test_invoke_wms ok")


def test_invoke_wfs():
    with open("%s/test.map" % datadir, "r") as f:
        mapfile = f.read().replace('{DATAPATH}', datadir)
    buf, content_type = mapserverapi.invoke(mapfile, qs_wfs)
    assert buf is not None
    assert content_type.startswith(b'text/xml; subtype="gml/')
    assert content_type.endswith(b'charset=UTF-8')
    #assert content_type == b'text/xml; subtype="gml/3.2.1"; charset=UTF-8'
    assert "msGeometry" in str(buf)
    print("test_invoke_wfs ok")


def test_invoke_to_file():
    try:
        os.unlink("/tmp/test_mapserverapi_python")
    except Exception:
        pass
    with open("%s/test.map" % datadir, "r") as f:
        mapfile = f.read().replace('{DATAPATH}', datadir)
    ct = mapserverapi.invoke_to_file(mapfile, qs_wms,
                                     "/tmp/test_mapserverapi_python")
    assert ct == b"image/png"
    assert os.path.isfile("/tmp/test_mapserverapi_python")
    with open("/tmp/test_mapserverapi_python", "rb") as f:
        content = f.read()
        assert len(content) > 1000
    os.unlink("/tmp/test_mapserverapi_python")
    print("test_invoke_to_file ok")


test_invoke_wms()
test_invoke_wfs()
test_invoke_to_file()
