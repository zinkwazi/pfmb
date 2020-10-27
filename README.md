## pfSense Multi site backup tool - pfmb.sh
by Greg Lawler
v1.5 10/26/2020

## About pfmb
pfmb will connect to one or many remote pfSense installs and backup the configuration XML file.
The resulting backup will enable you to easily go back to a previous configuration or replace failed hardware.
pfmb will keep the number of backups that you specify in config, rotating out the old ones.

The script works over SSH with SSH public keys for secure authentication and transport.

## Hosts config file ##
Each line of the config file should contain the hostname or IP of a pfSense router/firewall. 
Optionally follow the hostname with colon port numnber if SSH is not on the default TCP port 22.

Format of the hosts.conf entries `<username>@<hostname>:<port>:<description>`

##### Example hosts.conf file with 3 entries. Note the first entry with non-standard SSH port:
```
10.10.1.1:80
10.11.1.1:8100:pfsense2
pfsense.example.com
207.123.123.4
10.20.1.1::pfsense
user@pfsense2.example.com
```

## Scheduled backups ##
Add the following to the crontab for your backup user to run the script regularly.

```0 6,12 * * * pfmb | logger -t pfsense_backup```

## SSH setup on your side ##
If SSH keys are new to you, there are lots of good resources just a Google away ;)

##### Nonetheless, here is the quick version:
- Run ssh-keygen from the command line on the [Mac / Linux] computer doing the backups.
- Copy the content from .ssh/id_rsa.pub and paste it into the "Authorized keys" field in pfSense (see below.)

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

Enjoy :)

Greg Lawler
Initial release: 7/1/14
