VirtualKNN doesn't work from PHP.  The queries always return 0 rows, but running the queries directly works fine.

1. Build spatialite and initialize table "address" with a spatial column.

```
$ docker build -t spatialite .
```

2. Run simple query "SELECT * FROM knn ...".  No rows are returned.

```
$ docker run -it --rm spatialite /bin/bash

root@c01574406230:/build# php test.php
bool(false)
```

3. Confirm that the same query works fine when run directly:

```
root@c01574406230:/build# spatialite address.db
SpatiaLite version ..: 5.0.0	Supported Extensions:
	- 'VirtualShape'	[direct Shapefile access]
	- 'VirtualDbf'		[direct DBF access]
	- 'VirtualText'		[direct CSV/TXT access]
	- 'VirtualGeoJSON'		[direct GeoJSON access]
	- 'VirtualXL'		[direct XLS access]
	- 'VirtualNetwork'	[Dijkstra shortest path - obsolete]
	- 'RTree'		[Spatial Index - R*Tree]
	- 'MbrCache'		[Spatial Index - MBR cache]
	- 'VirtualFDO'		[FDO-OGR interoperability]
	- 'VirtualBBox'		[BoundingBox tables]
	- 'VirtualSpatialIndex'	[R*Tree metahandler]
	- 'VirtualElementary'	[ElemGeoms metahandler]
	- 'VirtualRouting'	[Dijkstra shortest path - advanced]
	- 'VirtualKNN'	[K-Nearest Neighbors metahandler]
	- 'VirtualGPKG'	[OGC GeoPackage interoperability]
	- 'SpatiaLite'		[Spatial SQL - OGC]
	- 'VirtualXPath'	[XML Path Language - XPath]
PROJ version ........: Rel. 4.9.3, 15 August 2016
GEOS version ........: 3.5.1-CAPI-1.9.1 r4246
RTTOPO version ......: 1.1.0
TARGET CPU ..........: x86_64-linux-gnu
SQLite version ......: 3.16.2
Enter ".help" for instructions
SQLite version 3.16.2 2017-01-06 16:32:41
Enter ".help" for instructions
Enter SQL statements terminated with a ";"
spatialite> SELECT * FROM knn WHERE f_table_name = 'address' AND ref_geometry = ST_GeomFromText('POINT(174 -41)', 4326);
address|shape||3|1|1|0.0
```
