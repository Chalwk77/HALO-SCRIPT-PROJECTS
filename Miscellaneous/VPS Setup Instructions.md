This is a step-by-step tutorial that covers the installation of a Ubnutu-Linux VPS with Wine and a VNC server for remote
connection.

The hosting company I will be using in this tutorial is [Vultr](https://www.vultr.com/).

# Prerequisite applications:

- [BitVise SSH Client](https://www.bitvise.com/ssh-client-download) (for remote access to the terminal).
- [FileZilla Client](https://filezilla-project.org/download.php?platform=win64) (to upload files via FTP to the VPS).
- [TightVNC (client)](https://www.tightvnc.com/download.php) (for remote desktop connections)
- Pre-Configured Halo servers:
-
    * [HCE.Multi-Server.zip](https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/releases/download/v1.0.7-Multi-Server/HCE.Multi-Server.zip)
      or [HPC.Multi-Server.zip](https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/releases/download/v1.0.7-Multi-Server/HPC.Multi-Server.zip)

#### Technical note on Vultr subscription plans:

You pay for whatever you need. However, you need at least 150 MiB *per server* to cover peak times. Multiply that by the
number of servers you need and that'll tell you much you should expect to pay. Also note that each plan allocates you a
defined amount of storage space. You may need more depending on how many maps you intend to upload.

## STEPS:

##### 1). Download and install [BitVise SSH Client](https://www.bitvise.com/ssh-client-download), [FileZilla Client](https://filezilla-project.org/download.php?platform=win64) and [TightVNC (client)](https://www.tightvnc.com/download.php).

##### 2). Select Cloud Compute and install Ubuntu-Linux (version **21.10 x64**).

##### 3). Open BitVise SSH Client:

- Fill in the host & username (get from VPS control panel).
- Click login.
- You will be prompted to accept and save a host key. Click accept and save.
- Enter your password (get from VPS control panel).
- Click the "New Terminal Console" button.

##### 4). Enter the following commands (in order):

*Add multiarch support:*
> sudo dpkg --add-architecture i386

*Add the WineHQ Ubuntu repository:*
> wget -nc https://dl.winehq.org/wine-builds/winehq.key

*Get and install the repository key:*
> sudo -H gpg -o /etc/apt/trusted.gpg.d/winehq.key.gpg --dearmor winehq.key

*Add the repository:*
> sudo add-apt-repository 'deb https://dl.winehq.org/wine-builds/ubuntu/ impish main'

*Update the package database:*
> sudo apt update

*Install Wine:*
> sudo apt install --install-recommends winehq-stable

*Verify the installation has succeeded:*
> wine --version

#### 5). Installing TightVNC Server:

*The graphical environment is not installed by default on server versions of Ubuntu. Therefore, if we want to connect to
a remote desktop, we need to install a graphical shell. Let’s install the TightVNC Server itself at the same time:*
> apt install xfce4 xfce4-goodies tightvncserver

*Start the TightVNC Server for the first time. It will create the files necessary for work and ask to create a
password.:
If you need to restrict remote desktop control, select a read-only password.*
> vncserver

*Now stop your TightVNC session to adjust other settings:*
> vncserver -kill :1

*Open the TightVNC config file with. Add the following line to the end:* **startxfce4**
> nano ~/.vnc/xstartup

#### 6). Setting up autorun:

*By default, TightVNC does not have a daemon and does not turn on after a system reboot. To fix this, let's create a new
unit in systemd:*
> nano /etc/systemd/system/vncserver.service

*Insert the following config there:*

```
[Unit]
Description=TightVNC server
After=syslog.target network.target

[Service]
Type=forking
User=root
PAMName=login
PIDFile=/root/.vnc/%H:1.pid
ExecStartPre=-/usr/bin/vncserver -kill :1 > /dev/null 2>&1
ExecStart=/usr/bin/vncserver -geometry 1920x1080
ExecStop=/usr/bin/vncserver -kill :1

[Install]
WantedBy=multi-user.target
```

*Reload systemd:*
> systemctl daemon-reload

*Enable autorun of the TightVNC server and start it.*
> systemctl enable --now vncserver

#### 7). Set up UFW (firewall)

*Allow port 5901 for incoming VNC connections:*
> ufw allow 5901/tcp

*Then allow UDP connections for Halo on ports 2302, 2303 and your server port(s), with:*

```
sudo ufw allow 2302/udp
sudo ufw allow 2303/udp
sudo ufw allow 2310/udp
sudo ufw allow 2311/udp
sudo ufw allow 2312/udp
```

*Optionally allow your IP Address and reject all others:
This will make it so that only the specified IP(s) can connect to the vnc server.*
> sudo ufw allow from 0.0.0.0 (replace 0.0.0.0 with your own ipv4 address)

*If you did the previous step, then we also need to reject other inbound connections:
If you didn't do the previous step, skip to the next step.*
> sudo ufw default reject incoming

*Next step - Enable the UFW:*
> sudo ufw enable

#### 8). Configure FileZilla:

- File -> Site manager -> New site
- Protocol: SFTP - SSH File Transfer Protocol
- Fill in host/user/password fields (get from VPS control panel).
- Save site and connect.

#### 9). Upload the extracted **HPC Multi-Server** or **HCE Multi-Server** folder to:

> /root/Desktop

Note: You will need a file decompression tool like [WinRAR](https://www.win-rar.com/start.html?&L=0)
or [7-zip](https://www.7-zip.org/download.html) to extract the HPC Multi-Server or HCE Multi-Server.
