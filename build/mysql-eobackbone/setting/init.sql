create database eobackbone;
create database eobackbone_development;

CREATE USER eoservice;
SET PASSWORD FOR eoservice@'%' = password('');
GRANT ALL ON eobackbone.* TO eoservice@'%' IDENTIFIED BY 'init' WITH GRANT OPTION;
GRANT ALL ON eobackbone_development.* TO eoservice@'%' IDENTIFIED BY 'init' WITH GRANT OPTION;
