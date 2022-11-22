-- zad 1
create table obiekty(id int, geometry geometry, name varchar);

insert into obiekty values
(1, ST_Collect(array['LINESTRING(0 1, 1 1)','CIRCULARSTRING(1 1, 2 0, 3 1)',
'CIRCULARSTRING(3 1, 4 2, 5 1)','LINESTRING(5 1, 6 1)']), 'obiekt1')

INSERT INTO obiekty values
(2, ST_Collect( array['LINESTRING(10 6, 14 6)', 'CIRCULARSTRING(14 6, 16 4, 14 2)', 'CIRCULARSTRING(14 2, 12 0, 10 2)',
'LINESTRING(10 2, 10 6)', 'CIRCULARSTRING(11 2, 12 3, 13 2)',
'CIRCULARSTRING(11 2, 12 1, 13 2)']),'obiekt2');

insert into obiekty values
(3,ST_Collect(array['LINESTRING(7 15,10 17)','LINESTRING(10 17,12 13)',
'LINESTRING(12 13,7 15)']) ,'obiekt3');

insert into obiekty values (4,ST_Collect(array['LINESTRING(20 20,25 25)','LINESTRING(25 25,27 24)','LINESTRING(27 24,25 22)','LINESTRING(25 22,26 21)',
'LINESTRING(26 21,22 19)','LINESTRING(22 19,20.5 19.5)']) ,'obiekt4');

insert into obiekty values (5, ST_Collect('POINT(30 30 59)', 'POINT(38 32 234)'), 'obiekt5');

insert into obiekty values (6, ST_Collect('POINT(4 2)', 'LINESTRING(1 1, 3 2)'), 'obiekt6');

-- zad 2
select st_area(st_buffer(st_shortestline((select geometry from obiekty where name = 'obiekt3'), (select geometry from obiekty where name = 'obiekt4')), 5));

-- zad 3
-- aby ten warunek byl spelniony pierwszy i ostatni punkt w poligonie musza byc takie same 
update obiekty
set geometry =  st_geomfromtext('POLYGON((20 20, 25 25, 27 24, 25 22, 26 21, 22 19, 20.5 19.5, 20 20))')
where name = 'obiekt4';

-- zad 4
insert into obiekty values (7, ST_COLLECT( array[(select geometry from obiekty where name = 'obiekt3'),
(select geometry from obiekty where name = 'obiekt4')]), 'obiekt7');

-- zad 5
select sum(st_area(st_buffer(geometry, 5)))
from obiekty
where not st_HasArc(geometry)