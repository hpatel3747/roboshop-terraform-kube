# roboshop-terraform

## Deploy Hashicorp vault

### download repo
```text
curl -L -o /etc/yum.repos.d/vault.repo /https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo
```
### search repo downloaded
```text
dnf list | grep vault
```
### install vault
```text
dnf install vault -y

systemctl start vault

# check listening port/ip 
netstat -lntp
```
### access vault
```text
https://public_ip:8200

keys shares: 1 (depends how many  people )
key threshold: 1

then initialize

root token is like root password

key 1 is to unlock the vault

download the key file and save it on lcoal hard drive

add key in unseal key step

use root token method to login
```
#### to run ansible playbook calling password from hashicorp vault
```text
git pull ; ansible-playbook 10-hashicorp-vault.yml -e vault_token= {{ token }}
```
#### to unseal vault from command prompt
```text
$sudo -i
VAULT_ADDR=http://127.0.0.1:8200 vault operator unseal 0d76651d1698321....type_in_entire_unseal_key
```
##
