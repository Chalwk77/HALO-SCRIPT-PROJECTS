# Halo 1 (PC/CE) Discord Bot (for SAPP servers)
_____

### Description:
A Discord bot framework built using the Discordia API and Luvit runtime environment for [SAPP SERVERS](https://opencarnage.net/index.php?/topic/6939-sapp-download/).

**Download at bottom of page**
___

### Installation:
The [Discordia API](https://github.com/SinisterRectus/Discordia) and [Luvit](https://luvit.io/install.html) environment are both required system packages.
Additionally, you will have to register an application on the [Discord Developer Portal](https://Discordapp.com/developers/applications/) and obtain a **bot token**.

A Discord bot token is a short phrase (represented as a jumble of letters and numbers) that acts as a key to controlling a Discord Bot.
Put your bot token inside the *./Discord Bot/Auth.data* file and **never** share your Discord bot token with anyone.

There are many tutorials online to help you learn how to create a Discord Application, however, as a general guide, follow these steps:

Click **New Application**
Provide a name for your bot and click create.
Click the **Bot** tab then click the blue *Add Bot* button (click *yes, do it!*, when prompted).
![img](https://i.imgur.com/kHgHBma.png)
Copy your token and paste it into the aforementioned Auth.data file located inside the Discord Bot folder.

Now click the OAuth2 tab and check the BOT scope.
Under bot permissions -> text permissions, check *Send Message*, *Embed Links*, *Use External Emojis* and *Add Reactions*.
![img](https://i.imgur.com/CFWg2Tp.png)
Copy and paste the URL that gets generated into a web browser and hit enter.

You will be prompted to add the bot to a Discord server, select one, click continue and authorize (see below).
![img](https://i.imgur.com/JH46SVZ.png)![img](https://i.imgur.com/UJmuYON.png)
You have now successfully added the Discord Application to your Discord server.


# **IMPORTANT**

The release zip contains:
* Discord.lua (sapp script)
* Discord Bot (folder)

See *Discord Bot/settings.lua* for full configuration.

**The Discord Bot folder itself MUST go in the servers root directory (the same folder where sapp.dll is located).**

Note: You will need a file decompression tool like [WinRAR](https://www.win-rar.com/start.html?&L=0) or [7-zip](https://www.7-zip.org/download.html) to extract the Discord.Bot.zip file (download at bottom of page).

If you need help installing on Linux (or Windows, for that matter), DM me on Discord:
Chalwk#9284

### **Launching the Discord Bot**
*For windows:*
Included inside the Discord Bot folder is a windows .batch script called **START BOT.bat**
Double click it and the bot will execute.

Alternatively, on Windows or Linux, open Command Prompt (terminal on Linux) and CD into the Discord Bot folder. Type **luvit main** and the bot will launch.
____

# BOT FEATURES:
### **Events**
_This bot will relay a message to your Discord server when the following events are fired:_
Event | Announcement Description
------------ | -------------
event_death|Killed by server, Squashed by vehicle, Run over, Betrayal, PVP, Suicide, Zombie-infect, First blood, Guardians, Killed from grave, Unknown.
event_join|Player connected to the server.
event_quit |Player disconnected from the server.
event_game_start|A new game starts (shows map & mode).
event_game_end|Current game mode ends (shows who won).
event_score|Message sent when player scores
event_chat|Global messages sent to defined global-channel.
event_command|Command logs sent to defined command-log channel.
> [note] The bot will ignore commands containing sensitive information (namely passwords).

## **Two-way chat integration**
*Send messages directly to the specified Halo server from Discord (and visa versa)*

**Discord to halo example, as seen in-game:**
###### [discord] Chalwk: Hi
**Halo to Discord example:**
###### [CHAT] Chalwk: Hi (halo to Discord)
*Please see [this video](https://youtu.be/V452t_wBAAw) for a brief demonstration.*

## **End Game results**
*Feedback the name of the winning player (or team) on Discord after each game.*
![img](https://i.imgur.com/P1AL6Oa.png)
![img](https://i.imgur.com/l15jWgG.png)

## **Server Status Messages**:
*The bot will automatically create and periodically edit an embedded status message.*
![img](https://i.imgur.com/KJpUf7w.png)


Discord Bot Avatar by Yalda Baoth

----