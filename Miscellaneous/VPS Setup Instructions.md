This is a step-by-step tutorial that covers the installation of a Ubnutu-Linux VPS with Wine and a VNC server for remote
connection.

The hosting company I will be using in this tutorial is [Vultr](https://www.vultr.com/).

# Prerequisite applications:

- [BitVise SSH Client](https://www.bitvise.com/ssh-client-download) (for remote access to the terminal).
- [FileZilla Client](https://filezilla-project.org/download.php?platform=win64) (to upload files via FTP to the VPS).
- [TightVNC (client)](https://www.tightvnc.com/download.php) (for remote desktop connections)
- Pre-Configured Halo servers (these are compatible with Linux):
-
    * [HCE.Multi-Server.zip](https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/releases/download/v1.0.7-Multi-Server/HCE.Multi-Server.zip)
      or [HPC.Multi-Server.zip](https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/releases/download/v1.0.7-Multi-Server/HPC.Multi-Server.zip)

#### Technical note on [Vultr](https://www.vultr.com/) subscription plans:
You pay for whatever you need. However, you need at least 150 MiB *per server* to cover peak times. Multiply that by the
number of servers you need and that'll tell you much you should expect to pay. Also note that each plan allocates you a
defined amount of storage space. You may need more depending on how many maps you intend to upload.

## STEPS:

##### 1). Download the pre-configured Multi-Server (linked above).
Note: You will need a file decompression tool like [WinRAR](https://www.win-rar.com/start.html?&L=0)
or [7-zip](https://www.7-zip.org/download.html) to extract the HPC Multi-Server or HCE Multi-Server.

---
##### 2). Download and install [BitVise SSH Client](https://www.bitvise.com/ssh-client-download), [FileZilla Client](https://filezilla-project.org/download.php?platform=win64) and [TightVNC (client)](https://www.tightvnc.com/download.php).

---
##### 3). Select Cloud Compute and install Ubuntu-Linux (version **21.10 x64**).

---
##### 4). Open BitVise SSH Client:

- Fill in the host & username (get from VPS control panel).
- Click login.
- You will be prompted to accept and save a host key. Click accept and save.
- Enter your password (get from VPS control panel).
- Click the "New Terminal Console" button.

---
##### 5). Enter the following commands (in order):

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

---
#### 6). Installing TightVNC Server:

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

---
#### 7). Setting up autorun:

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

---
#### 8). Set up UFW (firewall)

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

*If you did the previous step, then we also need to reject other inbound connections. If you didn't do the previous
step, skip to the next step.*
> sudo ufw default reject incoming

*Next step - Enable the UFW:*
> sudo ufw enable

---
#### 9). Change SSH Port:

By default, SSH listens on port 22. Changing the default SSH port adds an extra layer of security to your server by
reducing the risk of automated attacks. The following command is used to check the current configuration:
> netstat -tulnp | grep ssh

The Port directive of the sshd_config file specifies the port number that ssh server listens on. You can check the
current configuration with following command:
The Port directive is commented out by default, which means SSH daemon listens on the default port 22.
> grep -i port /etc/ssh/sshd_config

If you want to change the default SSH port in Ubuntu, perform the following steps with root privileges:

- Open the /etc/ssh/sshd_config file with the following command:

> nano /etc/ssh/sshd_config

Locate this line:

```none
#Port 22
```

- Then, uncomment (Remove the leading # character) it and change the value with an appropriate port number (for example,
  22000):

```none
Port 22000
```

- Restart the SSH server:
> systemctl restart sshd

After that, run the netstat command and make sure that the ssh daemon now listen on the new ssh port:
> netstat -tulpn | grep ssh

When connecting to the server using the ssh command, you need to specify the port to connect using the -p flag:
> ssh -p 22000 192.168.1.100

Note that if the Firewall is enabled, you need to add a rule to allow new SSH port:
> sudo ufw allow 22000/tcp

---
#### 10). Configure FileZilla:

- File -> Site manager -> New site
- Protocol: SFTP - SSH File Transfer Protocol
- Fill in host/user/password fields (get from VPS control panel).
- Save site and connect.

---
#### 11). Upload the extracted **HPC Multi-Server** or **HCE Multi-Server** folder to:

> /root/Desktop
