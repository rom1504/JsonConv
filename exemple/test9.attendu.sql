create table main
(
main_idx INT,
main1_begin INT,
main1_end INT
);
create table main1
(
main1_idx INT,
mainA FLOAT
);
insert into main1 (main1_idx,mainA)
values(6,4.);
insert into main1 (main1_idx,mainA)
values(5,3.);
insert into main (main_idx,main1_begin,main1_end)
values(4,5,6);
insert into main1 (main1_idx,mainA)
values(3,2.);
insert into main1 (main1_idx,mainA)
values(2,1.);
insert into main (main_idx,main1_begin,main1_end)
values(1,2,3);

