ALTER USER 'root'@'localhost' IDENTIFIED BY "{{ mysql_root_db_pass }}";
uninstall plugin validate_password;
FLUSH PRIVILEGES;
