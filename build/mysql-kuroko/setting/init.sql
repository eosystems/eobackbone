create database kuroko;
create database kuroko_development;

CREATE USER eoservice;
SET PASSWORD FOR eoservice@'%' = password('');
GRANT ALL ON kuroko.* TO eoservice@'%' IDENTIFIED BY 'init' WITH GRANT OPTION;
GRANT ALL ON kuroko_development.* TO eoservice@'%' IDENTIFIED BY 'init' WITH GRANT OPTION;
