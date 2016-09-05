# Chapter 6  
## Dynamic Code - Variables and Templates  
In this part of tutorial, we will learn about the variables and templates in Ansible.  
### 6.1 Variables  
* Automatic Variable - Facts:
  * Run the following command to see to facts of db servers  
  ``` ansible db -m setup | less ```  
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
          },

  ```  
