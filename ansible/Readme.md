# Create an ansible playbook that deploys the service to the VM.


## Running
```sh
ansible-playbook --vault-password-file vault-password.txt deploy.yml
```
* vault-password.txt - I placed file in root directory for education purpose (in real project that file must store in safe place)


## Playbook description
### deploy.yml
Main deploy file that include all playbooks.

### Inventory
Inventory file contains list of mananged grouped nodes.

### tasks/
* access_by_ssh.yml - Task for configuring ssh access at the main host.
* iptables-rules.yml - Apply iptables rules, 
* flask_app.yml - install all needed packages and configure application,
* web_server.yml - Install and configure nginx.

### /group_vars/vault_vars.yml
File with encrypted passwords.
```sh
ansible-vault view --vault-password-file passfile /group_vars/vault_vars.yml
```

### /group_vars/variables.yml
Files with values of varaibles.


### /src/
In that directory you can find two files:
* emoji_app.service - file with the necessary parameters for the Flask service,
* nginx.conf - nginx configuration file. 

## Project check
To check deployed project try from localhost:
```s
curl https://127.0.0.1:80
curl -XPOST -H'Content-Type: application/json' -d'{"word":"just", "count": 5}' https://127.0.0.1:80
```
OR (from your own host to the target host)
```s
curl https://<host_ip>:80
curl -XPOST -H'Content-Type: application/json' -d'{"word":"just", "count": 5}' https://<host_ip>:80
```

### For example:
```bash
curl -XPOST -H 'Content-Type: application/json' -d'{"word":"cheesse", "count": 4}' http://192.168.10.202:80
💩cheesse💩cheesse💩cheesse💩cheesse💩
```
