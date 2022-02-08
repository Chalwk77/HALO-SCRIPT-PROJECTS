#### This is a step-by-step tutorial that covers the installation of a Ubnutu-Linux VPS with Wine and a VNC server for remote connection.
#### The hosting company I will be using in this tutorial is [Vultr](https://www.vultr.com/).

# Prerequisite applications:

- [BitVise SSH Client](https://www.bitvise.com/ssh-client-download) (for remote access to the terminal).
- [FileZilla Client](https://filezilla-project.org/download.php?platform=win64) (to upload files via FTP to the VPS).
- [TightVNC (client)](https://www.tightvnc.com/download.php) (for remote desktop connections)
- Pre-Configured Halo servers (these are compatible with Linux):
-
    * [HCE.Multi-Server.zip](https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/releases/download/v1.0.7-Multi-Server/HCE.Multi-Server.zip) or [HPC.Multi-Server.zip](https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/releases/download/v1.0.7-Multi-Server/HPC.Multi-Server.zip)

#### Technical note on [Vultr](https://www.vultr.com/) subscription plans:
You pay for whatever you need. However, you need at least 150 MiB *per server* to cover peak times. Multiply that by the
number of servers you need and that'll tell you much you should expect to pay. Also note that each plan allocates you a
defined amount of storage space. You may need more depending on how many maps you intend to upload.

## STEPS:

### 1). Download the pre-configured Multi-Server (linked above).
Note: You will need a file decompression tool like [WinRAR](https://www.win-rar.com/start.html?&L=0)
or [7-zip](https://www.7-zip.org/download.html) to extract the HPC Multi-Server or HCE Multi-Server.

### 2). Download and install [BitVise SSH Client](https://www.bitvise.com/ssh-client-download), [FileZilla Client](https://filezilla-project.org/download.php?platform=win64) and [TightVNC (client)](https://www.tightvnc.com/download.php).

### 3). Select Cloud Compute and install Ubuntu-Linux (version **21.10 x64**).

### 4). Open BitVise SSH Client:
- Fill in the host & username (get from VPS control panel).
- Click login.
- You will be prompted to accept and save a host key. Click accept and save.
- Enter your password (get from VPS control panel).
- Click the "New Terminal Console" button.

### 5). Enter the following commands (in order):
Command | Description
-- | --
sudo dpkg --add-architecture i386|Add multiarch support
wget -nc https://dl.winehq.org/wine-builds/winehq.key|Add the WineHQ Ubuntu repository
sudo -H gpg -o /etc/apt/trusted.gpg.d/winehq.key.gpg --dearmor winehq.key|Get and install the repository key.
sudo add-apt-repository 'deb https://dl.winehq.org/wine-builds/ubuntu/ impish main'|Add the repository.
sudo apt update|Update the package database.
sudo apt install --install-recommends winehq-stable|Install Wine.
wine --version|Verify the installation has succeeded.

### 6). Installing TightVNC Server:
Command | Description
-- | --
apt install xfce4 xfce4-goodies tightvncserver|The graphical environment is not installed by default on server versions of Ubuntu.<br/>Therefore, if we want to connect to a remote desktop, we need to install a graphical shell.<br/>Let’s install the TightVNC Server itself at the same time.
vncserver|Start the TightVNC Server for the first time.<br/>It will create the files necessary for work and ask to create a password.<br/>If you need to restrict remote desktop control, select a read-only password.
ncserver -kill :1|Now stop your TightVNC session to adjust other settings:
nano ~/.vnc/xstartup|Open the TightVNC config file.<br/><br/>*Add the following line to the end:*<br/>**startxfce4**<br/><br/>**Technical note: To save and exit nano screen, press CTRL-S (save), CTRL-X (exit).**

### 7). Setting up autorun:
Command | Description
-- | --
nano /etc/systemd/system/vncserver.service|By default, TightVNC does not have a daemon and does not turn on after a system reboot.<br/>To fix this, let's create a new unit in systemd.<br/><br/>**Technical note: To save and exit nano screen, press CTRL-S (save), CTRL-X (exit).**<br/><br/>*Insert the following config there:*<br/>**[Unit]<br/>Description=TightVNC server<br/>After=syslog.target network.target<br/><br/>[Service]<br/>Type=forking<br/>User=root<br/>PAMName=login<br/>PIDFile=/root/.vnc/%H:1.pid<br/>ExecStartPre=-/usr/bin/vncserver -kill :1 > /dev/null 2>&1<br/>ExecStart=/usr/bin/vncserver -geometry 1920x1080<br/>ExecStop=/usr/bin/vncserver -kill :1<br/><br/>[Install]<br/>WantedBy=multi-user.target**
systemctl daemon-reload|Reload systemd
systemctl enable --now vncserver|Enable autorun of the TightVNC server and start it.

### 8). Set up UFW (firewall)
Command | Description
-- | --
ufw allow 5901/tcp|Allow port 5901 for incoming VNC connections:
sudo ufw allow 2302:2303/udp|Then allow UDP connections for Halo on ports 2302, 2303
sudo ufw allow 2310:2312/udp|Then allow UDP connections for server ports
sudo ufw allow from 0.0.0.0|Optionally allow your IP Address and reject all others.<br/>This will make it so that only the specified IP(s) can connect to the vnc server.<br/><br/>Replace 0.0.0.0 with your own ipv4 address.
sudo ufw default reject incoming|If you did the previous step, then we also need to reject other inbound connections. If you didn't do the previous step, skip to the next command.
sudo ufw enable|Enable the UFW

### 9). Change SSH Port:
Command | Description
-- | --
nano /etc/ssh/sshd_config|By default, SSH listens on port 22.<br/>Changing the default SSH port adds an extra layer of security to your server by reducing the risk of automated attacks.<br/><br/>To change the default SSH port in Ubuntu, Open the **sshd_config** file and execute this command.<br/><br/>**Technical note: To save and exit nano screen, press CTRL-S (save), CTRL-X (exit).**<br/><br/>*Locate this line:*<br/>**#Port 22**<br/><br/>*Uncomment (remove the leading # character) it and change the value with an appropriate port number (for example, 22000):*<br/>**Port 22000**
systemctl restart sshd|Restart the SSH server
netstat -tulpn \| grep ssh|After that, run the netstat command and make sure that the ssh daemon now listen on the new ssh port
sudo ufw allow 22000/tcp|Add a rule to allow new SSH port.<br/>Furthermore, future SSH connections with BitVise will require you to specify the port in the port field.

### 10). Configure FileZilla:

- File -> Site manager -> New site
- Protocol: SFTP - SSH File Transfer Protocol
- Fill in host/user/password/port fields (get user/pass from VPS control panel, port is SSH port)
- Save site and connect.

### 11). Upload the extracted **HPC Multi-Server** or **HCE Multi-Server** folder to:

> /root/Desktop
