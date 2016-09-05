# Chapter 6  
## Dynamic Code - Variables and Templates  
In this part of tutorial, we will learn about the variables and templates in Ansible.  
### 6.1 Variables  
* Automatic Variable - Facts
  * Run the following command to see to facts of db servers  
  ```
  ansible db -m setup | less
  ```


[Output]  
```
192.168.61.11 | SUCCESS => {
        "ansible_facts": {
            "ansible_all_ipv4_addresses": [
                "10.0.2.15",
                "192.168.61.11"
            ],
            "ansible_all_ipv6_addresses": [
                "fe80::a00:27ff:fe30:3251",
                "fe80::a00:27ff:fe8e:83e0"
            ],
            "ansible_architecture": "x86_64",
            "ansible_bios_date": "12/01/2006",
            "ansible_bios_version": "VirtualBox",
            "ansible_cmdline": {
                "KEYBOARDTYPE": "pc",
                "KEYTABLE": "us",
                "LANG": "en_GB.UTF-8",
                "SYSFONT": "latarcyrheb-sun16",
                "quiet": true,
                "rd_LVM_LV": "VolGroup/lv_root",
                "rd_NO_DM": true,
                "rd_NO_LUKS": true,
                "rd_NO_MD": true,
                "rhgb": true,
                "ro": true,
                "root": "/dev/mapper/VolGroup-lv_root"
            },
            "ansible_date_time": {
                "date": "2016-09-05",
                "day": "05",
                "epoch": "1473104372",
                "hour": "20",
                "iso8601": "2016-09-05T19:39:32Z",
                "iso8601_basic": "20160905T203932677277",
                "iso8601_basic_short": "20160905T203932",
                "iso8601_micro": "2016-09-05T19:39:32.677365Z",
                "minute": "39",
                "month": "09",
                "second": "32",
                "time": "20:39:32",
                "tz": "BST",
                "tz_offset": "+0100",
                "weekday": "Monday",
                "weekday_number": "1",
                "weeknumber": "36",
                "year": "2016"
            }

```

  * Filter facts  

    * Use filter attribute to extract specific data  
        ```
        ansible db -m setup -a "filter=ansible_distribution"

        ```

  [Output]  
```
192.168.61.11 | SUCCESS => {
  "ansible_facts": {
      "ansible_distribution": "CentOS"
  },
  "changed": false
}  
```


### 6.2 Templates  
* Create template for apache configuration  
  * This template will change **port number**, **document root** and **index.html** of apache server  
  * ** copy ** *httpd.conf* and *index.html* file from *roles/apache/files/* to *roles/apache/templates*  

    ```
    cp roles/apache/files/* roles/apache/templates
    ```
  * Change your working directory to templates
  * Lets edit httpd.conf file first
    * Rename the file
    ```
    mv httpd.conf httpd.conf.j2
    ```  
    * Change following static parameters into dynamic variables in *httpd.conf.j2*  
      * Listen
      * DocumentRoot
      * DirectoryIndex   
    ```
    ServerTokens OS

    ServerRoot "/etc/httpd"

    PidFile run/httpd.pid

    Timeout 60

    KeepAlive Off

    MaxKeepAliveRequests 100

    KeepAliveTimeout 15

    <IfModule prefork.c>
    StartServers       8
    MinSpareServers    5
    MaxSpareServers   20
    ServerLimit      256
    MaxClients       256
    MaxRequestsPerChild  4000
    </IfModule>

    <IfModule worker.c>
    StartServers         4
    MaxClients         300
    MinSpareThreads     25
    MaxSpareThreads     75
    ThreadsPerChild     25
    MaxRequestsPerChild  0
    </IfModule>

    Listen {{ apache_port }}

    LoadModule auth_basic_module modules/mod_auth_basic.so
    LoadModule auth_digest_module modules/mod_auth_digest.so
    LoadModule authn_file_module modules/mod_authn_file.so
    LoadModule authn_alias_module modules/mod_authn_alias.so
    LoadModule authn_anon_module modules/mod_authn_anon.so
    LoadModule authn_dbm_module modules/mod_authn_dbm.so
    LoadModule authn_default_module modules/mod_authn_default.so
    LoadModule authz_host_module modules/mod_authz_host.so
    LoadModule authz_user_module modules/mod_authz_user.so
    LoadModule authz_owner_module modules/mod_authz_owner.so
    LoadModule authz_groupfile_module modules/mod_authz_groupfile.so
    LoadModule authz_dbm_module modules/mod_authz_dbm.so
    LoadModule authz_default_module modules/mod_authz_default.so
    LoadModule ldap_module modules/mod_ldap.so
    LoadModule authnz_ldap_module modules/mod_authnz_ldap.so
    LoadModule include_module modules/mod_include.so
    LoadModule log_config_module modules/mod_log_config.so
    LoadModule logio_module modules/mod_logio.so
    LoadModule env_module modules/mod_env.so
    LoadModule ext_filter_module modules/mod_ext_filter.so
    LoadModule mime_magic_module modules/mod_mime_magic.so
    LoadModule expires_module modules/mod_expires.so
    LoadModule deflate_module modules/mod_deflate.so
    LoadModule headers_module modules/mod_headers.so
    LoadModule usertrack_module modules/mod_usertrack.so
    LoadModule setenvif_module modules/mod_setenvif.so
    LoadModule mime_module modules/mod_mime.so
    LoadModule dav_module modules/mod_dav.so
    LoadModule status_module modules/mod_status.so
    LoadModule autoindex_module modules/mod_autoindex.so
    LoadModule info_module modules/mod_info.so
    LoadModule dav_fs_module modules/mod_dav_fs.so
    LoadModule vhost_alias_module modules/mod_vhost_alias.so
    LoadModule negotiation_module modules/mod_negotiation.so
    LoadModule dir_module modules/mod_dir.so
    LoadModule actions_module modules/mod_actions.so
    LoadModule speling_module modules/mod_speling.so
    LoadModule userdir_module modules/mod_userdir.so
    LoadModule alias_module modules/mod_alias.so
    LoadModule substitute_module modules/mod_substitute.so
    LoadModule rewrite_module modules/mod_rewrite.so
    LoadModule proxy_module modules/mod_proxy.so
    LoadModule proxy_balancer_module modules/mod_proxy_balancer.so
    LoadModule proxy_ftp_module modules/mod_proxy_ftp.so
    LoadModule proxy_http_module modules/mod_proxy_http.so
    LoadModule proxy_ajp_module modules/mod_proxy_ajp.so
    LoadModule proxy_connect_module modules/mod_proxy_connect.so
    LoadModule cache_module modules/mod_cache.so
    LoadModule suexec_module modules/mod_suexec.so
    LoadModule disk_cache_module modules/mod_disk_cache.so
    LoadModule cgi_module modules/mod_cgi.so
    LoadModule version_module modules/mod_version.so

    Include conf.d/*.conf

    User apache
    Group apache

    ServerAdmin root@localhost

    UseCanonicalName Off

    DocumentRoot "{{ custom_root }}"
    <Directory />
        Options FollowSymLinks
        AllowOverride None
    </Directory>

    <Directory "/var/www/html">
        Options Indexes FollowSymLinks
        AllowOverride None
        Order allow,deny
        Allow from all
    </Directory>

    <IfModule mod_userdir.c>
        UserDir disabled
        #UserDir public_html
    </IfModule>

    DirectoryIndex {{ apache_index }} index.html.var
    AccessFileName .htaccess
    <Files ~ "^\.ht">
        Order allow,deny
        Deny from all
        Satisfy All
    </Files>

    TypesConfig /etc/mime.types

    DefaultType text/plain

    <IfModule mod_mime_magic.c>
    #   MIMEMagicFile /usr/share/magic.mime
        MIMEMagicFile conf/magic
    </IfModule>

    HostnameLookups Off

    ErrorLog logs/error_log

    LogLevel warn

    LogFormat "%h %l %u %t \"%r\" %>s %b \"%{Referer}i\" \"%{User-Agent}i\"" combined
    LogFormat "%h %l %u %t \"%r\" %>s %b" common
    LogFormat "%{Referer}i -> %U" referer
    LogFormat "%{User-agent}i" agent

    CustomLog logs/access_log combined

    ServerSignature On

    Alias /icons/ "/var/www/icons/"

    <Directory "/var/www/icons">
        Options Indexes MultiViews FollowSymLinks
        AllowOverride None
        Order allow,deny
        Allow from all
    </Directory>

    <IfModule mod_dav_fs.c>
        # Location of the WebDAV lock database.
        DAVLockDB /var/lib/dav/lockdb
    </IfModule>

    ScriptAlias /cgi-bin/ "/var/www/cgi-bin/"

    <Directory "/var/www/cgi-bin">
        AllowOverride None
        Options None
        Order allow,deny
        Allow from all
    </Directory>

    IndexOptions FancyIndexing VersionSort NameWidth=* HTMLTable Charset=UTF-8
    AddIconByEncoding (CMP,/icons/compressed.gif) x-compress x-gzip

    AddIconByType (TXT,/icons/text.gif) text/*
    AddIconByType (IMG,/icons/image2.gif) image/*
    AddIconByType (SND,/icons/sound2.gif) audio/*
    AddIconByType (VID,/icons/movie.gif) video/*

    AddIcon /icons/binary.gif .bin .exe
    AddIcon /icons/binhex.gif .hqx
    AddIcon /icons/tar.gif .tar
    AddIcon /icons/world2.gif .wrl .wrl.gz .vrml .vrm .iv
    AddIcon /icons/compressed.gif .Z .z .tgz .gz .zip
    AddIcon /icons/a.gif .ps .ai .eps
    AddIcon /icons/layout.gif .html .shtml .htm .pdf
    AddIcon /icons/text.gif .txt
    AddIcon /icons/c.gif .c
    AddIcon /icons/p.gif .pl .py
    AddIcon /icons/f.gif .for
    AddIcon /icons/dvi.gif .dvi
    AddIcon /icons/uuencoded.gif .uu
    AddIcon /icons/script.gif .conf .sh .shar .csh .ksh .tcl
    AddIcon /icons/tex.gif .tex
    AddIcon /icons/bomb.gif /core

    AddIcon /icons/back.gif ..
    AddIcon /icons/hand.right.gif README
    AddIcon /icons/folder.gif ^^DIRECTORY^^
    AddIcon /icons/blank.gif ^^BLANKICON^^

    DefaultIcon /icons/unknown.gif
    ReadmeName README.html
    HeaderName HEADER.html

    IndexIgnore .??* *~ *# HEADER* README* RCS CVS *,v *,t

    AddLanguage ca .ca
    AddLanguage cs .cz .cs
    AddLanguage da .dk
    AddLanguage de .de
    AddLanguage el .el
    AddLanguage en .en
    AddLanguage eo .eo
    AddLanguage es .es
    AddLanguage et .et
    AddLanguage fr .fr
    AddLanguage he .he
    AddLanguage hr .hr
    AddLanguage it .it
    AddLanguage ja .ja
    AddLanguage ko .ko
    AddLanguage ltz .ltz
    AddLanguage nl .nl
    AddLanguage nn .nn
    AddLanguage no .no
    AddLanguage pl .po
    AddLanguage pt .pt
    AddLanguage pt-BR .pt-br
    AddLanguage ru .ru
    AddLanguage sv .sv
    AddLanguage zh-CN .zh-cn
    AddLanguage zh-TW .zh-tw

    LanguagePriority en ca cs da de el eo es et fr he hr it ja ko ltz nl nn no pl pt pt-BR ru sv zh-CN zh-TW
    ForceLanguagePriority Prefer Fallback
    AddDefaultCharset UTF-8
    AddType application/x-compress .Z
    AddType application/x-gzip .gz .tgz
    AddType application/x-x509-ca-cert .crt
    AddType application/x-pkcs7-crl    .crl
    AddHandler type-map var
    AddType text/html .shtml
    AddOutputFilter INCLUDES .shtml


    Alias /error/ "/var/www/error/"

    <IfModule mod_negotiation.c>
    <IfModule mod_include.c>
        <Directory "/var/www/error">
            AllowOverride None
            Options IncludesNoExec
            AddOutputFilter Includes html
            AddHandler type-map var
            Order allow,deny
            Allow from all
            LanguagePriority en es de fr
            ForceLanguagePriority Prefer Fallback
        </Directory>
    </IfModule>
    </IfModule>


    ```  

  * Define values to variables in *roles/apache/defaults/main.yml* as follows,  

  ```
  ---
  apache_port: 80
  custom_root: /var/www/html
  apache_index: index.html
  ```  
  * Since we have made change in configuration files, we need to edit *roles/apache/tasks/config.yml* files  
  * Replace **copy** module with **template** modules as follows,  
  ```
  ---
  - name: Creating configuration templates...
    template: src=httpd.conf.j2
              dest=/etc/httpd.conf
              owner=root group=root mode=0644
    notify: Restart apache service
  - name: Copying index.html file...
    copy: src=index.html
          dest=/var/www/html/index.html
          mode=0777
  ```  
  * Delete httpd.conf in files directory  
  ```
  rm roles/apache/files/httpd.conf
  ```

  * Let's test this template in action  
  ```
  ansible-playbook site.yml
  ```  
  [Output]  
  ```
PLAY [Playbook to configure App Servers] ***************************************

TASK [setup] *******************************************************************
ok: [192.168.61.13]
ok: [192.168.61.12]

TASK [base : create admin user] ************************************************
ok: [192.168.61.13]
ok: [192.168.61.12]

TASK [base : remove dojo] ******************************************************
ok: [192.168.61.12]
ok: [192.168.61.13]

TASK [base : install tree] *****************************************************
ok: [192.168.61.12]
ok: [192.168.61.13]

TASK [base : install ntp] ******************************************************
ok: [192.168.61.13]
ok: [192.168.61.12]

TASK [base : start ntp service] ************************************************
ok: [192.168.61.13]
ok: [192.168.61.12]

TASK [apache : Installing Apache...] *******************************************
ok: [192.168.61.13]
ok: [192.168.61.12]

TASK [apache : Starting Apache...] *********************************************
ok: [192.168.61.13]
ok: [192.168.61.12]

TASK [apache : Creating configuration templates...] ****************************
changed: [192.168.61.12]
changed: [192.168.61.13]

TASK [apache : Copying index.html file...] *************************************
changed: [192.168.61.12]
changed: [192.168.61.13]

RUNNING HANDLER [apache : Restart apache service] ******************************
changed: [192.168.61.12]
changed: [192.168.61.13]

PLAY RECAP *********************************************************************
192.168.61.12              : ok=11   changed=3    unreachable=0    failed=0
192.168.61.13              : ok=11   changed=3    unreachable=0    failed=0

  ```
