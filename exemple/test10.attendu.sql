create table main
(
main_idx INT,
main1_begin INT,
main1_end INT
);
create table main1
(
main1_idx INT,
main2_begin INT,
main2_end INT
);
create table main2
(
main2_idx INT,
mainA TEXT
);
insert into main2 (main2_idx,mainA)
values(4,"lo");
insert into main2 (main2_idx,mainA)
values(3,"la");
insert into main1 (main1_idx,main2_begin,main2_end)
values(2,3,4);
insert into main (main_idx,main1_begin,main1_end)
values(1,2,2);

