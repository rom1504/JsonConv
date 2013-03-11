create table main
(
main_idx INT,
woot_begin INT,
woot_end INT,
la FLOAT
);
create table woot
(
woot_idx INT,
mainA TEXT
);
insert into woot (woot_idx,mainA)
values(2,"lolo");
insert into woot (woot_idx,mainA)
values(1,"lala");
insert into main (main_idx,woot_begin,woot_end,la)
values(3,1,2,5.);

