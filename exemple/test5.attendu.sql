create table main
(
main_idx INT,
salut INT
);
create table salut
(
salut_idx INT,
hello INT
);
create table hello
(
hello_idx INT,
hola_begin INT,
hola_end INT
);
create table hola
(
hola_idx INT,
mainA TEXT
);
insert into hola (hola_idx,mainA)
values(2,"bonjourno");
insert into hola (hola_idx,mainA)
values(1,"nihao");
insert into hello (hello_idx,hola_begin,hola_end)
values(3,1,2);
insert into salut (salut_idx,hello)
values(4,1);
insert into main (main_idx,salut)
values(5,1);

