create table main
(
main_idx INT,
main_begin INT,
main_end INT
);
create table main1
(
main1_idx INT,
main_begin INT,
main_end INT
);
create table main2
(
main2_idx INT,
mainA FLOAT
);
insert into main2 (main2_idx,mainA)
values(1,5.);
insert into main1 (main1_idx,main_begin,main_end)
values(2,1,1);
insert into main (main_idx,main_begin,main_end)
values(3,1,1);

