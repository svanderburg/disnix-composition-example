-- Really useless database which only contains a table called hello
-- and one 'Hello' record. This database is used by the HelloWorld
-- example case.

create database hello;
use hello;

create table hello
(
	hello	VARCHAR(255)	NOT NULL,
	PRIMARY KEY(hello)
);

insert into hello values ('Hello');
