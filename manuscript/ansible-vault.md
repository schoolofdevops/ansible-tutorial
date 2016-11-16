Vault
   * To maintain sensitive data e.g. passwords/creds, keys etc.
   * Version control encrypted files instead of plain text
   * ansible-vault utility

Howe ?
  * Used AES Cipher
  * Symmetric Key

 What can be encrypted ?
   * Structured data (yaml, json)
   * Var files
     * group_vars/hostvars
     * include_vars or  var_files
     * var files passed at command line with "-e @file"
   * Tasks (however not very common)
   * Arbitory Files

What can not be encrypted ?
  * Templates


How to encrypt/decrypt
  * Using --ask-vault-pass
  * Using --vault-password-file


ansible-vault Operations
  * encrypt
  * decrypt
  * create
  * rekey
  * edit

Running Playbooks with Vault

ansible-playbook site.yml --ask-vault-pass
ansible-playbook site.yml --vault-password-file ~/.vault_pass.txt


Automating Rekeying Process
--new-vault-password-file=NEW_VAULT_PASSWORD_FILE
                       new vault password file for rekey




Lab:

```
ansible-vault encrypt roles/mysql/defaults/main.yml
ansible-vault encrypt group_vars/all.yml
ansible-vault view group_vars/all.yml
ansible-playbook site.yml --ask-vault-pass

```
