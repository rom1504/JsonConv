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
salut2_begin INT,
salut2_end INT
);
create table salut2
(
salut2_idx INT,
test_begin INT,
test_end INT
);
create table test
(
test_idx INT,
test1_begin INT,
test1_end INT
);
create table test1
(
test1_idx INT,
mainA FLOAT
);
insert into test1 (test1_idx,mainA)
values(4,4.);
insert into test (test_idx,test1_begin,test1_end)
values(3,4,4);
insert into salut2 (salut2_idx,test_begin,test_end)
values(5,3,3);
insert into salut1 (salut1_idx,salut2_begin,salut2_end)
values(2,3,3);
insert into salut (salut_idx,salut1_begin,salut1_end)
values(1,2,2);
insert into main (main_idx,salut_begin,salut_end)
values(6,1,1);

