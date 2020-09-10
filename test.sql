CREATE TABLE address (
    id INTEGER NOT NULL PRIMARY KEY
);
SELECT AddGeometryColumn('address', 'shape', 4326, 'POINT', 'XY');
INSERT INTO address VALUES (1, ST_GeomFromText('POINT(174 -41)', 4326));
SELECT CreateSpatialIndex('address', 'shape');
