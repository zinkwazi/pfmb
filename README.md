## pfSense Multi site backup tool - pfmb.sh
## by Greg Lawler
## v1.2 11/02/2018

pfmb will connect to one or more remote pfSense installs and backup the configuration XML file.
The resulting backup will enable you to roll back to a previous configuration or replace failed hardware.
pfmb will keep the number of backups that you specify in config, rotating out the old ones.

The script works over SSH with SSH public keys for secure authentication and transport.

## Hosts config file ##
Each line of the config file should contain the hostname or IP of a pfSense router/firewall. 
Optionally follow the hostname with colon port numnber if SSH is not on the default TCP port 22.

Format of the hosts.conf entries `<hostname>:<port>:<description>`

##### Example hosts.conf file with 3 entries. Note the first entry with non-standard SSH port:
    10.10.1.1:80
    10.11.1.1:8100:pfsense2
    pfsense.example.com
    207.123.123.4
    10.20.1.1::pfsense

## SSH setup on your side ##
If SSH keys are new to you, there are lots of good resources just a Google away ;)

##### Nonetheless, here is the quick version:
- Run ssh-keygen from the command line on the [Mac / Linux] box doing the backups.
- Copy the content from id_rsa.pub and paste it into the "Authorized keys" field in pfSense (see below.)

##### Setup your ~/.ssh/config file to pass the correct identity for your backup user:
```
Host *
    User backup
    IdentityFile ~/.ssh/backup-user.rsa
```

## SSH Setup on the pfSense box ##

##### Enable SSH:
- Log into your pfSense via the web interface.
- Advanced -> Secure Shell Server -> Check the "Enable Secure Shell" box.
- Note the port, if this is not the default, you will need to specify it in the hosts config.
- Save your changes.

##### Add a backup user and SSH key:

- Log into your pfSense via the web interface.
- System -> User Manager
- Click the + to add new user.
- Enter username and a secure password (you don't need to remember the password but it is required by the form.)
- Full Name -> Enter "Backup User"
- Click on "admins" under "Not Member Of" and move it to the "Member of" box to make your backup user an admin.
- Authorized keys -> Check this box and paste in your SSH public key from above.
- Save your changes.

## Testing your setup ##
If you can SSH into each pfSense box as the backup user without having to enter a password then you are ready to run the script.

## The backups ##
Backups are created from the description and host name (from the config file) followed by a timestamp.

## Pushover Alerts ##
Create a new Application/Plugin on [Pushover](https://pushover.net/apps/build)

Edit /etc/pfmb/pushover.sh and add your newly created Pushover Token and User Keys into the TOKEN and USER sections at the top.

Enjoy :)

Greg Lawler
