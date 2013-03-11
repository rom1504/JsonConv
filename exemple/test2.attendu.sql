create table main
(
main_idx INT,
main1_begin INT,
main1_end INT
);
create table main1
(
main1_idx INT,
lo TEXT,
li TEXT,
la TEXT
);
insert into main1 (main1_idx,lo,li)
values(4,"lard","lourd");
insert into main (main_idx,main1_begin,main1_end)
values(3,4,4);
insert into main1 (main1_idx,la)
values(2,"lu");
insert into main (main_idx,main1_begin,main1_end)
values(1,2,2);

