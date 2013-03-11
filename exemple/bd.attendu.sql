create table main
(
main_idx INT,
prenom TEXT,
nom TEXT,
membre INT,
adresses_email_begin INT,
adresses_email_end INT,
adresse INT
);
create table adresse
(
adresse_idx INT,
rue TEXT,
Ville TEXT,
Pays TEXT,
CP FLOAT
);
create table adresses_email
(
adresses_email_idx INT,
login TEXT,
identite TEXT,
ISP TEXT
);
insert into adresses_email (adresses_email_idx,login,identite,ISP)
values(7,"martin","Paul Martin","truc.fr");
insert into main (main_idx,prenom,nom,adresses_email_begin,adresses_email_end,adresse)
values(8,"Paul","Martin",7,7,NULL);
insert into adresse (adresse_idx,Ville,Pays,CP)
values(5,"Amsterdam","Pays-Bas",84264.);
insert into main (main_idx,prenom,nom,membre,adresse)
values(6,"Pierre","Dupond",0,5);
insert into adresse (adresse_idx,rue,Ville,CP)
values(1,"rue d'Italie","Paris",93151.);
insert into adresses_email (adresses_email_idx,login,ISP)
values(3,"jean.dupont","machin.org");
insert into adresses_email (adresses_email_idx,login,identite,ISP)
values(2,"dupont","Jean Dupont","truc.fr");
insert into main (main_idx,prenom,nom,membre,adresses_email_begin,adresses_email_end,adresse)
values(4,"Jean","Dupont",1,2,3,1);

