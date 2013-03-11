create table main
(
main_idx INT,
salut_begin INT,
salut_end INT
);
create table salut
(
salut_idx INT,
salut1_begin INT,
salut1_end INT
);
create table salut1
(
salut1_idx INT,
mainA FLOAT
);
insert into salut1 (salut1_idx,mainA)
values(2,4.);
insert into salut (salut_idx,salut1_begin,salut1_end)
values(1,2,2);
insert into main (main_idx,salut_begin,salut_end)
values(3,1,1);

