## 1. Creating a table, measuring distances, reference systems
In this exercise, use the spherical WGS-84 reference system, SRID EPSG:4326 , used e.g. in by GPS receivers.

Create a table called cities, which stores the city name and the coordinates of its centre (as a GEOMETRY). Add at least two cities to the table, using data from Wikipedia – coordinates can be found under the geohack link in the top right corner (e.g. here ).

Caution: note that the coordinates are usually given in the (latitude, longitude) order, while WKT uses the opposite (longitude, latitude). Therefore, the centre of Kraków in WKT will look like this:

POINT(19.938333 50.061389)


Note that the default behaviour of geometry constructor functions (such as ST_GeomFromText or ST_MakePoint) is to generate a geometry without an SRID assigned (i.e., with SRID=0). To tag the geometry with the appropriate SRID (e.g. one that matches the coordinates), use ST_SetSRID.

Write a query which computes the distance between the two cities. What units is the result in?

To get a result in metres using ST_Distance, you must transform the coordinates to a planar reference system that covers your intended area and provides adequate precision in metres. Use the search engine at http://spatialreference.org to find the appropriate local reference system.

Recompute the distance, but this time cast the coordinates to that reference system using ST_Transform inside ST_Distance.

Repeat the task for several other SRIDs and compare the results.

## 2. Geometry vs. geography
In the first task, we used a planar reference system suitable for Poland, since GEOMETRY columns always measure distance as if the coordinates were on a flat surface, regardless of whether they are planar or spherical.

Obviously, there can be no global reference system using meters with adequate linear precision – hence the need to use local reference systems. This can be inconvenient if you need your database to be able to store data for any location in the world.

However, PostGIS also provides the GEOGRAPHY type, which uses WGS-84 (spherical) coordinates, but performs computations in metres, using a geoid representing the shape of the Earth. One drawback is that GEOGRAPHY is supported by less functions than GEOMETRY. Processing GEOGRAPHY objects is also a little slower.

Repeat task 1, creating a similar table called cities2, but this time use the GEOGRAPHY type. Remember that you don’t need to transform the coordinates this time.

Compare obtained the results with task 1.

## 3. Data import
The enclosed archive file contains data about parts of Kraków, originally downloaded from OpenStreetMap. The data is stored in ESRI shapefiles and uses different reference systems.

Note that this reference system is quasi-planar and, while it covers the entire globe, it is only suitable for visualisation. This is because the Mercator projection distorts the surface of the spheroid so that objects get gradually larger the further they are from the equator.

The shp2pgsql tool can be used to generate SQL code from the provided SHP files. Generate SQL files for the files in the archive, making sure to use the -s parameter to provide the appropriate SRID, e.g.:

shp2pgsql -s 3785 admin.shp > admin.sql


Now import the SQL files into the database.

The tables contain the following data:

admin – administrative boundaries (multipolygon); EPSG:4326,
lamps – lamp locations (point); EPSG:2180,
roads – roads (multilinestring); EPSG:4326.
For each of the tables, add a GEOGRAPHY column (ALTER TABLE) and use the UPDATE command to fill it with data from the geom column.

## 4. Area of Kraków
Calculate the area of Kraków in sq. km. Try approaches using the GEOGRAPHY as well as the GEOGRAPHY columns. Compare the results with the reference value from Wikipedia.

## 5. Simple spatial operations
Calculate the total length of roads used by motor vehicles. Only include the parts that are within the administrative boundary of Kraków.