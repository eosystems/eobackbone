create database eobackbone;
create database eobackbone_development;
create database kuroko;
create database kuroko_development;


CREATE USER eoservice;
GRANT ALL ON eobackbone.* TO eoservice@'%' IDENTIFIED BY 'init' WITH GRANT OPTION;
GRANT ALL ON eobackbone_development.* TO eoservice@'%' IDENTIFIED BY 'init' WITH GRANT OPTION;
GRANT ALL ON kuroko.* TO eoservice@'%' IDENTIFIED BY 'init' WITH GRANT OPTION;
GRANT ALL ON kuroko_development.* TO eoservice@'%' IDENTIFIED BY 'init' WITH GRANT OPTION;
