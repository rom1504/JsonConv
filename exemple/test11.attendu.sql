create table main
(
main_idx INT,
a_begin INT,
a_end INT
);
create table a
(
a_idx INT,
a1_begin INT,
a1_end INT
);
create table a1
(
a1_idx INT,
mainA FLOAT
);
insert into a1 (a1_idx,mainA)
values(6,2.);
insert into a1 (a1_idx,mainA)
values(5,3.);
insert into a (a_idx,a1_begin,a1_end)
values(4,5,6);
insert into a1 (a1_idx,mainA)
values(3,4.);
insert into a1 (a1_idx,mainA)
values(2,5.);
insert into a (a_idx,a1_begin,a1_end)
values(1,2,3);
insert into main (main_idx,a_begin,a_end)
values(7,1,4);

