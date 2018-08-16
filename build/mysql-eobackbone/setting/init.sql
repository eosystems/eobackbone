create database eobackbone;
create database eobackbone_development;

CREATE USER eoservice;
GRANT ALL ON eobackbone.* TO eoservice@'%' IDENTIFIED BY 'init' WITH GRANT OPTION;
GRANT ALL ON eobackbone_development.* TO eoservice@'%' IDENTIFIED BY 'init' WITH GRANT OPTION;
