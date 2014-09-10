## pfmb - Multi site backup tool for pfSense
## by Greg Lawler
## v1.0 7/1/2014

This script will connect to one or more remote pfSense installs and backup the configuratin xml file.
With this file, you can restore an old config or easily replace failed hardware.

The script only works over SSH with SSH keys for secure authentication.

## Hosts config file ##
Each line of the config file should contain the hostname or IP of a pfSense router/firewall. 
Optionally follow the hostname with colon port numnber if SSH is not on the default TCP port 22.

Example hosts config file with three entries - note port 443 used on third entry:
192.168.5.1
office.example.com
207.76.123.123:443

## SSH setup on your side ##
If SSH keys are new to you, there are lots of good resources just a Google away ;)
Nonetheless, here is the quick version:
	- Run ssh-keygen from the command line on the [Mac / Linux] box doing the backups.
	- Copy the content from id_rsa.pub and paste it into the "Authorized keys" field in pfSense (see below.)

## SSH Setup on the pfSense box ##
Enable SSH:
	- Log into your pfSense via the web interface.
	- Advanced -> Secure Shell Server -> Check the "Enable Secure Shell" box.
	- Note the port, if this is not the default, you will need to specify it in the hosts config.
	- Save your changes.
Add a backup user and SSH key:
	- Log into your pfSense via the web interface.
	- System -> User Manager
	- Click the + to add new user.
	- Enter username and a secure password (you don't need to remember the password but it is required by the form.)
	- Full Name -> Enter "Backup User"
	- Click on "admins" under "Not Member Of" and move it to the "Memmber of" box to make your backup user an admin.
	- Authorized keys -> Check this box and paste in your SSH public key from above.
	- Save your changes.

## Testing your setup ##
If you can SSH into each pfSense box as the backup user without having to enter a password then you are ready to run the script.

## The backups ##
Backups are created with the host name (from the config file) followed by a timestamp.


Enjoy :)

Greg Lawler
