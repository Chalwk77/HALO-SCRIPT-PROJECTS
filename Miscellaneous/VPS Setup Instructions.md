# Prerequisite applications:

[BitVise SSH Client](https://www.bitvise.com/ssh-client-download) (for remote access to the terminal)

[FileZilla Client](https://filezilla-project.org/download.php?platform=win64) (to upload files via FTP to the VPS)

## STEPS:

### 1). Download and install "BitVise SSH Client" and "FileZilla Client".

### 2). Install Ubuntu, Linux (version 21.10x64).

### 3). Open BitVise SSH Client.
- Fill in the host/username/password fields (get from VPS control panel).
- Click the "New Terminal Window" button.

### 4). Enter the following commands (in order):
- sudo dpkg --add-architecture i386

> Add the WineHQ Ubuntu repository.
- wget -nc https://dl.winehq.org/wine-builds/winehq.key

> Get and install the repository key.
- sudo -H gpg -o /etc/apt/trusted.gpg.d/winehq.key.gpg --dearmor winehq.key

> Add the repository.
- sudo add-apt-repository 'deb https://dl.winehq.org/wine-builds/ubuntu/ impish main'

> Update the package database.
- sudo apt update

> Install Wine.
> The next command will install Wine Stable. If you prefer Wine Development or Wine Staging, replace winehq-stable with either winehq-devel or with winehq-staging.
- sudo apt install --install-recommends winehq-stable

> Verify the installation succeeded
- wine --version

### 5). Installing TightVNC Server.

> The graphical environment is not installed by default on server versions of Ubuntu. Therefore, if we want to connect to a remote desktop, we need to install a graphical shell. Let’s install the TightVNC Server itself at the same time.
- apt install xfce4 xfce4-goodies tightvncserver

> Let's start the TightVNC Server for the first time. It will create the files necessary for work and ask to create a password.
> If you need to restrict remote desktop control, select a read-only password.

- vncserver

> Now stop your TightVNC session to adjust other settings.

- vncserver -kill :1

> Open the TightVNC config file with:

- nano ~/.vnc/xstartup

> Add the following line to the end:

- startxfce4

> Start the server again:

- vncserver

### 6). Setting up autorun.

> By default, TightVNC does not have a daemon and does not turn on after a system reboot. To fix this, let's create a new unit in systemd.

- nano /etc/systemd/system/vncserver.service

> Insert the following config there:

```diff
[Unit]
Description=TightVNC server
After=syslog.target network.target

[Service]
Type=forking
User=root
PAMName=login
PIDFile=/root/.vnc/%H:1.pid
ExecStartPre=-/usr/bin/vncserver -kill :1 > /dev/null 2>&1
ExecStart=/usr/bin/vncserver
ExecStop=/usr/bin/vncserver -kill :1

[Install]
WantedBy=multi-user.target
```

> Reload systemd:

- systemctl daemon-reload

> Enable autorun of the TightVNC server and start it.

- systemctl enable --now vncserver

## 6). Upload the **HPC Multi-Server** folder to /root/Desktop
