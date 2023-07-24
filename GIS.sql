\o task1.txt

CREATE TABLE cities(name text, coordinates geometry);
INSERT INTO cities VALUES ('Krakow', ST_GeomFromText('POINT(19.938333 50.061389)', 4326));
INSERT INTO cities VALUES ('Torun', ST_GeomFromText('POINT(18.611111 53.022222)', 4326));
INSERT INTO cities VALUES ('Nassau', ST_GeomFromText('POINT(-77.333333 25.066667)', 4326));
SELECT ST_Distance((SELECT ST_Transform(coordinates, 2180) FROM cities WHERE name='Krakow'), (SELECT ST_Transform(coordinates, 2180) FROM cities WHERE name='Torun'));
SELECT ST_Distance((SELECT ST_Transform(coordinates, 3141) FROM cities WHERE name='Krakow'), (SELECT ST_Transform(coordinates, 3141) FROM cities WHERE name='Nassau'));
\o

\o task2.txt
CREATE TABLE cities2 (name text, coordinates geography);
INSERT INTO cities2 VALUES ('Krakow', 'POINT(19.938333 50.061389)');
INSERT INTO cities2 VALUES ('Banana', 'POINT(-157.393611 1.968611)');
INSERT INTO cities2 VALUES ('Nassau', 'POINT(-77.333333 25.066667)');
SELECT ST_Distance((SELECT coordinates FROM cities2 WHERE name='Krakow'),(SELECT coordinates FROM cities2 WHERE name='Banana'));
SELECT ST_Distance((SELECT coordinates FROM cities2 WHERE name='Krakow'),(SELECT coordinates FROM cities2 WHERE name='Nassau'));
\o

\o task3.txt
shp2pgsql -s 4326 admin.shp > admin.sql
psql -c 'SET search_path = lab3, public' -f admin.sql
shp2pgsql -s 2180 lamps.shp > lamps.sql
psql -c 'SET search_path = lab3, public' -f lamps.sql
shp2pgsql -s 4326 roads.shp > roads.sql
psql -c 'SET search_path = lab3, public' -f roads.sql
psql
ALTER TABLE admin ADD GEOGRAPHY geography;
UPDATE admin SET GEOGRAPHY = geom;
ALTER TABLE lamps ADD GEOGRAPHY geography;
UPDATE lamps SET GEOGRAPHY = ST_Transform(geom, 4326);
ALTER TABLE roads ADD GEOGRAPHY geography;
UPDATE roads SET GEOGRAPHY = geom;
\o

\o task4.txt
SELECT ST_Area(ST_Transform((geom), 2178)) FROM admin;
SELECT ST_Area(geography) from admin;
\o

\o task5.txt
SELECT sum(ST_Length(geom::geography)) FROM roads WHERE ST_Intersects(geom::geometry, (SELECT geom FROM admin)) AND road_type IN ('motorway','trunk','primary','secondary','tertiary','unclassified','residential','motorway_link','trunk_link','primary_link','secondary_link','teritrary_link','living_street','service','track','bus_guideway','escape','raceway','road','busway');
\o