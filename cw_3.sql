SELECT *
FROM buildings2018;

SELECT count(gid)
FROM buildings2019;

-- zad 1
select * from buildings2019
left join buildings2018
on buildings2018.geom = buildings2019.geom
where buildings2018.gid is null; 

-- zad 2
with new_buildings as (
select buildings2019.* from buildings2019
left join buildings2018
on buildings2018.geom = buildings2019.geom
where buildings2018.gid is null),

new_pois as (
	select poi2019.* from poi2019
	left join poi2018
	on poi2018.geom = poi2019.geom
	where poi2018.gid is null
	)

select new_pois.type, count(*) as count
from new_pois
join new_buildings on st_intersects(new_pois.geom, st_buffer(new_buildings.geom, 0.005))
group by new_pois.type;

-- zad 3
-- shp2pgsql -s 3068 T2019_KAR_STREETS.shp streets_reprojected | psql -h localhost -p 5432 -U postgres -d postgres
select * from streets_reprojected; 

-- zad 4
create table input_points(
	id int primary key,
	name varchar,
	geom geometry
);

insert into input_points values
(1, 'A', 'POINT(8.36093 49.03174)'),
(2, 'B', 'POINT(8.39876 49.00644)');

select * from input_points;

-- zad 5
update input_points
set geom = st_transform(st_setsrid(geom,4326), 3068);

select * from input_points;

-- zad 6
select * from street_node_2019;

update street_node_2019
set geom = st_transform(st_setsrid(geom,4326), 3068);

with buffer_cte as(
select st_buffer(st_MakeLine(geom),0.002)
from input_points)

select street_node_2019.geom
from street_node_2019
join buffer_cte on st_intersects(buffer_cte.st_buffer, street_node_2019.geom)

-- zad 7
with park_cte as(
	select st_buffer(geom, 0.003) as buffer 
	from land_use2019
	where type = 'Park (City/County)'
)
select count(*) as number_of_shops
from park_cte 
cross join poi2019
where poi2019.type ='Sporting Goods Store' and st_contains(park_cte.buffer, poi2019.geom);

--zad 8
select st_intersection(railways2019.geom, water_lines2019.geom)
into t2019_kar_bridges
from railways2019
join water_lines2019 on st_intersects(railways2019.geom, water_lines2019.geom)

select * from t2019_kar_bridges;

