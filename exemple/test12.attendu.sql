create table main
(
main_idx INT,
lu_begin INT,
lu_end INT,
la_begin INT,
la_end INT
);
create table la
(
la_idx INT,
la1_begin INT,
la1_end INT
);
create table la1
(
la1_idx INT,
mainA FLOAT
);
insert into la1 (la1_idx,mainA)
values(3,2.);
insert into la1 (la1_idx,mainA)
values(2,1.);
insert into la (la_idx,la1_begin,la1_end)
values(1,2,3);
insert into la1 (la1_idx,mainA)
values(6,4.);
insert into la1 (la1_idx,mainA)
values(5,3.);
insert into la (la_idx,la1_begin,la1_end)
values(4,5,6);
insert into main (main_idx,lu_begin,lu_end,la_begin,la_end)
values(7,4,4,1,1);

