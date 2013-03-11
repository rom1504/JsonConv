create table main
(
main_idx INT,
salut INT
);
create table salut
(
salut_idx INT,
hello TEXT
);
insert into salut (salut_idx,hello)
values(1,"la");
insert into main (main_idx,salut)
values(2,1);

