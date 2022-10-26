-- zad. 2
create database cwiczenia_2;

-- zad. 3
CREATE EXTENSION postgis;

-- zad. 4
CREATE TABLE buildings (
   id serial PRIMARY key,
   geometry GEOMETRY, 
   name VARCHAR(50)
);

CREATE TABLE roads (
   id serial PRIMARY key,
   geometry GEOMETRY, 
   name VARCHAR(50)
);


CREATE TABLE poi (
   id serial PRIMARY key,
   geometry GEOMETRY, 
   name VARCHAR(50)
);

-- zad. 5
insert into buildings values 
 ('0', 'POLYGON((8 1.5, 8 4, 10.5 4, 10.5 1.5, 8 1.5))', 'BuildingA'),
 ('1', 'POLYGON ((4 5, 6 5, 6 7, 4 7, 4 5))', 'BuildingB'),
 ('2', 'POLYGON ((3 6, 5 6, 5 8, 3 8, 3 6))', 'BuildingC'),
 ('3', 'POLYGON ((9 8, 10 8, 10 9, 9 9, 9 8))', 'BuildingD'),
 ('4', 'POLYGON ((1 1, 2 1, 2 2, 1 2, 1 1))', 'BuildingF');

insert into roads values 
 ('0', 'LINESTRING(0 4.5, 12 4.5)', 'RoadX'),
 ('1', 'LINESTRING(7.5 0, 7.5 10.5)', 'RoadY');


insert into poi values 
 ('0', 'POINT(1 3.5)', 'G'),
 ('1', 'POINT(5.5 1.5)','H'),
 ('2', 'POINT(9.5 6)', 'I'),
 ('3', 'POINT(6.5 6)', 'J'),
 ('4', 'POINT(6 9.5)', 'K');


select id, ST_AsText(geometry), name from buildings;
select id, ST_AsText(geometry), name from roads;
select id, ST_AsText(geometry), name from poi;

-- zad. 6

-- a)
select sum(ST_Length(geometry)) as summary_length_of_roads from roads;

-- b)
select ST_AsText(geometry) as wkt, ST_Area(geometry) as area, ST_Perimeter(geometry) as perimeter-- ST_Length(ST_ExteriorRing(geometry))
from buildings where name ='BuildingA';

-- c
select name, ST_Area(geometry) as area
from buildings 
order by name;

-- d
with cte as (
select name, ST_Area(geometry) as area
from buildings
) 
select * from cte
order by area desc
limit 2;

-- e
select ST_Distance(buil_geom, poi_geom) as distance
from (
select buildings.geometry as buil_geom, poi.geometry as poi_geom from buildings
cross join poi
where buildings.name = 'BuildingC' and poi.name = 'K') as foo;

-- f
with cteB as (
select ST_Buffer(geometry, 0.5) from buildings
where name = 'BuildingB'),

cteC as (
select * from buildings
where name = 'BuildingC')

select ST_Area(ST_Difference(cteC.geometry, cteB.st_buffer))
from cteC
cross join cteB;

-- g
with cteY_val as (
select ST_YMAX(geometry) as y_max from roads 
where name = 'RoadX')

select name from buildings
cross join cteY_val
where ST_Y(ST_Centroid(geometry)) > y_max;


-- h
select ST_Area(ST_Difference(geometry, ST_GeomFromText('POLYGON((4 7, 6 7, 6 8, 4 8, 4 7))'))) +
ST_Area(ST_Difference(ST_GeomFromText('POLYGON((4 7, 6 7, 6 8, 4 8, 4 7))'), geometry)) as area
from buildings
where name = 'BuildingC';





 