create table main
(
main_idx INT,
el2_begin INT,
el2_end INT,
el1_begin INT,
el1_end INT
);
create table el1
(
el1_idx INT,
mainA TEXT
);
insert into el1 (el1_idx,mainA)
values(4,"1t4");
insert into el1 (el1_idx,mainA)
values(3,"1t3");
insert into el1 (el1_idx,mainA)
values(2,"1t2");
insert into el1 (el1_idx,mainA)
values(1,"1t1");
insert into el1 (el1_idx,mainA)
values(8,"2t4");
insert into el1 (el1_idx,mainA)
values(7,"2t3");
insert into el1 (el1_idx,mainA)
values(6,"2t2");
insert into el1 (el1_idx,mainA)
values(5,"2t1");
insert into main (main_idx,el2_begin,el2_end,el1_begin,el1_end)
values(9,5,8,1,4);

