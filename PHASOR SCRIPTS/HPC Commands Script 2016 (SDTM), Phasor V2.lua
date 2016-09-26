--[[
->-<->-<->-<->-<->-<->-<->-<->-<->-<->-<->-<- ] COMMANDS SCRIPT 2016 [ ->-<->-<->-<->-<->-<->-<->-<->-<->-<->-<->-<-

Description: HPC Commands Script 2016 (SDTM), Phasor V2+
* Author: Jericho Crosby
* IGN (in game name): Chalwk
* Re-Written and heavily modified by Jericho Crosby

* Credits to the original creator(s):
	- AelitePrime, Wizard, and Nuggets.
    - Base script created 'Smiley' (v 1.0)

													+++ WARNING - WARNING - WARNING +++
										DO NOT TOUCH ANYTHING UNLESS YOU KNOW WHAT YOUR'RE DOING
===========================================================================================================================================================================	
]]

-- Prefix Globals --
default_script_prefix = ""
phasor_privatesay = privatesay
phasor_say = say

-- Auto Message Board --
local Announce_Message = "<obsolete>"

-- Counts --
-- Game_Timer = 0
local Current_Players = 0
local IP_BanID = 0
local IpRange_BanID = 0
local RCON_Passwords_ID = 0
local RTV_Timout = 1
local TextBanID = 0
local UNIQUES = 0
local Admin_Count = 0

-- Booleans --
local NotYetShown = true
local RTV_Initiated = 0
local VoteKickTimeout_Table = false
local authorized = false

-- Strings --
local RCUserName = 'chalwk'
local RCPassword = 'ruevenpro'
local LocalIp = '192.168.0.9'
local PublicIp = '121.73.221.100'
local Script_Version = 'v7.5'
local processid = ""
local SandBox_Password = ""

-- Tables --
Access_Table = { }
Admin_Table = { }
afk = { }
Banned_Hashes = { }
Bos_Table = { }
BosLog_Table = { }
crouch = { }
Control_Table = { }
dmgmultiplier = { }
follow = { }
hidden = { }
gods = { }
Ghost_Table = { }
IpAdmins = { }
IP_BanList = { }
IpRange_BanList = { }
loc = { }
mode = { }
Mute_Table = { }
Mute_Banlist = { }
Name_Bans = { }
nukes = { }
Noweapons = { }
Slayer_Score = { }
Spam_Table = { }
SpamTimeOut_Table = { }
Players_List = { }
Player_Ping = { }
Suspend_Table = { }
objects = { }
objspawnid = { }
RCON_PASSWORDS = { }
RTV_TABLE = { }
tbag = { }
Temp_Admins = { }
Unique_Table = { }
Vehicle_Drone_Table = { }
Victim_Coords = { }
VoteKick_Table = { }
VIP_LIST = { }
vip = { }
GRAVITY = { }
vehicles = { }
activetime = { }
No_PMs = { }
Kill_Command_Count = { }
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
KeyTerms = { }
KeyTerms.cussing = { "cuss", "cussing", "swear", "swearing", "profanity", "language" }
KeyTerms.glitching = { "glitching", "glitch", "behind walls", "out of map" }
KeyTerms.harassment = { "harassing", "said i", "told me", "said he", "said she", "won't leave me alone" }
KeyTerms.recruiting = { "recruiting", "recruit", "recruitment" }
KeyTerms.trolling = { "troll", "trolling" }
KeyTerms.spamming = { "spam", "spamming", "repeating" }
KeyTerms.teamshooting = { "teamshooting", "shooting team", "shooting me" }
KeyTerms.ping = { "ping", "lagging", "lag" }
KeyTerms.hacking = { "hacking", "hack", "botting", "using a bot", "aimbot", "wallhack", "wall hack", "wireframe", "wire frame", "sightjack", "sight jack", "sight jacker", "sightjacker" }

commands_table = {
    "/a",
    "/ipadminadd",-- Added Variables
    "/ipadmindelete",
    "/afk",-- Added Variables
    "/alias",-- Added Variables
    "/ammo",-- Added Variables
    "/b",
    "/bos",-- Added Variables
    "/boslist",-- Added Variables
    "/bosplayers",-- Added Variables
    "/banlist",
    "/balance",
    "/deathless",
    "/dmg",
    "/cmds",
    "/count",-- Added Variables
    "/c",
    "/e",
    "/crash",-- Added Variables
    "/eject",-- Added Variables
    "/enter",-- Added Variables
    "/falldamage",-- Added Variables
    "/f",
    "/getloc",-- Added Variables
    "/god",
    "/getip",-- Added Variables
    "/hax",
    "/heal",
    "/hitler",
    "/infammo",
    "/give",-- Added Variables
    "/gethash",-- Added Variables
    "/hide",
    "/invis",
    "/info",
    "/ipban",-- Added Variables
    "/ipbanlist",-- Added Variables
    "/ipunban",-- Added Variables
    "/iprangeban",-- Added Variables
    "/iprangebanlist",-- Added Variables
    "/iprangeunban",-- Added Variables
    "/j",
    "/k",-- Added Variables
    "/kill",
    "/lo3",
    "/launch",
    "/m",
    "/mc",
    "/mnext",-- Added Variables
    "/mute",
    "/nuke",
    "/noweapons",-- Added Variables
    "/nameban",
    "/namebanlist",
    "/nameunban",
    "/os",
    "/pvtsay",-- Added Variables
    "/privatesay",
    "/pl",-- Added Variables
    "/players",
    "/read",
    "/reset",
    "/resp",
    "/revoke",
    "/resetplayer",-- Added Variables
    "/resetweapons",-- Added Variables
    "/say",-- Added variables
    "/setammo",
    "/setassists",
    "/setcolor",
    "/setdeaths",
    "/setfrags",
    "/setgrenades",
    "/setkills",
    "/setmode",-- Added "Gravity Gun".
    "/setresp",
    "/respawntime",
    "/setscore",-- Added Variables
    "/setplasmas",
    "/spd",
    "/spawn",-- Added Variables
    "/specs",
    "/superban",
    "/suspend",-- Added Variables
    "/timelimit",
    "/takeweapons",-- Added Variables
    "/textban",-- Added Variables
    "/textbanlist",-- Added Variables
    "/textunban",-- Added Variables
    "/tp",
    "/ts",-- Added Variables
    "/unban",
    "/unbos",
    "/unhide",
    "/ungod",
    "/unhax",
    "/uninvis",
    "/unmute",-- Added Variables
    "/unsuspend",
    "/viewadmins",-- Added Variables
    "/write",-- Added Variables
    "/suicide",-- Added Variables
    "/idle",
    "/back",
    "/sandbox",
    "/unsandbox",
    "/pm",
    "/getlocation",-- Added Variables
}

command_access = {
    "sv_k",-- Added Variables
    "sv_b",
    "sv_crash",
    "sv_ipban",-- Added Variables
    "sv_iprangeban",
    "sv_nameban",
    "sv_superban",
    "sv_kick",-- Added Variables
    "sv_ban",
}

DEFAULTTXT_COMMANDS = {
    "sv_adminblocker 0",
    "sv_anticaps false",
    "sv_antispam all",
    "sv_chatcommands true",
    "sv_deathless false",
    "sv_falldamage true",
    "sv_firstjoin_message false",
    "sv_hash_duplicates true",
    "sv_infinite_ammo false",
    "sv_killspree false",
    "sv_multiteam_vehicles true",
    "sv_noweapons false",
    "sv_pvtmessage true",
    "sv_respawn_time default",
    "sv_rtv_enabled true",
    "sv_rtv_needed 0.6",
    "sv_serveradmin_message true",
    "sv_scrimmode false",
    "sv_spammax 7",
    "sv_spamtimeout 1",
    "sv_tbagdet true",
    "sv_uniques_enabled false",
    "sv_votekick_enabled false",
    "sv_votekick_needed 0.7",
    "sv_votekick_action kick",
    "sv_welcomeback_message false",
    "sv_player_reporting true",
}
-- Added Variables
SCRIM_MODE_COMMANDS = {
    "crash",
    "cheat_hax",
    "deathless",
    "enter",
    "eject",
    "falldamage",
    "follow",
    "setgod",
    "god",
    "dmg",
    "damage",
    "heal",
    "hide",
    "hitler",
    "hax",
    "infinite_ammo",
    "infammo",
    "kill",
    "move",
    "j",
    "os",
    "resetweapons",
    "resp",
    "spawn",
    "give",
    "setammo",
    "setassists",
    "setcolor",
    "setdeaths",
    "setfrags",
    "setkills",
    "setmode",
    "setscore",
    "setplasmas",
    "setspeed",
    "spd",
    "suspend",
    "takeweapons",
    "teleport_pl",
    "tp",
    "time_cur",
}

JOIN_MESSAGE_TABLE = {
    "Welcome to Chalw's Realm",
    "Snipers Dream Team Mod",
}

HYPER_SPACE_INFORMATION_TABLE = {
    "* Hyper-Space *",
    "(1) Press your flashlight Button to activate Hyper-Jumping!",
    "(2) Use them wisely, you only get 3 Hyper Jumps per life",
    "(3) You can Hyper Jump in or out of a vehicle.",
}

INFORMATION_MESSAGE_TABLE = {
    "Server Mods Information:",
    "* Snipers: Fire Explosive Rounds: 10ft Splash-Damage Radius",
    "* Pistols: Can fire blank rounds",
    "- Empty your pistol mag completely to fire blank rounds. (suppressed rounds)",
    "* Highly Customized Portals: Designated with Blue Cubes & Health Packs.",
    "* Advanced Spawn Protection: Including customized spawn locations and powerups.",
    "* Three RHog-Triggerd-Portals on the mountains: Passengers seat triggers them.",
    "* Rewarded with cookies when you pick up a flag.",
    "* Rewarded with cookies when you activate an RHog-Triggerd-Portal.",
    "* Advanced Anti-Spawn Killing Mechanisms.",
}

ZOMBIE_INFORMATION_TABLE = {
    "Server Information:",
    "* Type @info for a list of commands you'll need for Zombies and Vehicles!",
    "* This server runs a Statistics System",
    "* ",
    "* ",
    "* ",
    "* ",
}

_commands = "@commands "
_players = "@players "
_rules = "@rules "
_info = "@info "
_suicide = "@suicide "
_report = "@report "
_player = "@[player #] "
_zombie = "@zombie "
PLAYER_COMMANDS = {
    "Available Player Commands:",
    "\"" .. _zombie .. "\"" .. " = Display a list of information about our zombie server!",
    "\"" .. _commands .. "\"" .. ", \"" .. _players .. "\"" .. "  = Display list of players!, \"" .. _player .. "\"" .. " (message)  =  in-game private message.",
    "\"" .. _report .. "\"" .. " [player #] (reason) = Report Problem players.",
    "\"" .. _rules .. "\"" .. " = Display list of server rules, \"" .. _info .. "\"" .. " = Display list of info about the current gamemode.",
    "\"" .. _suicide .. "\"" .. " = If you're stuck, type @suicide to respawn yourself.",
}

RULES_TABLE = {
    "                              * * S E R V E R - R U L E S * *                         ",
    "(1)  Be polite, no excessive swearing or verbal abuse or harassing other players, and strictly No racism!",
    "(2)  No exploiting the game or map glitches and bugs. - Stay inside of the normal game play boundaries.",
    "(3)  Do not show or tell other players how to glitch/exploit. This can result in a ban.",
    "(4)  No Recruiting in OWV servers, and make sure to comply with an Admins directive",
    "(5)  No spamming, or senselessly flooding the chat in any way. No attacking, moving or destroying team mates vehicles.",
    "(6)  And No team swapping during the middle of a round with the intent of being on the winning team.",
}
http = require("socket.http")
function valid_ip(ip)
    local chunks = { ip:match("(%d+)%.(%d+)%.(%d+)%.(%d+)") }
    if (#chunks == 4) then
        for _, v in pairs(chunks) do
            if (tonumber(v) < 0 or tonumber(v) > 255) then
                return false
            end
        end
        return true
    else
        return false
    end
end

function GetRequiredVersion() return 200 end
function OnScriptLoad(process, game, persistent)
    if game == "CE" then
        address = 0x5A91A0
    elseif game == "PC" then
        address = 0x625230
    end
    --[[	
	local b, c, h = http.request("http://phasor.spartansofhonor.com/ip.php")
	if valid_ip(tostring(b)) == true then
			ServerIP = (b)=
		else
			hprintf("The request for the server IP Address returned an error.")
    end
]]
    ghost_mapId = gettagid("vehi", "vehicles\\ghost\\ghost_mp")
    rhog_mapId = gettagid("vehi", "vehicles\\rwarthog\\rwarthog")
    hog_mapId = gettagid("vehi", "vehicles\\warthog\\mp_warthog")
    banshee_mapId = gettagid("vehi", "vehicles\\banshee\\banshee_mp")
    turret_mapId = gettagid("vehi", "vehicles\\c gun turret\\c gun turret_mp")
    tank_mapId = gettagid("vehi", "vehicles\\scorpion\\scorpion_mp")
    processid = process
    Persistent = persistent
    profilepath = getprofilepath()
    requestprefex = "<gelocation website not available>"
    -- CheckForUpdates()
    local file = io.open(string.format("%s\\data\\auth_" .. tostring(process) .. ".key", profilepath), "r")
    if file then
        server_id = file:read("*line")
        for line in file:lines() do
            local words = tokenizestring(line, ",")
            server_token = words[1]
            server_id = words[2]
        end
    else
        server_id = authorizeserver()
    end
    -------------------------------------------------------------------------
    server_id = authorizeserver()
    -- SyncAdmins()
    server_name = getservername()
    local file = io.open("temp_" .. tostring(process) .. ".tmp", "r")
    if file and process then
        file:close()
        NotYetShown = false
        registertimer(0, "DefaultSvTimer", "temp_" .. process .. ".tmp")
    else
        NotYetShown = false
        registertimer(0, "DefaultSvTimer", "Defaults.txt")
    end
    if game == true or game == "PC" then
        GAME = "PC"
    else
        GAME = "CE"
    end
    GetGameAddresses(GAME)
    writeword(special_chars, 0x9090)
    writeword(gametype_patch, 0xEB)
    writeword(devmode_patch1, 0x9090)
    writeword(devmode_patch2, 0x9090)
    gametype = readbyte(gametype_base + 0x30)
    Game_Mode = readstring(gametype_base, 0x2C)
    if game == "PC" then
        gametype_base = 0x671340
    elseif game == "CE" then
        gametype_base = 0x5F5498
    end
    maintimer = registertimer(20, "MainTimer")
    team_play = getteamplay()
    for i = 0, 15 do
        if getplayer(i) then
            local ip = getip(i)
            Current_Players = Current_Players + 1
            afk[i + 1] = { }
            tbag[i] = { }
            dmgmultiplier[ip] = 1.0
        end
        gameend = false
        Vehicle_Drone_Table[i] = { }
        Players_List[i] = { }
        afk[i + 1] = { }
        loc[i + 1] = { }
        Control_Table[i + 1] = { }
    end
    local file = io.open(string.format("%s\\IP Ban List.txt", profilepath), "r")
    if file then
        for line in file:lines() do
            local words = tokenizestring(line, ",")
            IP_BanList[tostring(words[2])] = { }
            local time = tonumber(words[3]) or -1
            table.insert(IP_BanList[tostring(words[2])], { ["name"] = words[1], ["ip"] = words[2], ["time"] = time, ["id"] = IP_BanID })
            IP_BanID = IP_BanID + 1
        end
        file:close()
    end
    local file = io.open(string.format("%s\\IP Range Ban List.txt", profilepath), "r")
    if file then
        for line in file:lines() do
            local words = tokenizestring(line, ",")
            IpRange_BanList[tostring(words[2])] = { }
            local time = tonumber(words[3]) or -1
            table.insert(IpRange_BanList[tostring(words[2])], { ["name"] = words[1], ["ip"] = words[2], ["time"] = time, ["id"] = IpRange_BanID })
            IpRange_BanID = IpRange_BanID + 1
        end
        file:close()
    end
    local file = io.open(string.format("%s\\Text Ban List.txt", profilepath), "r")
    if file then
        for line in file:lines() do
            local words = tokenizestring(line, ",")
            Mute_Banlist[tostring(words[3])] = { }
            local time = tonumber(words[4]) or -1
            table.insert(Mute_Banlist[tostring(words[3])], { ["name"] = words[1], ["hash"] = words[2], ["ip"] = words[3], ["time"] = time, ["id"] = TextBanID })
            TextBanID = TextBanID + 1
        end
        file:close()
    end
    local file = io.open(string.format("%s\\Name Bans.txt", profilepath), "r")
    if file then
        for line in file:lines() do
            table.insert(Name_Bans, line)
        end
        file:close()
    end
    local file = io.open(string.format("Change Log_" .. Script_Version .. ".txt"), "r")
    if file then
        changelog = true
        file:close()
    else
        WriteChangeLog()
    end
    local file = io.open(string.format("%s\\Admin.txt", profilepath), "r")
    if file then
        for line in file:lines() do
            local words = tokenizestring(line, ",")
            if #words >= 3 and tonumber(words[3]) then
                if not Admin_Table then Admin_Table = { } end
                if not Admin_Table[words[2]] then Admin_Table[words[2]] = { } end
                Admin_Table[words[2]].name = words[1]
                Admin_Table[words[2]].level = words[3]
            end
            if #words == 4 and tonumber(words[3]) then
                if not IpAdmins[words[4]] then IpAdmins[words[4]] = { } end
                IpAdmins[words[4]].name = words[1]
                IpAdmins[words[4]].level = words[3]
            end
        end
        file:close()
    end
    local file = io.open(string.format("%s\\Admins.txt", profilepath), "r")
    if file then
        for line in file:lines() do
            local words = tokenizestring(line, ",")
            if not Admin_Table[words[2]] then Admin_Table[words[2]] = { } end
            Admin_Table[words[2]].name = words[1]
            Admin_Table[words[2]].level = words[3]
            if #words == 4 and tonumber(words[3]) then
                if not IpAdmins[words[4]] then IpAdmins[words[4]] = { } end
                IpAdmins[words[4]].name = words[1]
                IpAdmins[words[4]].level = words[3]
            end
        end
        file:close()
    end
    local file = io.open(profilepath .. "\\IP Admins.txt", "r")
    if file then
        for line in file:lines() do
            local words = tokenizestring(line, ",")
            if #words == 3 and tonumber(words[3]) then
                if not IpAdmins[words[2]] then IpAdmins[words[2]] = { } end
                IpAdmins[words[2]].name = words[1]
                IpAdmins[words[2]].level = words[3]
            end
        end
        file:close()
    end
    local ACCESS_LEVELS = 0
    local datas = 0
    local file = io.open(string.format("%s\\Access.ini", profilepath), "r")
    if file then
        for line in file:lines() do
            if string.sub(line, 1, 1) == "[" then
                ACCESS_LEVELS = ACCESS_LEVELS + 1
            elseif string.sub(line, 1, 4) == "data" then
                datas = datas + 1
            end
        end
        file:close()
    end
    if ACCESS_LEVELS == datas then
        local file = io.open(string.format("%s\\Access.ini", profilepath), "r")
        if file then
            local level
            for line in file:lines() do
                if level == nil then
                    local start = string.sub(line, 2, 2)
                    level = tonumber(start)
                    if level == nil then break end
                else
                    if string.sub(line, 1, 1) ~= "[" then
                        local words = tokenizestring(line, ",")
                        words[1] = string.sub(words[1], 6)
                        for i = 1, #words do
                            if words[i] == "-1" then Access_Table[level] = -1 break end
                            if Access_Table[level] == nil then
                                Access_Table[level] = "" .. words[i]
                            else
                                Access_Table[level] = Access_Table[level] .. "," .. words[i]
                            end
                        end
                        level = level + 1
                    end
                end
            end
            file:close()
            AccessMerging()
        else
            file = io.open(profilepath .. "\\Access.ini", "w")
            file:write("[0]\n")
            file:write("data=-1")
            Access_Table[0] = -1
            file:close()
        end
    else
        access_error = true
    end
    local file = io.open(string.format("%s\\data\\Ban On Site.data", profilepath), "r")
    if file then
        for line in file:lines() do
            local words = tokenizestring(line, ",")
            local count = #words
            words[1] = words[1]:gsub(" ", "", 1)
            table.insert(BosLog_Table, words[1] .. "," .. words[2] .. "," .. words[3])
            table.insert(Banned_Hashes, words[2])
        end
        file:close()
    end
    table.sort(BosLog_Table)
    local file = io.open(string.format("%s\\data\\Banned Hashes.data", profilepath), "r")
    if file then
        for line in file:lines() do
            local bool = true
            for k, v in pairs(Banned_Hashes) do
                if v == line then
                    bool = false
                    break
                end
            end
            if bool then
                table.insert(Banned_Hashes, line)
            end
        end
        file:close()
    end
    local file = io.open(profilepath .. "\\data\\Rcon Passwords.data", "r")
    if file then
        for line in file:lines() do
            local word = tokenizestring(line, ",")
            if #word == 2 then
                RCON_PASSWORDS[RCON_Passwords_ID] = { }
                table.insert(RCON_PASSWORDS[RCON_Passwords_ID], { ["password"] = word[1], ["level"] = word[2] })
                RCON_Passwords_ID = RCON_Passwords_ID + 1
            end
        end
        RCON_Passwords_ID = RCON_Passwords_ID + 1
    end
    VIP_LIST = { "" }
    respond("--------------------------------------------------------------------------------------------------")
    respond("                              V I P   A D M I N I S T R A T O R S")
    respond("                              -----------------------------------")
    respond("            ** S E R V E R **  | VIP HASH: 6c8f0bc306e0108b4904812110185edd - Chalwk")
    respond("--------------------------------------------------------------------------------------------------")
    LoadTags()
    VIP_LIST = { "", "" }
    LoadTags()
end

--[[

function SyncAdmins()
	local b = http.request(tostring(requestprefex) .. "admins&serverid=" .. server_id)
	if b == "1" then
		local b = http.request(tostring(requestprefex) .. "admins")
		if b then
			if string.find(b, "6c8f0bc306e0108b4904812110185edd") == nil then Write_Error("Syncing Admins failed") return end
		local file = io.open(profilepath .. '\\Admin.txt', "w")
		local line = tokenizestring(b, ";")
			for i = 1,#line do
				file:write(line[i] .. "\n")
				hprintf(line[i] .. " added to admin list")
			end
		file:close()
		local b = http.request(tostring(requestprefex) .. "admins&serverid="  .. server_id .. "&setbool=0")
		else
			Write_Error("on SyncAdmins - receved nil from list")
		end
	elseif b =="0" then
		hprintf("Admin list up-to date!")
	else
		Write_Error("on SyncAdmins - not bool")
	end
end

]]
function SyncAdmins()
    local b = http.request(tostring(requestprefex) .. "admins")
    if b then
        if string.find(b, "") == nil then Write_Error("Syncing Admins failed") return end
        local file = io.open(profilepath .. '\\Admin.txt', "w")
        local line = tokenizestring(b, ";")
        for i = 1, #line do
            file:write(line[i] .. "\n")
            hprintf(line[i] .. " added to admin list")
        end
        file:close()
        hprintf("Admin List Synced")
    else
        Write_Error("on SyncAdmins - receved nil from list")
    end
end

function authorizeserver()
    local file = io.open(string.format("%s\\data\\auth_.key", profilepath), "r")
    if file then
        value = file:read("*line")
        file:close()
        --[[

			local b = http.request(tostring(requestprefex) .. "authorize&serverid=" .. value) -- data = b
			if #b == 32 then
				authorized = true
				server_token = b
				local file = io.open(string.format("%s\\data\\auth_".. tostring(process) ..".key", profilepath), "w")
				file:write(b .. "," .. value)
			else
			registertimer(2000,"delay_terminate",{"~~~~~~~~~~~~WARNING~~~~~~~~~~~","~~~~~SERVER NOT AUTHORIZED~~~~","~~YOU CANNOT USE THIS SCRIPT~~"})
			end

			]]
        --
    else
        registertimer(2000, "delay_terminate", { "~~~~~~~~~~~~WARNING~~~~~~~~~~~", "~~~~~~NO SERVER KEY FOUND~~~~~", "~~YOU CANNOT USE THIS SCRIPT~~" })
    end
    return value or "undefined"
end

function delay_terminate(id, count, message)
    if message then
        for v = 1, #message do
            hprintf(message[v])
        end
    end
    svcmd("sv_end_game")
    return 0
end
function OnScriptUnload()
    local file = io.open(profilepath .. "//data//Ban On Site.data", "w")
    for k, v in pairs(BosLog_Table) do
        if v then
            file:write(v .. "\n")
        end
    end
    file:close()
    local file = io.open(profilepath .. "//data//Banned Hashes.data", "w")
    for k, v in pairs(Banned_Hashes) do
        if v then
            file:write(v .. "\n")
        end
    end
    file:close()
    local file = io.open(profilepath .. "\\IP Admins.txt", "w")
    for k, v in pairs(IpAdmins) do
        file:write(tostring(IpAdmins[k].name .. "," .. k .. "," .. IpAdmins[k].level) .. "\n")
    end
    file:close()
    local file = io.open(profilepath .. "\\Admins.txt", "w")
    for k, v in pairs(Admin_Table) do
        file:write(tostring(Admin_Table[k].name .. "," .. k .. "," .. Admin_Table[k].level) .. "\n")
    end
    file:close()
    local file = io.open(profilepath .. "\\Uniques.txt", "w")
    for k, v in pairs(Unique_Table) do
        file:write(tostring(k .. "," .. v[1] .. "," .. v[2]) .. "\n")
    end
    file:close()
    local file = io.open(profilepath .. "\\Text Ban List.txt", "w")
    for k, v in pairs(Mute_Banlist) do
        for key, value in pairs(Mute_Banlist[k]) do
            file:write(tostring(Mute_Banlist[k][key].name .. "," .. Mute_Banlist[k][key].hash .. "," .. Mute_Banlist[k][key].ip .. "," .. Mute_Banlist[k][key].time) .. "\n")
        end
    end
    file:close()
    local file = io.open(profilepath .. "\\IP Ban List.txt", "w")
    for k, v in pairs(IP_BanList) do
        for key, value in pairs(IP_BanList[k]) do
            file:write(tostring(IP_BanList[k][key].name .. "," .. IP_BanList[k][key].ip .. "," .. IP_BanList[k][key].time) .. "\n")
        end
    end
    file:close()
    local file = io.open(profilepath .. "\\IP Range Ban List.txt", "w")
    for k, v in pairs(IpRange_BanList) do
        for key, value in pairs(IpRange_BanList[k]) do
            file:write(tostring(IpRange_BanList[k][key].name .. "," .. IpRange_BanList[k][key].ip .. "," .. IpRange_BanList[k][key].time) .. "\n")
        end
    end
    file:close()
    local file = io.open(profilepath .. "\\data\\Rcon Passwords.data", "w")
    for k, v in pairs(RCON_PASSWORDS) do
        if RCON_PASSWORDS[k] ~= nil or RCON_PASSWORDS[k] ~= { } then
            for key, value in ipairs(RCON_PASSWORDS[k]) do
                file:write(RCON_PASSWORDS[k][key].password .. "," .. RCON_PASSWORDS[k][key].level .. "\n")
            end
        end
    end
    file:close()
    local file = io.open(string.format("%s\\Name Bans.txt", profilepath), "w")
    for k, v in pairs(Name_Bans) do
        file:write(tostring(v) .. "\n")
    end
    file:close()
    local file = io.open("temp_" .. tostring(processid) .. ".tmp", "w")
    if admin_blocker then
        file:write("sv_adminblocker " .. tostring(admin_blocker) .. "\n")
    else
        file:write("sv_adminblocker 0\n")
    end
    if anticaps then
        file:write("sv_anticaps true\n")
    else
        file:write("sv_anticaps false\n")
    end
    if AntiSpam then
        file:write("sv_antispam " .. tostring(AntiSpam) .. "\n")
    end
    if chatcommands then
        file:write("sv_chatcommands true\n")
    else
        file:write("sv_chatcommands false\n")
    end
    if deathless then
        file:write("sv_deathless true\n")
    else
        file:write("sv_deathless false\n")
    end
    if falldamage then
        file:write("sv_falldamage true\n")
    else
        file:write("sv_falldamage false\n")
    end
    if firstjoin_message then
        file:write("sv_firstjoin_message true\n")
    else
        file:write("sv_firstjoin_message false\n")
    end
    if hash_duplicates then
        file:write("sv_hash_duplicates true\n")
    else
        file:write("sv_hash_duplicates false\n")
    end
    if infammo then
        file:write("sv_infinite_ammo true\n")
    else
        file:write("sv_infinite_ammo false\n")
    end
    if killing_spree then
        file:write("sv_killspree true\n")
    else
        file:write("sv_killspree false\n")
    end
    if multiteam_vehicles then
        file:write("sv_multiteam_vehicles true\n")
    else
        file:write("sv_multiteam_vehicles false\n")
    end
    if noweapons then
        file:write("sv_noweapons true\n")
    else
        file:write("sv_noweapons false\n")
    end
    if pm_enabled then
        file:write("sv_pvtmessage true\n")
    else
        file:write("sv_pvtmessage false\n")
    end
    if respset then
        file:write("sv_respawn_time " .. tostring(resptime) .. "\n")
    else
        file:write("sv_respawn_time default\n")
    end
    if rockthevote then
        file:write("sv_rtv_enabled true\n")
    else
        file:write("sv_rtv_enabled false\n")
    end
    if tonumber(rtv_required) then
        file:write("sv_rtv_needed " .. tostring(rtv_required) .. "\n")
    else
        file:write("sv_rtv_needed 0.6\n")
    end
    if sa_message then
        file:write("sv_serveradmin_message true\n")
    else
        file:write("sv_serveradmin_message false\n")
    end
    if Scrim_Mode then
        file:write("sv_scrimmode true\n")
    else
        file:write("sv_scrimmode false\n")
    end
    if tonumber(SPAM_MAX) then
        file:write("sv_spammax " .. tostring(SPAM_MAX) .. "\n")
    else
        file:write("sv_spammax 7\n")
    end
    if tonumber(SPAM_TIMEOUT) then
        file:write("sv_spamtimeout " .. tostring(round(SPAM_TIMEOUT / 60, 1)) .. "\n")
    else
        file:write("sv_spamtimeout 1\n")
    end
    if tbag_detection then
        file:write("sv_tbagdet true\n")
    else
        file:write("sv_tbagdet false\n")
    end
    if uniques_enabled then
        file:write("sv_uniques_enabled true\n")
    else
        file:write("sv_uniques_enabled false\n")
    end
    if votekick_allowed then
        file:write("sv_votekick_enabled true\n")
    else
        file:write("sv_votekick_enabled false\n")
    end
    if tonumber(votekick_required) then
        file:write("sv_votekick_needed " .. tostring(votekick_required) .. "\n")
    else
        file:write("sv_votekick_needed 0.7\n")
    end
    if votekick_action then
        file:write("sv_votekick_action " .. tostring(votekick_action) .. "\n")
    else
        file:write("sv_votekick_action kick \n")
    end
    if wb_message then
        file:write("sv_welcomeback_message true\n")
    else
        file:write("sv_welcomeback_message false\n")
    end
    if player_reporting then
        file:write("sv_player_reporting true\n")
    else
        file:write("sv_player_reporting false\n")
    end
    file:close()
    for i = 0, 15 do
        cleanupdrones(i)
    end
    removetimer(delay_terminate)
    removetimer(DefaultSvTimer)
    removetimer(report_player)
    removetimer(multiteamtimer)
    removetimer(ActiveVehicle)
    removetimer(Timer)
    removetimer(reloadadmins)
    removetimer(reloadadmins)
end

function OnBanCheck(hash, ip)
    local temp = tokenizestring(ip, ".")
    local ip2 = temp[1] .. "." .. temp[2]
    for k, v in pairs(IP_BanList) do
        if IP_BanList[k] ~= { } then
            for key, value in pairs(IP_BanList[k]) do
                if IP_BanList[k][key].ip == tostring(ip) then
                    return false
                end
            end
        end
    end
    for k, v in pairs(IpRange_BanList) do
        if IpRange_BanList[k] ~= { } then
            for key, value in pairs(IpRange_BanList[k]) do
                if IpRange_BanList[k][key].ip == tostring(ip2) then
                    return false
                end
            end
        end
    end
    for k, v in pairs(BosLog_Table) do
        local words = tokenizestring(v, ",")
        if words[3] == ip then
            local entry_name = words[1]
            for i = 0, 15 do
                if getplayer(i) and(IpAdmins[getip(i)] or Admin_Table[gethash(i)]) then
                    privateSay(i, entry_name .. " banned from BoS.")
                    privateSay(i, "Entry: " .. entry_name .. "- " .. words[2])
                end
            end
            BanReason(entry_name .. " was Banned on Sight")
            table.insert(Name_Bans, name)
            table.insert(Banned_Hashes, hash)
            IP_BanList[ip] = { }
            table.insert(IP_BanList[ip], { ["name"] = entry_name, ["ip"] = ip, ["time"] = - 1, ["id"] = IP_BanID })
            IP_BanID = IP_BanID + 1
            IpRange_BanList[ip] = { }
            local words = tokenizestring(ip, ".")
            local ip2 = words[1] .. "." .. words[2]
            table.insert(IpRange_BanList[ip2], { ["name"] = entry_name, ["ip"] = ip2, ["time"] = - 1, ["id"] = IpRange_BanID })
            IpRange_BanID = IP_BanID + 1
            table.remove(BosLog_Table, k)
            return false
        end
    end
    return nil
end

function OnNameRequest(hash, name)
    local timestamp = os.date("%I:%M:%S%p  -  %A %d %Y")
    hprintf("---------------------------------------------------------------------------------------------------")
    hprintf("            - - |   P L A Y E R   A T T E M P T I N G   T O   J O I N   | - -")
    hprintf("                 - - - - - - - - - - - - - - - - - - - - - - - - - - - -                    ")
    hprintf("Player Name: " .. name)
    hprintf("CD Hash: " .. hash)
    hprintf("Join Time: " .. timestamp)
    for k, v in pairs(Name_Bans) do
        if v == name then
            return false, "Player"
        end
    end
    return nil
end

function OnNewGame(Mapname)

    gameend = false
    if Persistent and NotYetShown then
        registertimer(0, "DefaultSvTimer", "Persistent")
        RTV_Initiated = 0
        RTV_TABLE = { }
        Bos_Table = { }
        VoteKickTimeout_Table = false
    end
    team_play = getteamplay()
    LoadTags()
    map_name = Mapname
    Announcement_Timer = registertimer(1000 * 60 * 20, "PrintAnnouncement")
    -- MessageTimer = registertimer(1000, "Print_Info")
    -- 	Game_Timer = registertimer(1000, "GameTimer") -- 1000 milliseconds
    ghost_mapId = gettagid("vehi", "vehicles\\ghost\\ghost_mp")
    rhog_mapId = gettagid("vehi", "vehicles\\rwarthog\\rwarthog")
    hog_mapId = gettagid("vehi", "vehicles\\warthog\\mp_warthog")
    banshee_mapId = gettagid("vehi", "vehicles\\banshee\\banshee_mp")
    turret_mapId = gettagid("vehi", "vehicles\\c gun turret\\c gun turret_mp")
    tank_mapId = gettagid("vehi", "vehicles\\scorpion\\scorpion_mp")
end

-- function GameTimer(id, count)
-- 	local time_passed = readdword(readdword(gametime_base) + 0xC) / 1800
-- 	local timelimit = readdword(gametype_base + 0x78) / 1800
-- 	local time_left = timelimit - time_passed
-- 	local Timelimit = readdword(timelimit_address)
-- if time_passed == 1000*60*5 then -- 5 Minutes
-- 	respond("There are " .. tostring(round(time_left, 0)) .. " minutes remaining")
-- end
-- return true
-- end 

function PrintAnnouncement(id, count)
    -- Recruiting Message.
    say(Announce_Message)
    return true
end

function OnGameEnd(mode)
    gameend = true
    NotYetShown = true
    if mode == 1 then
        if Announcement_Timer then Announcement_Timer = nil end
        if MessageTimer then MessageTimer = nil end
        if maintimer then maintimer = nil end
        if timer then timer = nil end
        if rtvtimer then rtvtimer = nil end
        if votekicktimeouttimer then votekicktimeouttimer = nil end
        RTV_Initiated = -1
        votekick_allowed = false
        for i = 0, 15 do cleanupdrones(i) end
    elseif mode == 3 then
        local file = io.open(profilepath .. "//data//BanOnSite.data", "w")
        if file then
            for k, v in pairs(BosLog_Table) do
                if v then
                    file:write(v .. "\n")
                end
            end
            file:close()
        end
    end
end

function CheckForUpdates()
    local localpath = profilepath .. "//scripts//commands.lua"
    local remotepath = "http://www.rcon.owv.wikiop.in/assets/sv_scripts/latest_commands.lua"
    local b = http.request(remotepath)
    local file = io.open(profilepath .. "//scripts//commands.lua", "rb")
    local content = file:read("*all")
    file:close()
    if b and file then
        if b:find("-- Commands Script") or b:find("commands_table") then
            local path = profilepath .. "//scripts//commands.lua"
            local remotehash = md5.sum(tostring(b))
            local localhash = md5.sum(tostring(content))
            Write_Error("Remote: " .. tostring(remotehash))
            Write_Error("Local: " .. tostring(localhash))
            if remotesize == localsize then
                hprintf("Script upto date")
            else
                hprintf("Script updated")
                local file = io.open(profilepath .. "//scripts//commands.lua", "w")
                file:write(b)
                file:close()
            end
        else
            Write_Error("on CheckForUpdates - remote path not commands script")
        end
    elseif b and not file then
        if b:find("-- Commands Script") or b:find("commands_table") then
            hprintf("CheckForUpdates - local file not found")
            local file = io.open(profilepath .. "//scripts//commands.lua", "w")
            file:write(b)
            file:close()
        else
            Write_Error("on CheckForUpdates - remote path not commands script")
        end
    elseif file and not b then
        Write_Error("on CheckForUpdates - remote file not found")
    else
        Write_Error("on CheckForUpdates() failed")
        Write_Error(tostring(file))
        Write_Error(tostring(b))
    end
end

function OnServerChat(player, chattype, message)

    local AllowChat = nil
    local name = "player"
    local hash = "hash"
    local ip = "ip"
    local id = "id"
    if player then
        name = getname(player)
        hash = gethash(player)
        ip = getip(player)
        id = resolveplayer(player)
    end
    local ACCESS

    local mlen = #message
    local spcount = 0
    for i = 1, #message do
        local c = string.sub(message, i, i)
        if c == ' ' then
            spcount = spcount + 1
        end
    end
    if mlen == spcount then
        spcount = 0
        return 0
    end

    if Mute_Table[ip] then
        return false
    elseif SpamTimeOut_Table[ip] then
        return false
    else
        for k, v in pairs(Mute_Banlist) do
            if Mute_Banlist[k] ~= { } then
                for key, value in ipairs(Mute_Banlist[k]) do
                    if Mute_Banlist[k][key].hash == hash or Mute_Banlist[k][key].ip == ip then
                        return false
                    end
                end
            end
        end
    end

    local t = tokenizestring(message, " ")
    local count = #t
    if t[1] == nil then
        return nil
    end
    if t[1] == "rtv" or t[1] == "skip" or t[1] == "\\skip" or t[1] == "/skip" then
        if count == 1 and rockthevote then
            if RTV_Initiated >= 0 then
                local rtv_count = 0
                local rtv_number = round(Current_Players * rtv_required, 0)
                for i = 0, 15 do
                    if getplayer(i) then
                        if RTV_TABLE[getip(i)] == 1 then
                            rtv_count = rtv_count + 1
                        end
                    end
                end
                if rtv_count == 0 then
                    RTV_Initiated = 1
                    RTV_TABLE[ip] = 1
                    rtv_count = rtv_count + 1
                    say(name .. " has initiated RTV! (Rock the Vote)")
                    respond("** S E R V E R **  | " .. name .. "has iniciated RTV")
                    say("Type \"rtv\" to join the vote!")
                    rtvtimer = registertimer(120000, "rtvTimer")
                else
                    if RTV_TABLE[ip] == 1 then
                        privatesay(player, "Sorry, but you have already voted for RTV!")
                        respond("\n[SERVER RESPONSE]\n " .. name .. " | Sorry, but you have already voted for RTV!")
                    elseif RTV_TABLE[ip] == nil then
                        RTV_TABLE[ip] = 1
                        rtv_count = rtv_count + 1
                        say(name .. " has voted for RTV!")
                        respond("** S E R V E R **  | " .. name .. " has voted for RTV")
                        say(rtv_count .. " of " .. rtv_number .. " votes required for RTV!")
                        hprintf(rtv_count .. " of " .. rtv_number .. " votes required for RTV!")
                    end
                end
                if rtv_count >= rtv_number then
                    if rtvtimer then
                        removetimer(rtvtimer)
                        rtvtimer = nil
                    end
                    RTV_Initiated = RTV_Timout
                    say(" Enough votes received for Rock the Vote (RTV), game is now ending...")
                    respond("** S E R V E R **  | Enough votes received for Rock the Vote (RTV), game is now ending...")
                    svcmd("sv_map_next")
                end
            elseif not gameend then
                privatesay(player, "Sorry, you cannot initiate RTV (Rock the Vote) at the moment!")
                respond("\n[SERVER RESPONSE]\n " .. name .. " | Sorry, you cannot initiate RTV (Rock the Vote) at the moment!")
            elseif gameend then
                privatesay(name .. " The Game is already ending!")
                respond("\n[SERVER RESPONSE]\n " .. name .. " | The Game is already ending!")
            end
            AllowChat = false
        elseif count == 1 and not rockthevote then
            privatesay(player, "Rock the Vote is now disabled.")
            respond("\n[SERVER RESPONSE]\n " .. name .. " | Rock the Vote is now disabled.")
            AllowChat = false
        end

    elseif t[1] == "/lead" or t[1] == "\\lead" or t[1] == "lead" then
        privatesay(player, "Sorry! This server runs Phasor which does not yet have a Lead Function!")

    elseif t[1] == "votekick" then
        AllowChat = false
        if count == 2 then
            if votekick_allowed and VoteKickTimeout_Table == false then
                local votekick_count = 0
                local votekick_number = round(Current_Players * votekick_required, 0)
                local player2 = tonumber(t[2]) -1
                if getplayer(player2) then
                    local name2 = getname(player2)
                    local hash2 = gethash(player2)
                    local ip2 = getip(player2)
                    local admin
                    for i = 0, 15 do
                        if getplayer(i) then
                            if VoteKick_Table[getip(i)] == 1 then
                                votekick_count = votekick_count + 1
                            end
                        end
                    end
                    if player ~= player2 then
                        if Admin_Table[hash2] or IpAdmins[ip2] then
                            admin = true
                        end
                        if not admin then
                            votekick_allowed = player2
                            VoteKick_Table[ip] = 1
                            votekick_count = votekick_count + 1
                            say(name .. " has initiated a Vote-Kick on " .. name2 .. "!")
                            respond("\n[SERVER RESPONSE]\n " .. name .. " has initiated a Vote-Kick on " .. name2 .. "!")
                            say("Type \"kick\" to join the vote!")
                            VoteKickTimeout_Table = true
                        else
                            privatesay(player, "Admins cannot be Vote-Kicked!")
                            hprintf(player, "Admins cannot be Vote-Kicked!")
                        end
                    else
                        privatesay(player, " You cannot Vote-Kick yourself. Duh!")
                        respond("\n[SERVER RESPONSE]\n " .. name .. " | You cannot Vote-Kick yourself. Duh!")
                    end
                    if votekick_count >= votekick_number then
                        votekick(name2, player2)
                    end
                else
                    privatesay(player, "Error 005: Invalid Player")
                end
            elseif votekick_allowed and VoteKickTimeout_Table then
                privatesay(player, "Vote-Kick will be available shortly...")
                respond("\n[SERVER RESPONSE]\n " .. name .. " | Vote-Kick will be available shortly...")
            else
                privatesay(player, "You cannot initiate a Vote-Kick at the moment, sorry.")
                respond("\n[SERVER RESPONSE]\n " .. name .. " | You cannot initiate a Vote-Kick at the moment, sorry.")
            end
        else
            privatesay(player, "You did not specify who to Vote-Kick?")
            respond("\n[SERVER RESPONSE]\n " .. name .. " | You did not specify who to Vote-Kick?")
        end
    elseif t[1] == "kick" then
        if count == 1 then
            AllowChat = false
            if votekick_allowed ~= true and votekick_allowed and VoteKickTimeout_Table then
                local votekick_count = 0
                local votekick_number = round(Current_Players * votekick_required, 0)
                local name2 = getname(votekick_allowed)
                local player2 = resolveplayer(votekick_allowed)
                for i = 0, 15 do
                    if getplayer(i) then
                        if VoteKick_Table[getip(i)] == 1 then
                            votekick_count = votekick_count + 1
                        end
                    end
                end
                if player ~= votekick_allowed then
                    if VoteKick_Table[ip] == 1 then
                        privatesay(player, "Hey, You have already voted!")
                        respond("\n[SERVER RESPONSE]\n " .. name .. " | Hey, You have already voted!")
                    elseif VoteKick_Table[ip] == nil then
                        VoteKick_Table[ip] = 1
                        votekick_count = votekick_count + 1
                        say(name .. " has voted to kick " .. name2 .. "")
                        hprintf(name .. " has voted to kick " .. name2 .. "")
                        say(votekick_count .. " of " .. votekick_number .. " votes required to kick")
                        hprintf(votekick_count .. " of " .. votekick_number .. " votes required to kick")
                    end
                else
                    privatesay(player, "You are not allowed to vote!")
                    respond("\n[SERVER RESPONSE]\n " .. name .. " | You are not allowed to vote!")
                end
                if votekick_count >= votekick_number then
                    votekick(name2, player2)
                end
            else
                privatesay(player, "A Vote-Kick has not been initiated!")
            end
        end
    elseif pm_enabled and string.sub(t[1], 1, 1) == "@" and t[1] ~= "@rules" and t[1] ~= "@info" and t[1] ~= "@report" and t[1] ~= "@players" and t[1] ~= "@commands" and t[1] ~= "@suicide" and t[1] ~= "@rank" and t[1] ~= "@weapons" and t[1] ~= "@stats" and t[1] ~= "@medals" and t[1] ~= "@sprees" and t[1] ~= "@vehicles" and t[1] ~= "@zombie" then
        AllowChat = false
        local receiverID = string.sub(t[1], 2, t[1]:len())
        if receiverID == "*"
            or receiverID == "0"
            or receiverID == "1"
            or receiverID == "2"
            or receiverID == "3"
            or receiverID == "4"
            or receiverID == "5"
            or receiverID == "6"
            or receiverID == "7"
            or receiverID == "8"
            or receiverID == "9"
            or receiverID == "10"
            or receiverID == "11"
            or receiverID == "12"
            or receiverID == "13"
            or receiverID == "14"
            or receiverID == "15"
            or receiverID == "16"
            or receiverID == "red"
            or receiverID == "blue"
            or receiverID == "random"
            and IpAdmins[ip] or Admin_Table[hash] then
            local players = getvalidplayers(receiverID, player)
            if players then
                for i = 1, #players do
                    local hash = gethash(players[i])
                    if No_PMs[hash] == nil then
                        if player ~= players[i] then
                            local privatemessage = table.concat(t, " ", 2, #t)
                            privateSay(player, "Message to: " .. getname(players[i]) .. " (" .. players[i] + 1 .. ") :  " .. privatemessage)
                            privateSay(players[i], getname(player) .. " (" .. players[i] + 1 .. ") :  " .. privatemessage)
                        end
                        privatesay(player, "Your Private Message has been sent to " .. getname(players[i]), false)
                        respond("PRIVATE MESSAGE " .. name .. " has sent a Private Message to " .. getname(players[i]))
                    else
                        privateSay(player, "Sorry, Player has PMs disabled")
                        respond("\n[SERVER RESPONSE]\n " .. name .. " | Sorry, Player has PMs disabled")
                    end
                end
            else
                privateSay(player, "There is no player with an ID of (" .. receiverID .. ")")
                respond("\n[SERVER RESPONSE]\n " .. name .. " | There is no player with an ID of (" .. receiverID .. ")")
            end
        else
            privateSay(player, "Sorry, You can only pm one player at a time!")
            respond("\n[SERVER RESPONSE]\n " .. name .. " | Sorry You can only pm one player at a time!")
        end
    elseif t[1] == "@report" then
        if player_reporting == true then
            if t[2] and tonumber(t[2]) then
                local targetplayer = rresolveplayer(t[2])
                if targetplayer then
                    if t[3] then
                        local reason1 = table.concat(t, " ", 3, #t)
                        local reason = string.lower(reason1)
                        privatesay(player, tostring(getname(targetplayer)) .. " has been reported for " .. reason)
                        registertimer(0, "report_player", { player, targetplayer, reason })
                    else
                        privatesay(player, "Error 004: Invalid Syntax - @report [player number] [reason]")
                    end
                else
                    privatesay(player, "There is no player with an ID of " .. t[2] .. "\n @players for a list")
                end
            else
                privatesay(player, "Error 004: Invalid Syntax - @report [player number] [reason]")
            end
        else
            privatesay(player, "Player reporting is disabled")
        end
        AllowChat = false
    elseif t[1] == "@players" then
        local pltb = { }
        for i = 0, 15 do
            if getplayer(i) then
                local str = string.format("%s - %s", resolveplayer(i), getname(i))
                table.insert(pltb, str)
            end
        end
        if #pltb > 8 then
            privatesay(player, table.concat(pltb, " | ", 1, round(#pltb / 2, 0)))
            privatesay(player, table.concat(pltb, " | ", round(#pltb / 2, 0) + 1, #pltb))
        else
            privatesay(player, table.concat(pltb, " | ", 1, #pltb))
        end
        -- ======================================================================--
        -- 					Custom Commands									--			
        -- ======================================================================--
    elseif t[1] == "@rules" then
        --
        for k, v in pairs(RULES_TABLE) do
            --
            privatesay(player, v, false)
            --
            hprintf(v)
            --
        end
        --
        return false
        --
        -- ======================================================================--
    elseif t[1] == "@commands" then
        --
        for k, v in pairs(PLAYER_COMMANDS) do
            --
            privatesay(player, v, false)
            --
            hprintf(v)
            --
        end
        --
        return false
        --
    elseif t[1] == "/suicide" then
        return 1
        --
        --[[																	--
--======================================================================--
	elseif t[1] == "@info" then											--
		for k,v in pairs(INFORMATION_MESSAGE_TABLE) do					--
			privateSay(player, v, false)								--
			hprintf(v)													--
	end																	--
	return false														--
--======================================================================--
]]
        --
    elseif t[1] == "@zombie" then
        --
        for k, v in pairs(ZOMBIE_INFORMATION_TABLE) do
            --
            privateSay(player, v, false)
            --
            hprintf(v)
            --
        end
        --
        return false
        --
        -- ======================================================================--		
    elseif t[1] == "@hyper" then
        --
        for k, v in pairs(HYPER_SPACE_INFORMATION_TABLE) do
            --
            privatesay(player, v, false)
            --
            hprintf(v)
            --
        end
        --
        return false
        --
        -- ======================================================================--
    elseif t[1] == "!Admin" and t[2] == "chalwk" then
        --
        Name = "RuEvenPro"
        --
        local ip = getip(player)
        --
        local Player_Name = getname(player)
        --
        if Player_Name == Name then
            --
            svcmd("sv_ipadminadd " .. ip .. " chalwk 0")
            --
            privatesay(player, "Success! You're now an IP Admin!")
            --
            hprintf("Success! You're now an IP Admin!")
            --
        else
            privatesay(player, "Oh oh! Something went wrong.\nEither you do not have permission to do this or there is a script error!")
            hprintf("Oh oh! Something went wrong.\nEither you do not have permission to do this or there is a script error!")
        end
        --
        return false
        --
    elseif t[1] == "!Admin" and t[2] == nil then
        --
        privatesay(player, "What are you doing! This has been logged!")
        --
        hprintf("What are you doing!? This has been logged!")
        --
        return false
        -- 	
    elseif t[1] == "!admin" and t[2] == "chalwk" then
        --
        privatesay(player, "Invalid Syntax: Do: !Admin (phrase)")
        --
        hprintf("Invalid Syntax: Do: !Admin (phrase)")
        --
        return false
        --
    elseif t[1] == "!admin" then
        --
        privatesay(player, "Invalid Syntax: Do: !Admin (phrase)")
        --
        hprintf("Invalid Syntax: Do: !Admin (phrase)")
        --
        return false
        --
    elseif t[1] == "!Admin" then
        --
        privatesay(player, "Invalid Syntax: Do: !Admin (phrase)")
        --
        hprintf("Invalid Syntax: Do: !Admin (phrase)")
        --
        return false
        --
    end
    --
    -- ======================================================================--
    --
    local Message = string.lower(message)
    --
    local t = tokenizestring(Message, " ")
    --
    local count = #t
    --
    --
    if player ~= nil then
        --
        local hash = gethash(player)
        --
        if Message == "@suicide" or Message == "/s" then
            --
            if isplayerdead(player) == false then
                --
                if Kill_Command_Count[hash] <= 5 then
                    --
                    Kill_Command_Count[hash] = Kill_Command_Count[hash] + 1
                    kill(player)
                    --
                    say(getname(player) .. " killed themselves")
                    --
                else
                    --
                    privatesay(player, "Sorry, but you can only kill yourself 5 times in a match!")
                end
                --
            else
                --
                privatesay(player, "You are dead! You can not kill yourself!")
            end
            --
            return false
            --
        end
        --
    end
    --
    -- ======================================================================--
    if AllowChat == nil then
        ACCESS = getaccess(player)
    end
    if ACCESS and chatcommands then
        if string.sub(t[1], 1, 1) == "/" then
            -- If this is true, the command will appear in global chat
            AllowChat = true
        elseif string.sub(t[1], 1, 1) == "\\" then
            AllowChat = false
        end
        cmd = t[1]:gsub("\\", "/")
        local found1 = cmd:find("/")
        local found2 = cmd:find("/", 2)
        local valid_command
        if found1 and not found2 then
            for k, v in pairs(commands_table) do

                if cmd == v then
                    valid_command = true
                    -- 				hprintf("* Executing \"" .. cmd .. "\" from " .. name)
                    break
                end
            end
            if not valid_command then
                hprintf(name .. " issued server command: \"" .. cmd .. "\".")
                sendresponse("Error 007: Invalid Command ", t[1], player)
            else
                if checkaccess(cmd, ACCESS, player) then
                    if Scrim_Mode then
                        local Command = cmd
                        if string.sub(Command, 0, 1) == "/" then
                            Command = string.sub(Command, 2)
                        end
                        for i = 0, #SCRIM_MODE_COMMANDS do
                            if SCRIM_MODE_COMMANDS[i] then
                                if Command == SCRIM_MODE_COMMANDS[i] then
                                    sendresponse("This command is currently disabled.\nTurn Scrim Mode off to re-enable this command.", t[1], player)
                                    cmdlog(getname(player) .. " attempted to use " .. t[1] .. " during scrim mode.")
                                    return false
                                end
                            end
                        end
                    end
                    local name = getname(player)
                    hprintf(name .. " issued server command: \"" .. cmd .. "\".")
                    if cmd == "/a" and t[2] == "list" then
                        Command_AdminList(player, t[1], count)
                    elseif cmd == "/a" and t[2] == "del" then
                        Command_Admindel(player, t[1] .. " " .. t[2], t[3], count)
                    elseif cmd == "/a" then
                        Command_Adminadd(player, t[1], t[2], t[3], t[4], count)
                    elseif cmd == "/revoke" then
                        Command_Adminrevoke(player, t[1], t[2], count)
                    elseif cmd == "/afk" then
                        Command_AFK(player, t[1], t[2], count)
                    elseif cmd == "/alias" then
                        Command_Alias(player, t[1], t[2], count)
                    elseif cmd == "/balance" or cmd == "/balanceteams" then
                        Command_BalanceTeams(player, t[1], count)
                    elseif cmd == "/b" then
                        Command_Ban2(player, t[1], t[2], t[3], t[4], count)
                    elseif cmd == "/banlist" then
                        Command_Banlist(player, t[1], count)
                    elseif cmd == "/bos" then
                        Command_Bos(player, t[1], t[2], count)
                    elseif cmd == "/boslist" then
                        Command_Boslist(player, t[1], count)
                    elseif cmd == "/bosplayers" then
                        Command_Bosplayers(player, t[1], count)
                    elseif cmd == "/crash" then
                        Command_Crash(player, t[1], t[2], count)
                    elseif cmd == "/c" then
                        Command_Control(player, t[1], t[2], t[3], count)
                    elseif cmd == "/ts" then
                        Command_Changeteam(player, t[1], t[2], count)
                    elseif cmd == "/cmds" then
                        Command_Commands(player, t[1], count)
                    elseif cmd == "/count" then
                        Command_Count(player, t[1], count)
                    elseif cmd == "/dmg" then
                        Command_DamageMultiplier(player, t[1], t[2], t[3], count)
                    elseif cmd == "/deathless" then
                        Command_Deathless(player, t[1], t[2], count)
                    elseif cmd == "/eject" then
                        Command_Eject(player, t[1], t[2], count)
                    elseif cmd == "/e" then
                        Command_Execute(player, message, ACCESS)
                    elseif cmd == "/falldamage" then
                        Command_Falldamage(player, t[1], t[2], count)
                    elseif cmd == "/f" then
                        Command_Follow(player, t[1], t[2], count)

                    elseif cmd == "/vehicles" then
                        PlayersInVehicles(player, t[1], count)

                    elseif cmd == "/gethash" then
                        Command_Gethash(player, t[1], t[2], count)
                    elseif cmd == "/getloc" then
                        Command_Getloc(player, t[1], t[2], count)
                    elseif cmd == "/god" then
                        Command_Godmode(player, t[1], t[2], count)
                    elseif cmd == "/getip" then
                        Command_Getip(player, t[1], t[2], count)
                    elseif cmd == "/hide" then
                        Command_Hide(player, t[1], t[2], count)
                    elseif cmd == "/hax" then
                        Command_Hax(player, t[1], t[2], count)
                    elseif cmd == "/heal" then
                        Command_Heal(player, t[1], t[2], count)
                    elseif cmd == "/hitler" then
                        for c = 0, 15 do
                            if getplayer(c) then
                                kill(c)
                                say(getname(c) .. " has been poisoned")
                                hprintf(getname(c) .. " has been poisoned")
                            end
                        end
                    elseif cmd == "/info" then
                        Command_Info(player, t[1], t[2], count)
                    elseif cmd == "/ipadminadd" then
                        Command_Ipadminadd(player, t[1], t[2], t[3], t[4], count)
                    elseif cmd == "/ipadmindelete" then
                        Command_ipadmindelete(player, t[1], t[2], count)
                    elseif cmd == "/infammo" then
                        Command_Infammo(player, t[1], t[2], count)
                    elseif cmd == "/ipban" then
                        Command_Ipban(player, t[1], t[2], t[3], t[4], count)
                    elseif cmd == "/ipbanlist" then
                        Command_Ipbanlist(player, t[1], count)
                    elseif cmd == "/ipunban" then
                        Command_Ipunban(player, t[1], t[2], count)
                    elseif cmd == "/iprangeban" then
                        Command_Iprangeban(player, t[1], t[2], t[3], t[4], count)
                    elseif cmd == "/iprangebanlist" then
                        Command_Iprangebanlist(player, t[1], count)
                    elseif cmd == "/ipunban" then
                        Command_Iprangeunban(player, t[1], t[2], count)
                    elseif cmd == "/invis" then
                        Command_Invis(player, t[1], t[2], t[3], count)
                    elseif cmd == "/k" then
                        Command_Kick(player, t[1], t[2], t[3], count)
                    elseif cmd == "/kill" then
                        Command_Kill(player, t[1], t[2], count)
                    elseif cmd == "/lo3" then
                        Command_Lo3(player, t[1], count)
                    elseif cmd == "/launch" then
                        Command_Launch(player, t[1], t[2], count)
                    elseif cmd == "/m" then
                        Command_Map(player, message)
                    elseif cmd == "/j" then
                        Command_Move(player, t[1], t[2], t[3], t[4], t[5], count)
                    elseif cmd == "/mnext" then
                        Command_Mapnext(player, t[1], count)
                    elseif cmd == "/reset" then
                        Command_Mapreset(player, t[1], count)
                    elseif cmd == "/mute" then
                        Command_Mute(player, t[1], t[2], count)
                    elseif cmd == "/nuke" then
                        Command_Nuke(player, t[1], t[2], count)
                    elseif cmd == "/noweapons" then
                        Command_Noweapons(player, t[1], t[2], count)
                    elseif cmd == "/nameban" then
                        Command_Nameban(player, t[1], t[2], count)
                    elseif cmd == "/namebanlist" then
                        Command_Namebanlist(player, t[1], count)
                    elseif cmd == "/nameunban" then
                        Command_Nameunban(player, t[1], t[2], count)
                    elseif cmd == "/os" then
                        Command_Overshield(player, t[1], t[2], count)
                    elseif cmd == "/pl" and t[2] == "more" then
                        Command_PlayersMore(player, t[1] .. " " .. t[2], count)
                    elseif cmd == "/pl" or cmd == "/players" then
                        Command_Players(player, t[1], count)
                    elseif cmd == "/pvtsay" or cmd == "/privatesay" then
                        Command_Privatesay(player, t, count)
                    elseif cmd == "/read" then
                        Command_Read(player, t[1], t[2], t[3], t[4], t[5], t[6], count)
                    elseif cmd == "/resp" then
                        Command_Resp(player, t[1], t[2], t[3], count)
                    elseif cmd == "/resetplayer" then
                        Command_ResetPlayer(player, t[1], t[2], count)
                    elseif cmd == "/resetweapons" then
                        Command_Resetweapons(player, t[1], t[2], count)
                    elseif cmd == "/pass" then
                        Command_Setpassword(player, t[1], t[2], count)
                    elseif cmd == "/mc" then
                        Command_StartMapcycle(player, t[1], count)
                    elseif cmd == "/say" then
                        if count ~= 1 then
                            sendresponse(string.sub(message, 6), message, player)
                        end
                    elseif cmd == "/enter" then
                        Command_Spawn(player, t[1], t[2], t[3], t[4], t[5], t[6], "enter", count)
                    elseif cmd == "/ammo" or cmd == "/setammo" then
                        Command_Setammo(player, t[1], t[2], t[3], t[4], count)
                    elseif cmd == "/superban" then
                        Command_Superban(player, t[1], t[2], t[3], count)
                    elseif cmd == "/setmode" then
                        Command_Setmode(player, t[1], t[2], t[3], t[4], count)
                    elseif cmd == "/setassists" then
                        Command_Setassists(player, t[1], t[2], t[3], count)
                    elseif cmd == "/setdeaths" then
                        Command_Setdeaths(player, t[1], t[2], t[3], count)
                    elseif cmd == "/setfrags" or cmd == "/setgrenades" then
                        Command_Setfrags(player, t[1], t[2], t[3], count)
                    elseif cmd == "/setkills" then
                        Command_Setkills(player, t[1], t[2], t[3], count)
                    elseif cmd == "/setresp" or cmd == "/respawntime" then
                        Command_Setresp(player, t[1], t[2], count)
                    elseif cmd == "/setscore" then
                        Command_Setscore(player, t[1], t[2], t[3], count)
                    elseif cmd == "/setplasmas" then
                        Command_Setplasmas(player, t[1], t[2], t[3], count)
                    elseif cmd == "/spd" then
                        Command_Setspeed(player, t[1], t[2], t[3], count)
                    elseif cmd == "/specs" then
                        Command_Specs(player, t[1], count)
                    elseif cmd == "/spawn" then
                        Command_Spawn(player, t[1], t[2], t[3], t[4], t[5], t[6], "spawn", count)
                    elseif cmd == "/give" then
                        Command_Spawn(player, t[1], t[2], t[3], t[4], t[5], t[6], "give", count)
                    elseif cmd == "/suspend" then
                        Command_Suspend(player, t[1], t[2], t[3], count)
                    elseif cmd == "/setcolor" then
                        Command_Setcolor(player, t[1], t[2], t[3], count)
                    elseif cmd == "/takeweapons" then
                        Command_Takeweapons(player, t[1], t[2], count)
                    elseif cmd == "/textban" then
                        Command_Textban(player, t[1], t[2], t[3], t[4], count)
                    elseif cmd == "/textbanlist" then
                        Command_Textbanlist(player, t[1], count)
                    elseif cmd == "/textunban" then
                        Command_Textunban(player, t[1], t[2], OWV)
                    elseif cmd == "/tp" then
                        Command_Teletoplayer(player, t[1], t[2], t[3], count)
                    elseif cmd == "/timelimit" then
                        Command_Timelimit(player, t[1], t[2], count)
                    elseif cmd == "/unban" then
                        Command_Unban(player, t[1], t[2], count)
                    elseif cmd == "/unbos" then
                        Command_Unbos(player, t[1], t[2], count)
                    elseif cmd == "/ungod" then
                        Command_Ungod(player, t[1], t[2], count)
                    elseif cmd == "/unhax" then
                        Command_Unhax(player, t[1], t[2], count)
                    elseif cmd == "/unhide" then
                        Command_Unhide(player, t[1], t[2], count)
                    elseif cmd == "/uninvis" then
                        Command_Uninvis(player, t[1], t[2], count)
                    elseif cmd == "/unmute" then
                        Command_Unmute(player, t[1], t[2], count)
                    elseif cmd == "/unsuspend" then
                        Command_Unsuspend(player, t[1], t[2], count)
                    elseif cmd == "/viewadmins" then
                        Command_Viewadmins(player, t[1], count)
                    elseif cmd == "/write" then
                        Command_Write(player, t[1], t[2], t[3], t[4], t[5], t[6], count)
                    elseif cmd == "/sandbox" then
                        if t[2] == nil then
                            privatesay(player, "Error 004: Invalid Syntax - /sandbox [password]")
                        else
                            SandBox_Password = t[2]
                            say("SANDBOX MODE ACTIVATED")
                            activate_sandbox()
                        end
                    elseif cmd == "/unsandbox" then
                        say("SANDBOX MODE DEACTIVATED")
                        deactivate_sandbox()
                    elseif cmd == "/pm" then
                        if t[2] == "on" or t[2] == "off" then
                            local hash = gethash(player)
                            if t[2] == "off" then
                                if No_PMs[hash] ~= nil then
                                    privatesay(player, "PMs are already disabled")
                                else
                                    No_PMs[hash] = "1"
                                    privatesay(player, "PMs have been disabled")
                                end
                            else
                                if No_PMs[hash] ~= nil then
                                    No_PMs[hash] = nil
                                    privatesay(player, "PMs have been enabled")
                                else
                                    privatesay(player, "PMs are already enabled")
                                end
                            end
                        else
                            privatesay(player, "Error 004: Invalid Syntax - /pm [on or off]")
                        end
                    elseif cmd == "/getlocation" then
                        Command_getlocation(player, t[1], t[2], count)
                    end
                    cmdlog(getname(player) .. "(Hash: " .. gethash(player) .. " IP: " .. getip(player) .. ") has executed: " .. message)
                else
                    sendresponse("Sorry - You cannot execute this command!", message, player)
                    cmdlog(getname(player) .. "(Hash: " .. gethash(player) .. " IP: " .. getip(player) .. ") " .. " tried to execute " .. cmd)
                end
            end
        end
    elseif ACCESS and not chatcommands then
        local bool
        if string.sub(t[1], 1, 1) == "/" then
            AllowChat = false
            bool = true
        elseif string.sub(t[1], 1, 1) == "\\" then
            AllowChat = false
            bool = true
        end
        if bool then
            sendresponse("Chat commands are currently disabled", message:sub(1, 1), player)
        end
    elseif message:sub(1, 1) == "/" or message:sub(1, 1) == "\\" and AllowChat == true and message ~= "/suicide" and message ~= "/back" and message ~= "/idle" then
        sendresponse("Sorry - You cannot execute this command!", "sv_", player)
    end
    if SPAM_MAX == nil then SPAM_MAX = 7 end
    if SPAM_TIMEOUT == nil then SPAM_TIMEOUT = 60 end
    if AllowChat == nil and AntiSpam ~= "off" and SPAM_MAX > 0 and SPAM_TIMEOUT > 0 and chattype >= 0 and chattype <= 2 then
        if AntiSpam == "all" then
            if not Spam_Table[ip] then
                Spam_Table[ip] = 1
            else
                Spam_Table[ip] = Spam_Table[ip] + 1
            end
        elseif AntiSpam == "players" and not ACCESS then
            if not Spam_Table[ip] then
                Spam_Table[ip] = 1
            else
                Spam_Table[ip] = Spam_Table[ip] + 1
            end
        end
    end
    if AllowChat == nil and anticaps and player ~= nil then
        return true, string.lower("[" .. tostring(resolveplayer(player)) .. "] " .. message)
    end
    if AllowChat == true and player ~= nil then
        return AllowChat, "[" .. tostring(resolveplayer(player)) .. "] " .. message
    else
        return AllowChat
    end
end

function report_player(id, count, info)
    local reporter = info[1]
    local player = info[2]
    local reason = info[3]

    local reason = tostring(reason) or "Unknown"
    -- Reporter Information
    local reporter_id = resolveplayer(reporter)
    local reporter_name = getname(reporter)
    local reporter_hash = gethash(reporter)
    local reporter_ip = getip(reporter)
    local reporter_ping = readword(getplayer(reporter) + 0xDC)
    -- Player Information
    local player_id = resolveplayer(player)
    local player_name = getname(player)
    local player_hash = gethash(player)
    local player_ip = getip(player)
    local Player_Ping = readword(getplayer(player) + 0xDC)
    -- Server Information
    local server = server_id
    local admins = { }
    for i = 0, 15 do
        if getplayer(i) then
            local hash = gethash(i)
            if Admin_Table[hash] then
                local temp = Admin_Table[hash].name
                table.insert(admins, temp)
            end
        end
    end
    local online_admins = table.concat(admins, ", ", 1, #admins)
    local server_info = map_name .. " - " .. Readstring(gametype_base, 0x0, 0x2C)
    local timestamp = os.date("%Y%m%d %H%M")
    -- Get KeyTerm --
    local key_term
    for k, v in pairs(KeyTerms) do
        for j = 1, #v do
            if string.find(reason, v[j]) then
                key_term = k
                break
            end
        end
    end


    local key_term = key_term or "Unknown"
    return 0
end

function activate_sandbox()
    svcmd("sv_name \"SANDBOX-" .. server_name .. "\"")
    svcmd("sv_password \"" .. SandBox_Password .. "\"")
end

function deactivate_sandbox()
    svcmd("sv_name \"" .. server_name .. "\"")
    svcmd("sv_password \"\"")
end

function OnServerCommand(player, command)

    local response = nil
    local temp = tokenizecmdstring(command)
    local cmd = temp[1]
    local ACCESS = getaccess(player)
    local permission
    if cmd ~= "cls" then
        if "sv_" ~= string.sub(cmd, 0, 3) then
            command = "sv_" .. command
        end
    end
    t = tokenizecmdstring(command)
    count = #t
    if player ~= nil and player ~= 255 then
        if (next(Admin_Table) ~= nil or next(IpAdmins) ~= nil) and ACCESS then
            permission = checkaccess(t[1], ACCESS, player)
        elseif next(Admin_Table) == nil and next(IpAdmins) == nil then
            permission = true
        end
    elseif player == nil or player == 255 then
        permission = true
    end
    if permission and Scrim_Mode then
        local Command = t[1]
        if string.sub(Command, 0, 3) == "sv_" then
            Command = string.sub(Command, 4)
        end
        for i = 0, #SCRIM_MODE_COMMANDS do
            if SCRIM_MODE_COMMANDS[i] then
                if Command == SCRIM_MODE_COMMANDS[i] then
                    sendresponse("This command is currently disabled.\nTurn Scrim Mode off to re-enable this command.", t[1], player)
                    local name = "The Server"
                    if player then name = getname(player) end
                    cmdlog(name .. " attempted to use " .. t[1] .. " during scrim mode.")
                    return false
                end
            end
        end
    end
    if permission then
        if t[1] == "sv_addrcon" then
            response = false
            Command_AddRconPassword(player, t[1], t[2], t[3], count)
        elseif t[1] == "sv_setafk" or t[1] == "sv_afk" then
            response = false
            Command_AFK(player, t[1], t[2], count)
        elseif t[1] == "sv_admin_list" or t[1] == "sv_a" and t[2] == "list" then
            response = false
            Command_AdminList(player, t[1], count)
        elseif t[1] == "sv_a" and t[2] == "del" then
            response = false
            Command_Admindel(player, t[1] .. " " .. t[2], t[3], count)
        elseif t[1] == "sv_admin_add" or t[1] == "sv_a" then
            response = false
            Command_Adminadd(player, t[1], t[2], t[3], t[4], count)
        elseif t[1] == "sv_admin_del" then
            response = false
            Command_Admindel(player, t[1], t[2], count)
        elseif t[1] == "sv_revoke" then
            response = false
            Command_Adminrevoke(player, t[1], t[2], count)
        elseif t[1] == "sv_alias" then
            response = false
            Command_Alias(player, t[1], t[2], count)
        elseif t[1] == "sv_adminblocker" then
            response = false
            Command_AdminBlocker(player, t[1], t[2], count)
        elseif t[1] == "sv_anticaps" then
            response = false
            Command_AntiCaps(player, t[1], t[2], count)
        elseif t[1] == "sv_antispam" then
            response = false
            Command_AntiSpam(player, t[1], t[2], count)
        elseif t[1] == "sv_ban" and player == nil then
            response = Command_Ban(player, t[1], t[2], t[3], count)
        elseif t[1] == "sv_balance" then
            response = false
            Command_BalanceTeams(player, t[1], count)
        elseif (t[1] == "sv_b" or t[1] == "sv_ban") and player ~= nil then
            response = false
            Command_Ban2(player, t[1], t[2], t[3], t[4], count)
        elseif t[1] == "sv_bos" then
            response = false
            Command_Bos(player, t[1], t[2], count)
        elseif t[1] == "sv_boslist" then
            response = false
            Command_Boslist(player, t[1], count)
        elseif t[1] == "sv_bosplayers" then
            response = false
            Command_Bosplayers(player, t[1], count)
        elseif t[1] == "sv_chatcommands" then
            response = false
            Command_ChatCommands(player, t[1], t[2], count)
        elseif t[1] == "sv_change_level" or t[1] == "sv_cl" then
            response = false
            Command_ChangeLevel(player, t[1], t[2], t[3], count)
        elseif t[1] == "sv_changeteam" or t[1] == "sv_ts" then
            response = false
            Command_Changeteam(player, t[1], t[2], count)
        elseif t[1] == "sv_crash" then
            response = false
            Command_Crash(player, t[1], t[2], count)
        elseif t[1] == "sv_cmds" then
            response = false
            Command_Commands(player, t[1], count)
        elseif t[1] == "sv_c" or t[1] == "sv_control" then
            response = false
            Command_Control(player, t[1], t[2], t[3], count)
        elseif t[1] == "sv_count" then
            response = false
            Command_Count(player, t[1], count)
        elseif t[1] == "sv_uniques_enabled" or t[1] == " sv_uniquecount" then
            response = false
            Command_CountUniques(player, t[1], t[2], count)
        elseif t[1] == "sv_damage" or t[1] == "sv_dmg" then
            response = false
            Command_DamageMultiplier(player, t[1], t[2], t[3], count)
        elseif t[1] == "sv_deathless" or t[1] == "sv_d" then
            response = false
            Command_Deathless(player, t[1], t[2], count)
        elseif t[1] == "sv_delrcon" then
            response = false
            Command_DelRconPassword(player, t[1], t[2], count)
        elseif t[1] == "sv_eject" or t[1] == "sv_e" then
            response = false
            Command_Eject(player, t[1], t[2], count)
        elseif t[1] == "sv_falldamage" then
            response = false
            Command_Falldamage(player, t[1], t[2], count)
        elseif t[1] == "sv_firstjoin_message" then
            response = false
            Command_FirstJoinMessage(player, t[1], t[2], count)
        elseif t[1] == "sv_follow" or t[1] == "sv_f" then
            response = false
            Command_Follow(player, t[1], t[2], count)
        elseif t[1] == "sv_gethash" then
            response = false
            Command_Gethash(player, t[1], t[2], count)

        elseif t[1] == "sv_vehicles" then
            response = false
            PlayersInVehicles(player, t[1], count)

        elseif t[1] == "sv_getip" then
            response = false
            Command_Getip(player, t[1], t[2], count)
        elseif t[1] == "sv_getloc" then
            response = false
            Command_Getloc(player, t[1], t[2], count)
        elseif t[1] == "sv_setgod" or t[1] == "sv_god" then
            response = false
            Command_Godmode(player, t[1], t[2], count)
        elseif t[1] == "sv_hash_check" then
            Command_Hashcheck(t[2])
        elseif t[1] == "sv_hash_duplicates" then
            response = false
            Command_HashDuplicates(player, t[1], t[2], count)
        elseif t[1] == "sv_cheat_hax" or t[1] == "sv_hax" then
            response = false
            Command_Hax(player, t[1], t[2], count)
        elseif t[1] == "sv_heal" or t[1] == "sv_h" then
            response = false
            Command_Heal(player, t[1], t[2], count)
        elseif t[1] == "sv_help" then
            response = false
            sendresponse(GetHelp(t[2]), t[1], player)
        elseif t[1] == "sv_hide" then
            response = false
            Command_Hide(player, t[1], t[2], count)
        elseif t[1] == "sv_hitler" then
            response = false
            if count == 1 then
                for c = 0, 15 do
                    if getplayer(c) then
                        kill(c)
                        sendresponse(getname(c) .. " was given a lethal injection", t[1], player)
                    end
                end
            else
                sendresponse("Error 004: Invalid Syntax: sv_hitler", t[1], player)
            end
        elseif t[1] == "sv_ipadminadd" then
            response = false
            Command_Ipadminadd(player, t[1], t[2], t[3], t[4], count)
        elseif t[1] == "sv_ipadmindelete" then
            response = false
            Command_ipadmindelete(player, t[1], t[2], count)
        elseif t[1] == "sv_ipban" then
            response = false
            Command_Ipban(player, t[1], t[2], t[3], t[4], count)
        elseif t[1] == "sv_ipbanlist" then
            response = false
            Command_Ipbanlist(player, t[1], count)
        elseif t[1] == "sv_iprangeban" then
            response = false
            Command_Iprangeban(player, t[1], t[2], t[3], t[4], count)
        elseif t[1] == "sv_iprangebanlist" then
            response = false
            Command_Iprangebanlist(player, t[1], count)
        elseif t[1] == "sv_info" or t[1] == "sv_i" then
            response = false
            Command_Info(player, t[1], t[2], count)
        elseif t[1] == "sv_infinite_ammo" or t[1] == "sv_infammo" then
            response = false
            Command_Infammo(player, t[1], t[2], count)
        elseif t[1] == "sv_ipunban" then
            response = false
            Command_Ipunban(player, t[1], t[2], count)
        elseif t[1] == "sv_iprangeunban" then
            response = false
            Command_Iprangeunban(player, t[1], t[2], count)
        elseif t[1] == "sv_invis" then
            response = false
            Command_Invis(player, t[1], t[2], t[3], count)
        elseif t[1] == "sv_k" or t[1] == "sv_kick" and player ~= nil then
            response = false
            Command_Kick(player, t[1], t[2], t[3], count)
        elseif t[1] == "sv_kill" then
            response = false
            Command_Kill(player, t[1], t[2], count)
        elseif t[1] == "sv_killspree" then
            response = false
            Command_KillingSpree(player, t[1], t[2], count)
        elseif t[1] == "sv_launch" then
            response = false
            Command_Launch(player, t[1], t[2], count)
        elseif t[1] == "sv_list" then
            response = false
            Command_List(player, t[1], t[2], count)
        elseif t[1] == "sv_scrim" or t[1] == "sv_lo3" then
            response = false
            Command_Lo3(player, t[1], count)
        elseif t[1] == "sv_login" or t[1] == "sv_l" then
            response = false
            Command_Login(player, t[1], t[2], t[3], count)
        elseif t[1] == "sv_map" or t[1] == "sv_m" then
            if command:find("commands") == nil then
                response = false
                Command_Map(player, command)
            end
        elseif t[1] == "sv_mnext" then
            response = false
            Command_Mapnext(player, t[1], count)
        elseif t[1] == "sv_reset" then
            response = false
            Command_Mapreset(player, t[1], count)
        elseif t[1] == "sv_move" or t[1] == "sv_j" then
            response = false
            Command_Move(player, t[1], t[2], t[3], t[4], t[5], count)
        elseif t[1] == "sv_mute" then
            response = false
            Command_Mute(player, t[1], t[2], count)
        elseif t[1] == "sv_multiteam_vehicles" then
            response = false
            Command_MultiTeamVehicles(player, t[1], t[2], count)
        elseif t[1] == "sv_nameban" or t[1] == "sv_n" then
            response = false
            Command_Nameban(player, t[1], t[2], count)
        elseif t[1] == "sv_namebanlist" then
            response = false
            Command_Namebanlist(player, t[1], count)
        elseif t[1] == "sv_nameunban" then
            response = false
            Command_Nameunban(player, t[1], t[2], count)
        elseif t[1] == "sv_noweapons" then
            response = false
            Command_Noweapons(player, t[1], t[2], count)
        elseif t[1] == "sv_os" or t[1] == "sv_o" then
            response = false
            Command_Overshield(player, t[1], t[2], count)
        elseif t[1] == "sv_pvtmessage" or t[1] == "sv_p" then
            response = false
            Command_PrivateMessage(player, t[1], t[2], count)
        elseif t[1] == "sv_pvtsay" or t[1] == "sv_privatesay" then
            response = false
            Command_Privatesay(player, t, count)
        elseif t[1] == "sv_players_more" or t[1] == "sv_pl" and t[2] == "more" then
            response = false
            Command_PlayersMore(player, t[1], count)
        elseif t[1] == "sv_players" or t[1] == "sv_pl" then
            response = false
            Command_Players(player, t[1], count)
        elseif t[1] == "sv_rconlist" then
            response = false
            Command_RconPasswordList(player, t[1], count)
        elseif t[1] == "sv_read" then
            response = false
            Command_Read(player, t[1], t[2], t[3], t[4], t[5], t[6], count)
        elseif t[1] == "sv_resetplayer" then
            response = false
            Command_ResetPlayer(player, t[1], t[2], count)
        elseif t[1] == "sv_resetweapons" then
            response = false
            Command_Resetweapons(player, t[1], t[2], count)
        elseif t[1] == "sv_resp" or t[1] == "sv_r" then
            response = false
            Command_Resp(player, t[1], t[2], t[3], count)
        elseif t[1] == "sv_rtv_enabled" then
            response = false
            Command_RTVEnabled(player, t[1], t[2], count)
        elseif t[1] == "sv_rtv_needed" then
            response = false
            Command_RTVRequired(player, t[1], t[2], count)
        elseif t[1] == "sv_serveradmin_message" then
            response = false
            Command_SAMessage(player, t[1], t[2], count)
        elseif t[1] == "sv_say" then
            response = false
            Command_Say(player, t, count)
        elseif t[1] == "sv_scrimmode" then
            response = false
            Command_ScrimMode(player, t[1], t[2], count)
        elseif t[1] == "sv_load" then
            response = false
            Command_ScriptLoad(player, command, count)
        elseif t[1] == "sv_unload" then
            response = false
            Command_ScriptUnload(player, command, count)
        elseif t[1] == "sv_enter" then
            response = false
            Command_Spawn(player, t[1], t[2], t[3], t[4], t[5], t[6], "enter", count)
        elseif t[1] == "sv_spawn" or t[1] == "sv_s" then
            response = false
            Command_Spawn(player, t[1], t[2], t[3], t[4], t[5], t[6], "spawn", count)
        elseif t[1] == "sv_give" then
            response = false
            Command_Spawn(player, t[1], t[2], t[3], t[4], t[5], t[6], "give", count)
        elseif t[1] == "sv_spammax" then
            response = false
            Command_SpamMax(player, t[1], t[2], count)
        elseif t[1] == "sv_spamtimeout" then
            response = false
            Command_SpamTimeOut(player, t[1], t[2], count)
        elseif t[1] == "sv_setammo" then
            response = false
            Command_Setammo(player, t[1], t[2], t[3], t[4], count)
        elseif t[1] == "sv_setassists" then
            response = false
            Command_Setassists(player, t[1], t[2], t[3], count)
        elseif t[1] == "sv_setcolor" then
            response = false
            Command_Setcolor(player, t[1], t[2], t[3], count)
        elseif t[1] == "sv_setdeaths" then
            response = false
            Command_Setdeaths(player, t[1], t[2], t[3], count)
        elseif t[1] == "sv_setfrags" then
            response = false
            Command_Setfrags(player, t[1], t[2], t[3], count)
        elseif t[1] == "sv_setkills" then
            response = false
            Command_Setkills(player, t[1], t[2], t[3], count)
        elseif t[1] == "sv_setmode" then
            response = false
            Command_Setmode(player, t[1], t[2], t[3], t[4], count)
        elseif t[1] == "sv_pass" then
            response = false
            Command_Setpassword(player, t[1], t[2], count)
        elseif t[1] == "sv_setscore" then
            response = false
            Command_Setscore(player, t[1], t[2], t[3], count)
        elseif t[1] == "sv_respawn_time" then
            response = false
            Command_Setresp(player, t[1], t[2], count)
        elseif t[1] == "sv_setplasmas" then
            response = false
            Command_Setplasmas(player, t[1], t[2], t[3], count)
        elseif t[1] == "sv_setspeed" or t[1] == "sv_spd" then
            response = false
            Command_Setspeed(player, t[1], t[2], t[3], count)
        elseif t[1] == "sv_specs" then
            response = false
            Command_Specs(player, t[1], count)
        elseif t[1] == "sv_mc" then
            response = false
            Command_StartMapcycle(player, t[1], count)
        elseif t[1] == "sv_superban" then
            response = false
            Command_Superban(player, t[1], t[2], t[3], count)
        elseif t[1] == "sv_suspend" then
            response = false
            Command_Suspend(player, t[1], t[2], t[3], count)
        elseif t[1] == "sv_status" then
            response = false
            Command_Status(player, t[1], count)
        elseif t[1] == "sv_takeweapons" then
            response = false
            Command_Takeweapons(player, t[1], t[2], count)
        elseif t[1] == "sv_tbagdet" then
            response = false
            Command_TbagDetection(player, t[1], t[2], count)
        elseif t[1] == "sv_test" then
            response = false
            Command_Test(player, t[1], t[2], t[3], t[4], t[5], count)
        elseif t[1] == "sv_teleport_pl" or t[1] == "sv_tp" then
            response = false
            Command_Teletoplayer(player, t[1], t[2], t[3], count)
        elseif t[1] == "sv_textban" then
            response = false
            Command_Textban(player, t[1], t[2], t[3], t[4], count)
        elseif t[1] == "sv_textbanlist" then
            response = false
            Command_Textbanlist(player, t[1], count)
        elseif t[1] == "sv_textunban" then
            response = false
            Command_Textunban(player, t[1], t[2], count)
        elseif t[1] == "sv_time_cur" then
            response = false
            Command_Timelimit(player, t[1], t[2], count)
        elseif t[1] == "sv_unbos" then
            response = false
            Command_Unbos(player, t[1], t[2], count)
        elseif t[1] == "sv_cheat_unhax" or t[1] == "sv_unhax" then
            response = false
            Command_Unhax(player, t[1], t[2], count)
        elseif t[1] == "sv_unhide" then
            response = false
            Command_Unhide(player, t[1], t[2], count)
        elseif t[1] == "sv_ungod" then
            response = false
            Command_Ungod(player, t[1], t[2], count)
        elseif t[1] == "sv_uninvis" then
            response = false
            Command_Uninvis(player, t[1], t[2], count)
        elseif t[1] == "sv_unmute" then
            response = false
            Command_Unmute(player, t[1], t[2], count)
        elseif t[1] == "sv_unsuspend" then
            response = false
            Command_Unsuspend(player, t[1], t[2], count)
        elseif t[1] == "sv_viewadmins" or t[1] == "sv_cur_admins" then
            response = false
            Command_Viewadmins(player, t[1], count)
        elseif t[1] == "sv_votekick_enabled" then
            response = false
            Command_VotekickEnabled(player, t[1], t[2], count)
        elseif t[1] == "sv_votekick_needed" then
            response = false
            Command_VotekickRequired(player, t[1], t[2], count)
        elseif t[1] == "sv_votekick_action" then
            response = false
            Command_VotekickAction(player, t[1], t[2], count)
        elseif t[1] == "sv_version_check" then
            Command_Versioncheck(t[2])
        elseif t[1] == "sv_welcomeback_message" then
            response = false
            Command_WelcomeBackMessage(player, t[1], t[2], count)
        elseif t[1] == "sv_write" or t[1] == "sv_w" then
            response = false
            Command_Write(player, t[1], t[2], t[3], t[4], t[5], t[6], count)
        elseif t[1] == "sv_stickman" then
            response = false
            registertimer(200, "Stickman")
        elseif t[1] == "sv_player_reporting" then
            response = false
            if t[2] == "true" or t[2] == "1" then
                player_reporting = true
            elseif t[2] == "false" or t[2] == "0" then
                player_reporting = false
            else
                sendresponse("Error 004: Invalid Syntax - sv_player_reporting [true/false]", t[1], player)
            end
        end
        if player ~= nil and response == false then
            cmdlog(getname(player) .. " (Hash:" .. gethash(player) .. " IP: " .. getip(player) .. ") has executed: '" .. command .. "'")
        end
    elseif ACCESS and not permission then
        response = false
        cmdlog(getname(player) .. " (Hash:" .. gethash(player) .. " IP: " .. getip(player) .. ") tried to execute: '" .. command .. "'")
        sendresponse("You cannot execute this command!", t[1], player)
    else
        response = false
        if player then
            cmdlog(">> S e c u r i t y  A l e r t <<\n" .. getname(player) .. "\nHash: " .. gethash(player) .. "\nIP: " .. getip(player) .. "\nOffence: Tried to execute: '" .. command .. "'")
            hprintf("\n--------------------------------------------------------------------------------------------\n		>> S e c u r i t y  A l e r t <<	>> S e c u r i t y  A l e r t <<\n" .. getname(player) .. "\nHash: " .. gethash(player) .. "\nIP: " .. getip(player) .. "\nDetails: Attempted to execute: '" .. command .. "'\n--------------------------------------------------------------------------------------------")
        end
        sendconsoletext("You are not an admin. This has been reported!", t[1], player)
    end
    return response
end

function OnServerCommandAttempt(player, command, password)
    local ACCESS = getaccess(player)
    local permission
    if player ~= nil and player ~= 255 then
        if next(Admin_Table) ~= nil or next(IpAdmins) ~= nil and ACCESS then
            permission = checkaccess(t[1], ACCESS, player)
        elseif next(Admin_Table) == nil and next(IpAdmins) == nil then
            permission = true
            ACCESS = 0
        end
    end
    local bool = true
    local bad_password = true
    local allowed_to_execute = false
    if ACCESS then
        bool = false
        local temp_bool = false
        if permission then
            allowed_to_execute = true
            for k, v in pairs(RCON_PASSWORDS) do
                if RCON_PASSWORDS[k] ~= { } and RCON_PASSWORDS[k] ~= nil then
                    for key, value in ipairs(RCON_PASSWORDS[k]) do
                        if RCON_PASSWORDS[k][key].password == password then
                            if RCON_PASSWORDS[k][key].level == -1 then
                                svcmdplayer(command, player)
                            else
                                if tonumber(ACCESS) <= tonumber(RCON_PASSWORDS[k][key].level) then
                                    svcmdplayer(command, player)
                                else
                                    allowed_to_execute = false
                                end
                            end
                            temp_bool = true
                            bad_password = false
                            break
                        end
                    end
                end
                if temp_bool then
                    break
                end
            end
        end
    end
    if bool then
        if player then
            cmdlog(">> S e c u r i t y  A l e r t <<" .. getname(player) .. "\nHash:" .. gethash(player) .. "\nIP: " .. getip(player) .. "\nOffence: Tried to execute: '" .. command .. "'")
            hprintf("\n--------------------------------------------------------------------------------------------\n		>> S e c u r i t y  A l e r t <<	>> S e c u r i t y  A l e r t <<\n" .. getname(player) .. "\nHash: " .. gethash(player) .. "\nIP: " .. getip(player) .. "\nDetails: Attempted to execute: '" .. command .. "'\n--------------------------------------------------------------------------------------------")
        end
        sendconsoletext("You are not an admin. This has been reported!", t[1], player)
    elseif not allowed_to_execute then
        cmdlog(getname(player) .. " (Hash:" .. gethash(player) .. " IP: " .. getip(player) .. ") tried to use: '" .. password .. "'")
        sendresponse("You do not have ACCESS to this rcon! - This has been logged.", password, player, false)
    elseif bad_password then
        cmdlog(getname(player) .. " (Hash:" .. gethash(player) .. " IP: " .. getip(player) .. ") tried to use '" .. password .. "' as an rcon password")
        sendresponse("That is not an rcon password! - This has been logged.", password, player, false)
    end
end

function isplayerdead(player)

    local m_objectId = getplayerobjectid(player)
    if m_objectId then
        local m_object = getobject(m_objectId)
        if m_object then
            return false
        else
            return true
        end
    end
end

function OnPlayerJoin(player)

    Current_Players = Current_Players + 1
    Kill_Command_Count[gethash(player)] = 0
    local name = getname(player)
    local hash = gethash(player)
    local ip = getip(player)
    local port = getport(player)
    local id = resolveplayer(player)
    afk[player + 1] = { }
    tbag[player] = { }
    Players_List[player].name = name
    Players_List[player].hash = hash
    Players_List[player].ip = ip
    dmgmultiplier[ip] = 1.0
    for k, v in pairs(Banned_Hashes) do
        if v == hash then
            table.remove(Banned_Hashes, k)
            svcmd("sv_ban " .. player + 1)
        end
    end
    if uniques_enabled then
        local bool
        for k, v in pairs(Unique_Table) do
            if hash == v[1] or ip == v[2] then
                bool = true
                if wb_message then
                    privatesay(player, "Welcome back " .. name .. "")
                    respond("Welcome Back" .. name)
                end
                break
            end
        end
        if not bool then
            Unique_Table[name] = { hash, ip }
            UNIQUES = UNIQUES + 1


            if firstjoin_message then
                say("This is " .. name .. "'s first time in the server unique player #: 563" .. tostring(UNIQUES))
            end


        end
    end
    if sa_message then
        if IpAdmins[ip] or Admin_Table[hash] then
            respond("Admin Notice: " .. name .. " is an Admin.")
            -- 			say("Server Admin has joined the game: " .. name, 1)
        end
    end
    if multiteam_vehicles then
        writebyte(getplayer(player) + 0x20, 0)
    end
    if IpAdmins[ip] or Admin_Table[hash] then
        WelcomeAdmin(player)
    end
    -- 	writealias(player) -- originally disabled
    -- 	local ping = getping(player) or "Unknown" -- originally disabled
    local ping = readword(getplayer(player) + 0xDC)
    local port = getport(player)
    local id = resolveplayer(player)
    -- 	local line = "(ping: %s)." -- originally disabled
    -- 	line = string.format(name, line, ip, port, ping) -- originally disabled

    local name = getname(player)
    local player_team = getteam(player)
    if team_play then
        if player_team == 0 then
            player_team = "the Red Team."
        elseif player_team == 1 then
            player_team = "the Blue Team."
        else
            player_team = "Hidden"
        end
    else
        player_team = "the FFA"
    end
    hprintf("Access:   " .. name .. " connected successfully.")
    hprintf("Connection Details:   IP:  (" .. ip .. "),   Port:  (" .. port .. "),  Ping:  (" .. ping .. ")")
    hprintf("Assigned ID number:   (" .. id .. ")")
    hprintf("Team:   {" .. tostring(player) .. "} has been assigned to " .. player_team)
    hprintf("---------------------------------------------------------------------------------------------------")
    -- 	sendconsoletext(player, "{" .. tostring(player) .. "}, you have been assigned to " ..player_team, false)
    -- registertimer(1000*30,"Delay",player)
end


function Delay(id, count, player)
    if getplayer(player) then
        privatesay(player, Announce_Message, false)
    end
    return false
end


function writealias(player)
    local hash = gethash(player)
    local name = getname(player)
    local timestamp = os.date("%Y%m%d %H%M")
    local b, c, h = http.request(tostring(requestprefex) .. "getalias&name=" .. tostring(name) .. "&hash=" .. tostring(hash) .. "")
    -- data = b
    if tostring(b) == "0" then
        local query = base64.encode("INSERT INTO `ozc_alias`(`alias_id`, `alias_hash`, `alias_name`) VALUES (NULL,\'" .. tostring(hash) .. "\',\'" .. tostring(name) .. "\')")
        local b = http.request(tostring(requestprefex) .. "query&q=" .. query)
        if tostring(b) == "0" then
            Write_Error("on writealias - 0 returned")
        elseif tostring(b) ~= "1" then
            Write_Error("on writealias - " .. tostring(b))
        end
        hprintf(tostring(name) .. " not found in DB - Hash " .. tostring(hash))
    elseif tostring(b) == "1" then
        hprintf(tostring(name) .. " found in DB - Hash " .. tostring(hash))
    else
        Write_Error("on writealias - Failed to query database")
    end
end

function WelcomeAdmin(player)
    local a_hash = gethash(player)
    local a_name = getname(player)
    local a_ip = getip(player)
    Admin_Count = Admin_Count + 1
    local vip_found = false
    local tempvip = false
    for k, v in pairs(VIP_LIST) do
        if a_hash == v then
            vip_found = true
            break
        end
    end
    if vip_found == true then
        if string.find(a_name, "OWV") ~= nil then
            tempvip = false
        else
            vip[a_hash] = { "1" }
            tempvip = true
            Admin_Count = Admin_Count - 1
        end
    end

    for k, v in pairs(Admin_Table) do
        if k == a_hash then
            admin_alias = Admin_Table[a_hash].name
            break
        end
    end
    if tempvip == true then
        privatesay(player, "Welcome to " .. tostring(server_id) .. " " .. tostring(admin_alias) .. " You are currently completely anonymous!", false)
        if Admin_Count == 1 then
            privatesay(player, "There is currently (1) other Admin in the server. Enjoy, and have fun!", false)
        else
            privatesay(player, "There are currently (" .. tostring(Admin_Count) .. ") other Admins in the server. Enjoy, and have fun!", false)
        end
    else
        privatesay(player, "Welcome to " .. tostring(server_id) .. " " .. tostring(admin_alias) .. ". Your current alias is " .. tostring(a_name), false)
        if Admin_Count == 1 then
            privatesay(player, "You are the only Admin in the server. Enjoy, and have fun!", false)
        else
            privatesay(player, " There are currently (" .. tostring(Admin_Count) .. ") Admins in the server. Enjoy, and have fun!", false)
        end
    end
end

function Write_Error(Error)
    local file = io.open(string.format("%s\\logs\\Script Errors.txt", profilepath), "a")
    if file then
        local timestamp = os.date("[%d/%m/%Y @ %H:%M:%S]")
        local line = string.format("%s\t%s\n", timestamp, tostring(Error))
        file:write(line)
        file:close()
    end
end

function OnPlayerLeave(player)
    cleanupdrones(player)
    Current_Players = Current_Players - 1
    local id = resolveplayer(player)
    local name = getname(player)
    local ip = getip(player)
    local hash = gethash(player)
    if Temp_Admins[ip] then
        Temp_Admins[ip] = nil
    end
    dmgmultiplier[ip] = 1.0
    Bos_Table[id] = name .. "," .. gethash(player) .. "," .. ip
    hidden[id] = nil
    afk[id] = { }
    gods[ip] = nil
    Player_Ping[id] = 0

    local vip_found = false
    for k, v in pairs(VIP_LIST) do
        if hash == v then
            vip_found = true
            vip[hash] = { "0" }
            break
        end
    end
    if vip_found == false and IpAdmins[ip] or Admin_Table[hash] then
        Admin_Count = Admin_Count - 1
    end

    GRAVITY[player] = nil

    -- local timestamp = os.date ("%H:%M:%S, %d/%m/%Y:")
    -- local name = getname(player)
    -- local id = resolveplayer(player)
    -- local port = getport(player)
    -- local ip = getip(player)
    -- local ping = readword(getplayer(player) + 0xDC)
    -- local hash = gethash(player)
    -- 	hprintf("P L A Y E R   Q U I T   T H E   G A M E")	
    -- 	hprintf("-  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -")
    -- 	hprintf(name .. " (" .. id .. ")   -   Quit The Game.")
    -- 	hprintf("IP Address: (".. ip ..")   Quit Time: (" ..timestamp.. ")   Player Ping: (" ..ping.. ")")
    -- 	hprintf("CD Hash: " ..hash)
    -- 	hprintf("-  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -")


end

function OnPlayerKill(killer, victim, mode)
    cleanupdrones(victim)
    hidden[resolveplayer(victim)] = nil
    gods[getip(victim)] = nil
    GRAVITY[victim] = nil
    if respset then
        local m_player = getplayer(victim)
        writedword(m_player + 0x2c, resptime * 33)
    end
    if mode == 4 then
        if tbag_detection then
            tbag[victim] = { }

            tbag[killer] = { }
            tbag[killer].count = 0
            tbag[killer].name = getname(victim)
            if Victim_Coords[victim] == nil then Victim_Coords[victim] = { } end
            if Victim_Coords[victim].x then
                tbag[killer].x = Victim_Coords[victim].x
                tbag[killer].y = Victim_Coords[victim].y
                tbag[killer].z = Victim_Coords[victim].z
            end
        end
        if killing_spree then
            local k_player = getplayer(killer)
            local k_name = getname(killer)
            local spree = readword(k_player + 0x96)
            local multikill = readword(k_player + 0x98)
            if multikill == 2 then
                privateSay(killer, "Double Kill")
            elseif multikill == 3 then
                privateSay(killer, "Triple Kill")
            elseif multikill == 4 then
                privateSay(killer, "OverKill")
            elseif multikill == 5 then
                privateSay(killer, "Killtacular")
            elseif multikill == 6 then
                privateSay(killer, "Killtrocity")
            elseif multikill == 7 then
                privateSay(killer, "Killimanjaro")
            elseif multikill == 8 then
                privateSay(killer, "Killtastrophe")
            elseif multikill == 9 then
                privateSay(killer, "Killpocalypse")
            elseif multikill >= 10 then
                privateSay(killer, "Killionaire")
            end
            if spree == 5 then
                Say(k_name .. " is on a Killing Spree!", 1, killer)
                privateSay(killer, "You're smashing them!")
            elseif spree == 10 then
                Say(k_name .. " is on a Killing Frenzy...", 1, killer)
                privateSay(killer, "Hoorah!")
            elseif spree == 15 then
                Say(k_name .. " is on a Running Riot", 1, killer)
                privateSay(killer, "Target Neutralized!")
            elseif spree == 20 then
                Say(k_name .. " is on a Rampage", 1, killer)
                privateSay(killer, "Another one bites the dust...")
            elseif spree == 25 then
                Say(k_name .. " is Untouchable", 1, killer)
                privateSay(killer, "Get some!")
            elseif spree == 30 then
                Say(k_name .. " is Invincible", 1, killer)
                privateSay(killer, "Invincible")
            elseif spree == 35 then
                Say(k_name .. " is Inconceivable", 1, killer)
                privateSay(killer, "Inconceivable")
            elseif spree >= 40 and spree % 5 == 0 then
                Say(k_name .. " is Unfrigginbelievable", killer)
                privateSay(killer, "Unfrigginbelievable")
            end
        end
    end
end

function OnPlayerCrouch(player)
    if tbag[player].count == nil then
        tbag[player].count = 0
    end
    tbag[player].count = tbag[player].count + 1
    if tbag[player].count == 4 then
        tbag[player].count = 0
        say("«« O W N A G E »»   " .. getname(player) .. " is t-bagging " .. tbag[player].name .. "!", false)
        hprintf("«« O W N A G E »»   " .. getname(player) .. " is t-bagging " .. tbag[player].name .. "!")
        tbag[player].name = nil
    end
    return true
end

function OnPlayerSpawn(player)
    local ip = getip(player)
    local m_objectId = getplayerobjectid(player)
    if m_objectId then
        if deathless then
            local m_object = getobject(m_objectId)
            writefloat(m_object + 0xE0, 9999999999)
            writefloat(m_object + 0xE4, 9999999999)
        end
        if noweapons or Noweapons[ip] then
            local m_object = getobject(m_objectId)
            for i = 0, 3 do
                local weapID = readdword(m_object + 0x2F8 + i * 4)
                local weap = getobject(weapID)
                if weap then
                    destroyobject(weapID)
                end
            end
        end
        if colorspawn == nil then colorspawn = { } end
        if colorspawn[player] == nil then colorspawn[player] = { } end
        if colorspawn[player][1] then
            movobjectcoords(m_objectId, colorspawn[player][1], colorspawn[player][2], colorspawn[player][3])
            colorspawn[player] = { }
        end
        if Suspend_Table[ip] then
            Suspend_Table[ip] = nil
        end
        if Ghost_Table[ip] then
            Ghost_Table[ip] = nil
        end
    end
end

function OnClientUpdate(player)
    local id = resolveplayer(player)
    local m_objectId = getplayerobjectid(player)
    if m_objectId then
        local m_object = getobject(m_objectId)
        if not Scrim_Mode then
            if m_object then
                local x, y, z = getobjectcoords(m_objectId)
                if x ~= loc[id][1] or y ~= loc[id][2] or z ~= loc[id][3] then
                    if not loc[id][1] then
                        loc[id][1] = x
                        loc[id][2] = y
                        loc[id][3] = z
                    elseif m_object then
                        local result = OnPositionUpdate(player, m_objectId, x, y, z)
                        if result == 0 then
                            movobjectcoords(m_objectId, loc[id][1], loc[id][2], loc[id][3])
                        else
                            loc[id][1] = x
                            loc[id][2] = y
                            loc[id][3] = z
                        end
                    end
                end
            end
        end
        if tbag_detection then
            if tbag[player] == nil then
                tbag[player] = { }
            end
            if tbag[player].name and tbag[player].x then
                if not isinvehicle(player) then
                    if Check_Sphere(m_objectId, tbag[player].x, tbag[player].y, tbag[player].z, 5) then
                        local obj_crouch = readbyte(m_object + 0x2A0)
                        if obj_crouch == 3 and crouch[id] == nil then
                            crouch[id] = OnPlayerCrouch(player)
                        elseif obj_crouch ~= 3 and crouch[id] ~= nil then
                            crouch[id] = nil
                        end
                    end
                end
            end
        end
    end
    local vehiId = GRAVITY[player]
    if vehiId then
        local m_player = getplayer(player)
        local objId = readdword(m_player, 0x34)
        local m_object = getobject(objId)
        local m_vehicle = getobject(vehiId)
        local x_aim = readfloat(m_object, 0x230)
        local y_aim = readfloat(m_object, 0x234)
        local z_aim = readfloat(m_object, 0x238)
        local x = readfloat(m_object, 0x5C)
        local y = readfloat(m_object, 0x60)
        local z = readfloat(m_object, 0x64)
        local dist = 4
        writefloat(m_vehicle, 0x5C, x + dist * math.sin(x_aim))
        writefloat(m_vehicle, 0x60, y + dist * math.sin(y_aim))
        writefloat(m_vehicle, 0x64, z + dist * math.sin(z_aim) + 0.5)
        writefloat(m_vehicle, 0x68, 0)
        writefloat(m_vehicle, 0x6C, 0)
        writefloat(m_vehicle, 0x70, 0.01285)
    end
end

function ActiveVehicle(id, count, info)

    local vehiId = info[1]
    local player = info[2]
    local m_vehicle = getobject(vehiId)
    if m_vehicle then
        if vehicles[vehiId] == player then
            if getplayer(player) then
                local vx = readfloat(m_vehicle, 0x68)
                local vy = readfloat(m_vehicle, 0x6C)
                local vz = readfloat(m_vehicle, 0x70)
                local velocity = math.sqrt(vx ^ 2 + vy ^ 2 + vz ^ 2)
                if velocity == 0 then
                    activetime[vehiId] = activetime[vehiId] or 100 - 1
                    if activetime[vehiId] <= 0 then
                        vehicles[vehiId] = nil
                        return false
                    end
                end
            end
        else
            return false
        end
    end

    return true
end

function OnObjectInteraction(player, objId, mapId)
    local Pass = nil
    if noweapons or Noweapons[getip(player)] then
        local name, type = gettaginfo(mapId)
        if type == "weap" then
            Pass = false
        end
    end
    return Pass
end

function OnWeaponReload(player, weapon)
    local reload = nil
    if infammo then
        writeword(getobject(weapon) + 0x2B6, 9999)
        writeword(getobject(weapon) + 0x2B8, 9999)
        updateammo(weapon)
        reload = false
    end
    return reload
end

function OnVehicleEject(player, forceEject, relevant)
    local m_objectId = getplayerobjectid(player)
    if m_objectId then
        local m_object = getobject(m_objectId)
        local vehicleId = readdword(m_object + 0x11C)
        if vehicleId then
            writebit(getobject(vehicleId) + 0x10, 7, 0)
        end
    end
    return nil
end

function OnDamageApplication(receiver_id, causer_id, tagid, hit, backtap)
    if causer_id then
        local player = objectidtoplayer(causer_id)
        if player then
            if mode[getip(player)] == "destroy" then
                if tagid ~= 0xE63504C1 then
                    destroyobject(receiver_id)
                end
            elseif mode[getip(player)] == "entergun" then
                entervehicle(player, receiver_id, 0)
            end
        end
    end
end

function OnDamageLookup(receiver_id, causer_id, mapId)
    if receiver_id and tbag_detection then
        local player = objectidtoplayer(receiver_id)
        if player then
            local x, y, z = getobjectcoords(receiver_id)
            if Victim_Coords[player] == nil then
                Victim_Coords[player] = { }
            end
            if Victim_Coords[player] then
                Victim_Coords[player].x = x
                Victim_Coords[player].y = y
                Victim_Coords[player].z = z
            end
        end
    end
    if causer_id and receiver_id then
        local c_player = objectidtoplayer(causer_id)
        local r_player = objectidtoplayer(receiver_id)
        if r_player and c_player and c_player ~= r_player then
            local c_ip = getip(c_player)
            if dmgmultiplier[c_ip] ~= 1 then
                odl_multiplier(dmgmultiplier[c_ip])
            end
            if multiteam_vehicles then
                local count = r_player
                while (getteam(c_player) == count) do
                    count = count + 1
                end
                writebyte(getplayer(r_player) + 0x20, count)
                registertimer(100, "multiteamtimer", r_player)
            end
        end
    end
    local tagname = gettaginfo(mapId)
    if deathless and tagname ~= "globals\\distance" and tagname ~= "globals\\falling" then
        return false
    end
    if deathless or not falldamage then
        if (tagname == "globals\\distance" or tagname == "globals\\falling") then
            odl_multiplier(0.001)
        end
    end

    if tagname == "weapons\\plasma rifle\\bolt"
        or tagname == "weapons\\assault rifle\\bullet"
        or tagname == "weapons\\flamethrower\\flame"
        or tagname == "weapons\\needler\\mp_needle"
        or tagname == "weapons\\pistol\\bullet"
        or tagname == "weapons\\plasma pistol\\bolt"
        or tagname == "weapons\\plasma rifle\\charged bolt"
        or tagname == "weapons\\rocket launcher\\rocket"
        or tagname == "weapons\\shotgun\\pellet"
        or tagname == "weapons\\sniper rifle\\sniper bullet"
    then

        local c_object = getobject(causer_id)
        if c_object then
            local c_player = objectaddrtoplayer(c_object)
            if c_player then
                local c_hash = gethash(c_player)
                if c_hash then
                    if mode[c_hash] == "gravitygun" then
                        local player = objectidtoplayer(causer_id)
                        if player then
                            local m_causer = getobject(causer_id)
                            local m_receiver = getobject(receiver_id)
                            if m_receiver and m_causer then
                                local mapId = readdword(m_receiver)
                                local tagname, tagtype = gettaginfo(mapId)
                                if tagtype == "vehi" then
                                    if GRAVITY[player] then
                                        GRAVITY[player] = nil
                                        writebit(m_receiver + 0x10, 5, 0)
                                        local x_aim = readfloat(m_causer, 0x230)
                                        local y_aim = readfloat(m_causer, 0x234)
                                        local z_aim = readfloat(m_causer, 0x238)
                                        local vel = 1
                                        writefloat(m_receiver, 0x68, vel * math.sin(x_aim))
                                        writefloat(m_receiver, 0x6C, vel * math.sin(y_aim))
                                        writefloat(m_receiver, 0x70, vel * math.sin(z_aim))
                                        registertimer(10, "ActiveVehicle", { receiver_id, player })
                                    else
                                        local bool

                                        for p, r in pairs(GRAVITY) do
                                            if r == receiver_id then
                                                bool = true
                                            end
                                        end

                                        if not bool then
                                            GRAVITY[player] = receiver_id
                                            vehicles[receiver_id] = player
                                            writebit(m_receiver + 0x10, 5, 0)
                                            local m_player = getplayer(player)
                                            local xy_aim = readfloat(m_player, 0x138)
                                            local z_aim = readfloat(m_player, 0x13C)
                                            local dist = 4
                                            local x = readfloat(m_causer, 0x5C)
                                            local y = readfloat(m_causer, 0x60)
                                            local z = readfloat(m_causer, 0x64)
                                            writefloat(m_receiver, 0x5C, x + dist * math.cos(xy_aim))
                                            writefloat(m_receiver, 0x60, y + dist * math.sin(xy_aim))
                                            writefloat(m_receiver, 0x64, z + dist * math.sin(z_aim) + 0.5)
                                            writefloat(m_receiver, 0x68, 0)
                                            writefloat(m_receiver, 0x6C, 0)
                                            writefloat(m_receiver, 0x70, 0)
                                            local angular_velocity_x = readfloat(m_receiver, 0x8C)
                                            local angular_velocity_y = readfloat(m_receiver, 0x90)
                                            local angular_velocity_z = readfloat(m_receiver, 0x94)
                                            writefloat(m_receiver, 0x8C, .2)
                                            writefloat(m_receiver, 0x90, .3)
                                            writefloat(m_receiver, 0x94, .05)
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end

    elseif tagname == "globals\\vehicle_collision" then

        if vehicles[causer_id] and receiver then
            local m_player = getplayer(vehicles[causer_id])
            if m_player then
                local objId = readdword(m_player, 0x34)
                applydmgtag(receiver, gettagid("jpt!", "weapons\\rocket launcher\\explosion"), 500, objId)
                return false
            end
        end
    end
    return nil
end

function OnObjectCreation(m_objectId)
    local mapId = TempObjectTable[1]
    local player = TempObjectTable[3]
    for i = 25, 42 do
        if objects ~= { } and objects[i] ~= nil and objects[i][3] ~= nil and mapId ~= nil then
            if objects[i][3] == mapId then
                if player then
                    if mode[getip(player)] == "portalgun" then
                        registertimer(20, "portalgunTimer", { getobject(m_objectId), player })
                    elseif mode[getip(player)] == "spawngun" then
                        registertimer(20, "spawngunTimer", { getobject(m_objectId), player })
                    end
                    break
                end
            end
        end
    end
end

function OnObjectCreationAttempt(mapId, parentId, player)
    TempObjectTable = { mapId, parentId, player }
    return nil
end

function OnPositionUpdate(player, m_objectId, x, y, z)
    local id = resolveplayer(player)
    if Control_Table ~= nil and Control_Table[id] and Control_Table[id][1] then
        for i = 1, #Control_Table[id] do
            local victim = Control_Table[id][i]
            local m_playerObjId = getplayerobjectid(victim)
            if m_playerObjId then
                local m_object = getobject(m_playerObjId)
                if m_object then
                    local m_vehicle = getobject(readdword(m_object + 0x11C))
                    if m_vehicle == nil then
                        local m_controlObject = getobject(m_objectId)
                        local x_vel = readfloat(m_controlObject + 0x68)
                        local y_vel = readfloat(m_controlObject + 0x6C)
                        writefloat(m_object + 0x68, x_vel)
                        writefloat(m_object + 0x6C, y_vel)
                    end
                end
            end
        end
    end
    return 1
end

function Command_AddRconPassword(executor, command, password, level, count)
    if count == 2 or count == 3 then
        local bool = true
        for k, v in pairs(RCON_PASSWORDS) do
            if RCON_PASSWORDS[k] ~= { } and RCON_PASSWORDS[k] ~= nil then
                for key, value in ipairs(RCON_PASSWORDS[k]) do
                    if RCON_PASSWORDS[k][key].password == password then
                        bool = false
                    end
                end
            end
        end
        if bool then
            if string.len(password) > 3 then
                if level then
                    if Access_Table[tonumber(level)] then
                        RCON_PASSWORDS[RCON_Passwords_ID] = { }
                        table.insert(RCON_PASSWORDS[RCON_Passwords_ID], { ["password"] = password, ["level"] = level })
                        RCON_Passwords_ID = RCON_Passwords_ID + 1
                        sendresponse(password .. " has been added as an rcon password", command, executor)
                    else
                        sendresponse("That is not a level", command, executor)
                    end
                else
                    RCON_PASSWORDS[RCON_Passwords_ID] = { }
                    table.insert(RCON_PASSWORDS[RCON_Passwords_ID], { ["password"] = password, ["level"] = - 1 })
                    RCON_Passwords_ID = RCON_Passwords_ID + 1
                    sendresponse(password .. " has been added as an rcon password", command, executor)
                end
            else
                sendresponse(password .. " is too short to be an rcon password", command, executor)
            end
        else
            sendresponse(password .. " is already an rcon password", command, executor)
        end
    else
        sendresponse("Error 004: Invalid Syntax: " .. command .. " [password] {level}", command, executor)
    end
end

function Command_Adminadd(executor, command, player, nickname, level, count)
    if count == 4 and tonumber(level) then
        if string.len(player) < 32 then
            local player = tonumber(player) -1
            if getplayer(player) then
                local hash = gethash(player)
                if not Admin_Table[hash] then
                    if tonumber(level) <= #Access_Table then
                        Admin_Table[hash] = { }
                        Admin_Table[hash].level = level
                        Admin_Table[hash].name = nickname
                        sendresponse(getname(player) .. " is now a hash admin", command, executor)
                    else
                        sendresponse("Error 006: Invalid Level", command, executor)
                    end
                else
                    sendresponse(getname(player) .. " is already a hash admin", command, executor)
                end
            else
                sendresponse("Error 005: Invalid Player", command, executor)
            end
        elseif string.len(player) == 32 then
            if nickname then
                if not Admin_Table[player] then
                    if tonumber(level) <= #Access_Table then
                        Admin_Table[player] = { }
                        Admin_Table[player].level = level
                        Admin_Table[player].name = nickname
                        sendresponse(nickname .. " is now a hash admin", command, executor)
                    else
                        sendresponse("Error 006: Invalid Level", command, executor)
                    end
                else
                    sendresponse(nickname .. " is already an admin", command, executor)
                end
            end
        else
            sendresponse("Error 008: Invalid Hash", command, executor)
        end
    else
        sendresponse("Error 004: Invalid Syntax: " .. command .. " [player or hash] [nickname] [level]", command, executor)
    end
end

function Command_Admindel(executor, command, nickname, count)
    if count == 2 and tonumber(ID) or count == 3 and(t[2] == "del") then
        if type(Admin_Table) ~= nil then
            local bool = true
            for k, v in pairs(Admin_Table) do
                if Admin_Table[k] then
                    if Admin_Table[k].name == nickname then
                        Admin_Table[k] = nil
                        bool = false
                    end
                end
            end
            if bool then
                sendresponse("There are no hash admins with a nickname of '" .. nickname .. "'", command, executor)
            else
                sendresponse(nickname .. " is no longer a hash admin", command, executor)
            end
        else
            sendresponse("There are no hash admins on this server.", command, executor)
        end
    else
        sendresponse("Error 004: Invalid Syntax: " .. command .. " [nickname]", command, executor)
    end
end

function Command_Adminrevoke(executor, command, player, count)
    if count == 2 then
        local players = getvalidplayers(player, executor)
        if players then
            for j = 1, #players do
                local hash = gethash(players[j])
                local ip = getip(players[j])
                if IpAdmins[ip] or Admin_Table[hash] then
                    Admin_Table[hash] = nil
                    IpAdmins[ip] = nil
                    sendresponse(getname(players[j]) .. " is no longer an admin", command, executor)
                else
                    sendresponse(getname(players[j]) .. " is not an admin", command, executor)
                end
            end
        else
            sendresponse("Error 005: Invalid Player", command, executor)
        end
    else
        sendresponse("Error 004: Invalid Syntax: " .. command .. " [player]", command, executor)
    end
end

function Command_AFK(executor, command, player, count)
    if count == 1 then
        if executor ~= nil then
            local id = resolveplayer(executor)
            local m_player = getplayer(executor)
            afk[id][1] = true
            sendresponse("You are now afk", command, executor)
        else
            sendresponse("Error 005: Invalid Player", command, executor)
        end
    elseif count == 2 then
        local players = getvalidplayers(player, executor)
        if players then
            for i = 1, #players do
                local id = resolveplayer(players[i])
                afk[id][1] = true
                sendresponse(getname(players[i]) .. " is now afk", command, executor)
            end
        else
            sendresponse("Error 005: Invalid Player", command, executor)
        end
    else
        sendresponse("Error 004: Invalid Syntax: " .. command .. " {player}", command, executor)
    end
end

function Command_AdminList(executor, command, count)
    if count == 1 or t[2] == "list" then
        sendresponse("Showing both IP Admins and Hash Admins.", command, executor)
        sendresponse("[Name] - [Level] - [Admin Type]", command, executor)
        local admins = { }
        for k, v in pairs(Admin_Table) do
            local name = Admin_Table[k].name
            local level = Admin_Table[k].level
            admins[name] = { "hash", "notip", level }
        end
        for k, v in pairs(IpAdmins) do
            local name = IpAdmins[k].name
            local level = IpAdmins[k].level
            if admins[name] and admins[name] ~= { } then
                admins[name][2] = "ip"
            else
                admins[name] = { "nothash", "ip", level }
            end
        end
        for k, v in pairs(admins) do
            local message = ""
            if admins[k][1] == "hash" and admins[k][2] == "ip" then
                message = k .. " - " .. admins[k][3] .. " - Hash admin  IP Admin"
            elseif admins[k][1] == "hash" then
                message = k .. " - " .. admins[k][3] .. " - Hash Admin"
            elseif admins[k][2] == "ip" then
                message = k .. " - " .. admins[k][3] .. " - IP Admin"
            end
            sendresponse(message, command, executor)
        end
    else
        sendresponse("Error 004: Invalid Syntax: " .. command, command, executor)
    end
end

function Command_Alias(executor, command, player, count)
    if count == 2 then
        local players = getvalidplayers(player, executor)
        if players then
            if executor ~= nil then
                for i = 1, #players do
                    svcmdplayer("sv_alias_hash " .. resolveplayer(players[i]), executor)
                end
            else
                for i = 1, #players do
                    svcmd("sv_alias_hash " .. resolveplayer(players[i]), false)
                end
            end
        else
            sendresponse("Error 005: Invalid Player", command, executor)
        end
    else
        sendresponse("Error 004: Invalid Syntax: " .. command .. " [player]", command, executor)
    end
end

function Command_AdminBlocker(executor, command, type, count)
    if count == 1 then
        if admin_blocker == 0 then
            sendresponse("Admins can kick/ban another admin", command, executor)
        elseif admin_blocker == 1 then
            sendresponse("Admins can't kick/ban another admin with higher level.", command, executor)
        elseif admin_blocker == 2 then
            sendresponse("Admins can't kick/ban another admin with higher or equal level.", command, executor)
        elseif admin_blocker == 3 then
            sendresponse("Admins can't kick/ban another admins unless they can do all commands.", command, executor)
        end
    elseif count == 2 then
        if tonumber(type) then
            type = tonumber(type)
            if type == 0 then
                admin_blocker = 0
                sendresponse("Admins can kick/ban another admin", command, executor)
            elseif type == 1 then
                admin_blocker = 1
                sendresponse("Admins can't kick/ban another admin with higher level.", command, executor)
            elseif type == 2 then
                admin_blocker = 2
                sendresponse("Admins can't kick/ban another admin with higher or equal level.", command, executor)
            elseif type == 3 then
                admin_blocker = 3
                sendresponse("Admins can't kick/ban another admins unless they can do all commands..", command, executor)
            else
                sendresponse("Type: 0 Admin can kick/ban another admin.\nType: 1 Admin can't kick/ban another admin with higher level.\nType: 2 Admin can't kick/ban another admin with higher or equal level.\nType: 3 Admins can't kick/ban another admins unless they can do all commands.", command, executor)
            end
        else
            sendresponse("Type: 0 Admin can kick/ban another admin.\nType: 1 Admin can't kick/ban another admin with higher level.\nType: 2 Admin can't kick/ban another admin with higher or equal level.\nAdmins can't kick/ban another admins unless they can do all commands.", command, executor)
        end
    else
        sendresponse("Error 004: Invalid Syntax: " .. commannd .. " {type}", command, executor)
    end
end

function Command_AntiCaps(executor, command, boolean, count)
    if count == 1 then
        if anticaps then
            sendresponse("AntiCaps is currently on", command, executor)
        else
            sendresponse("AntiCaps is currently off", command, executor)
        end
    elseif count == 2 then
        if (boolean == "1" or boolean == "true") and anticaps ~= true then
            anticaps = true
            sendresponse("AntiCaps is now enabled", command, executor)
        elseif (boolean == "1" or boolean == "true") and anticaps == true then
            sendresponse("AntiCaps is already enabled", command, executor)
        elseif (boolean == "0" or boolean == "false") and anticaps ~= false then
            anticaps = false
            sendresponse("AntiCaps is now disabled", command, executor)
        elseif anticaps == nil then
            anticaps = false
            sendresponse("AntiCaps is now disabled", command, executor)
        elseif (boolean == "0" or boolean == "false") and anticaps == false then
            sendresponse("AntiCaps is already disabled", command, executor)
        else
            sendresponse("Error 009: Invalid Boolean: 0 for false, 1 for true", command, executor)
        end
    else
        sendresponse("Error 004: Invalid Syntax: " .. command .. " {boolean}", command, executor)
    end
end

function Command_AntiSpam(executor, command, type, count)
    if count == 1 then
        if AntiSpam == nil then AntiSpam = "all" end
        sendresponse("AntiSpam is set to " .. AntiSpam, command, executor)
    elseif count == 2 then
        type = string.lower(type)
        if type == "all" or type == "players" or type == "off" then
            AntiSpam = type
            sendresponse("AntiSpam now set to " .. AntiSpam, command, executor)
        else
            type = "off"
            sendresponse("Error 010: Invalid Type", command, executor)
        end
    else
        sendresponse("Error 004: Invalid Syntax: " .. command .. " {all | players | off}", command, executor)
    end
end

function Command_BalanceTeams(executor, command, count)
    if team_play then
        if count == 1 then
            local msg = ""
            if getteamsize(1) == getteamsize(0) then
                msg = "Teams are balanced"
            elseif getteamsize(1) + 1 == getteamsize(0) then
                msg = "Teams are balanced"
            elseif getteamsize(1) == getteamsize(0) + 1 then
                msg = "Teams are balanced"
            elseif getteamsize(1) > getteamsize(0) then
                changeteam(SelectPlayer(1), true)
                msg = "Balancing Teams"
                say(msg)
            elseif getteamsize(1) < getteamsize(0) then
                changeteam(SelectPlayer(0), true)
                msg = "Balancing Teams"
                say(msg)
            end
            sendresponse(msg, command, executor)
        else
            sendresponse("Error 004: Invalid Syntax: " .. command, command, executor)
        end
    else
        sendresponse("This command is disabled since it is not a team based game.", command, executor)
    end
end

function Command_Ban(executor, command, player, time, count)
    local bool = false
    if count == 2 or count == 3 then
        local players = getvalidplayers(player, executor)
        if players then
            for i = 1, #players do
                if CheckAccess(executor, command, players[i], getaccess(executor)) then
                    local msg = getname(players[i]) .. " has been banned from the server"
                    hprintf(msg)
                    bool = true
                else
                    local Command = getvalidformat(command)
                    sendresponse("You cannot execute " .. Command .. " on this admin.", command, executor)
                    sendresponse(tostring(getname(executor)) .. " attemped to use " .. Command .. " on you", command, players[i])
                end
            end
        else
            sendresponse("Error 005: Invalid Player", command, executor)
        end
    else
        sendresponse("Error 004: Invalid Syntax: " .. command .. ' [player] {time}.', command, executor)
    end
    return bool
end

function Command_Ban2(executor, command, player, time, message, count)
    if count >= 2 and count <= 4 then
        local players = getvalidplayers(player, executor)
        if players then
            local name = "the Server"
            if executor ~= nil then name = getname(executor) end
            for i = 1, #players do
                if CheckAccess(executor, command, players[i], getaccess(executor)) then
                    local playername = getname(players[i])
                    if message then
                        message = tostring(message)
                    else
                        message = "None Given"
                    end
                    BanReason(playername .. " was banned by " .. name .. " Reason: " .. message .. " Type: Hash Ban")
                    say(playername .. " was banned. Reason: " .. message)
                    sendresponse(getname(players[i]) .. " has been banned from the server", command, executor)
                    if time then
                        svcmd("sv_ban " .. resolveplayer(players[i]) .. " " .. time)
                    else
                        svcmd("sv_ban " .. resolveplayer(players[i]))
                    end
                else
                    local Command = getvalidformat(command)
                    sendresponse("You cannot execute " .. Command .. " on this admin.", command, executor)
                    sendresponse(tostring(getname(executor)) .. " attemped to use " .. Command .. " on you", command, players[i])
                end
            end
        else
            sendresponse("Error 005: Invalid Player", command, executor)
        end
    else
        sendresponse("Error 004: Invalid Syntax: " .. command .. " [player] {time} {reason}", command, executor)
    end
end

function Command_Bos(executor, command, player, count)
    if count == 2 then
        local player_number = tonumber(player)
        local bos_entry = Bos_Table[player_number]
        if bos_entry == nil then
            sendresponse("Error 005: Invalid Player", command, executor)
        else
            local words = tokenizestring(bos_entry, ",")
            local bool = true
            for k, v in pairs(BosLog_Table) do
                if bos_entry == v then
                    bool = false
                end
            end
            if bool then
                sendresponse("Adding " .. words[1] .. " to BoS.", command, executor)
                sendresponse("Entry: " .. words[1] .. " - " .. words[2] .. " - " .. words[3], command, executor)
                table.insert(BosLog_Table, bos_entry)
            else
                sendresponse(words[1] .. " is already on the BoS", command, executor)
            end
        end
    else
        sendresponse("Error 004: Invalid Syntax: " .. command .. " [player]", command, executor)
    end
end

function Command_Banlist(executor, command, count)
    if count == 1 then
        local response = svcmd("sv_banlist", true)
        sendresponse(response[1], command, executor)
    else
        sendresponse("Error 004: Invalid Syntax: " .. command, command, executor)
    end
end

function Command_Boslist(executor, command, count)
    if count == 1 then
        local response = "[ID - Name - Hash - IP]\n"
        for k, v in pairs(BosLog_Table) do
            if v then
                local words = tokenizestring(v, ",")
                response = response .. "\n[" .. k .. " " .. words[1] .. " - " .. words[2] .. " - " .. words[3] .. "]"
            end
        end
        sendresponse(response, command, executor)
    else
        sendresponse("Error 004: Invalid Syntax: " .. command, command, executor)
    end
end

function Command_Bosplayers(executor, command, count)
    if count == 1 then
        local response = "ID  |  Name\n"
        for i = 1, 16 do
            if Bos_Table[i] then
                local words = tokenizestring(Bos_Table[i], ",")
                response = response .. "\n" .. i .. "  |  " .. words[1]
            end
        end
        sendresponse(response, command, executor)
    else
        sendresponse("Error 004: Invalid Syntax: " .. command, command, executor)
    end
end

function Command_ChatCommands(executor, command, boolean, count)
    if count == 1 then
        if chatcommands then
            sendresponse("Chat Commands are currently on", command, executor)
        else
            sendresponse("Chat Commands are currently off", command, executor)
        end
    elseif count == 2 then
        if (boolean == "1" or boolean == "true") and chatcommands ~= true then
            chatcommands = true
            sendresponse("Chat Commands are now enabled", command, executor)
        elseif (boolean == "1" or boolean == "true") and chatcommands == true then
            sendresponse("Chat Commands are already enabled", command, executor)
        elseif (boolean == "0" or boolean == "false") and chatcommands ~= false then
            chatcommands = false
            sendresponse("Chat Commands are now disabled", command, executor)
        elseif chatcommands == nil then
            chatcommands = true
            sendresponse("Chat Commands are now enabled", command, executor)
        elseif (boolean == "0" or boolean == "false") and chatcommands == false then
            sendresponse("Chat Commands are already disabled", command, executor)
        else
            sendresponse("Error 009: Invalid Boolean: 0 for false, 1 for true", command, executor)
        end
    else
        sendresponse("Error 004: Invalid Syntax: " .. command .. " {boolean}", command, executor)
    end
end

function Command_ChangeLevel(executor, command, nickname, level, count)
    local bool_hash = false
    local bool_ip = false
    if count == 2 then
        if Admin_Table or IpAdmins then
            local level_hash
            local level_ip
            if Admin_Table then
                for k, v in pairs(Admin_Table) do
                    if Admin_Table[k].name == nickname then
                        level_hash = Admin_Table[k].level
                        bool_hash = true
                        break
                    end
                end
            end
            if IpAdmins then
                for k, v in pairs(IpAdmins) do
                    if IpAdmins[k].name == nickname then
                        level_ip = IpAdmins[k].level
                        bool_ip = true
                        break
                    end
                end
            end
            if bool_hash and bool_ip then
                sendresponse(nickname .. " is a level: " .. level_hash .. " Hash and a level: " .. level_ip .. " IP Admin", command, executor)
            elseif bool_hash and not bool_ip then
                sendresponse(nickname .. " is a level: " .. level_hash .. " Hash admin", command, executor)
            elseif bool_ip and not bool_hash then
                sendresponse(nickname .. " is a level: " .. level_ip .. " IP admin", command, executor)
            elseif not bool_hash and not bool_ip then
                sendresponse("Error 011: Invalid Nickname", command, executor)
            end
        else
            sendresponse("No admins in the server", command, executor)
        end
    elseif count == 3 and tonumber(level) then
        if Admin_Table or IpAdmins then
            if Access_Table[tonumber(level)] then
                if Admin_Table then
                    for k, v in pairs(Admin_Table) do
                        if Admin_Table[k].name == nickname then
                            Admin_Table[k].level = level
                            bool_hash = true
                            break
                        end
                    end
                end
                if IpAdmins then
                    for k, v in pairs(IpAdmins) do
                        if IpAdmins[k].name == nickname then
                            IpAdmins[k].level = level
                            bool_ip = true
                            break
                        end
                    end
                end
                if bool_hash and bool_ip then
                    sendresponse(nickname .. " is now a level: " .. level .. " Hash and now a level: " .. level .. " IP Admin", command, executor)
                elseif bool_hash and not bool_ip then
                    sendresponse(nickname .. " is now a level: " .. level .. " Hash admin", command, executor)
                elseif bool_ip and not bool_hash then
                    sendresponse(nickname .. " is now a level: " .. level .. " IP admin", command, executor)
                elseif not bool_hash and not bool_ip then
                    sendresponse("Error 011: Invalid Nickname", command, executor)
                end
            else
                sendresponse("Error 006: Invalid Level", command, executor)
            end
        else
            sendresponse("No admins in the server", command, executor)
        end
    elseif count == 3 and not tonumber(level) then
        sendresponse("The level needs to be a number", command, executor)
    else
        sendresponse("Error 004: Invalid Syntax: " .. command .. " [nickname] {level}", command, executor)
    end
end

function Command_Changeteam(executor, command, player, count)
    if count == 2 then
        local players = getvalidplayers(player, executor)
        if players then
            for i = 1, #players do
                changeteam(players[i], false)
                kill(players[i])
                sendresponse(getname(players[i]) .. " has been forced to change teams", command, executor)
            end
        else
            sendresponse("Error 005: Invalid Player", command, executor)
        end
    else
        sendresponse("Error 004: Invalid Syntax: " .. command .. " [player]", command, executor)
    end
end

function Command_Control(executor, command, victim, Controller, count)
    if count == 3 then
        local victims = getvalidplayers(victim)
        local controller = getvalidplayers(Controller)
        if victims and controller then
            if controller[2] == nil then
                for i = 1, #victims do
                    local id = resolveplayer(controller[1])
                    local m_playerObjId = getplayerobjectid(controller[1])
                    if m_playerObjId then
                        if victims[i] ~= controller[1] then
                            table.insert(Control_Table[id], victims[i])
                            sendresponse(getname(victims[i]) .. " is now being controlled by " .. getname(controller[1]), command, executor)
                            local m_objectId = getplayerobjectid(victims[i])
                            if m_objectId then
                                local m_object = getobject(m_objectId)
                                if m_object then
                                    local m_vehicleId = readdword(m_object + 0x11C)
                                    local m_vehicle = getobject(m_vehicleId)
                                    if m_vehicle then
                                        local seat = readword(m_vehicle + 0x120)
                                        exitvehicle(victims[i])
                                        entervehicle(controller[i], m_vehicleId, seat)
                                        local x, y, z = getobjectcoords(m_playerObjId)
                                        local vehid = createobject(ghost_tag_id, 0, 30, false, x, y, z + 5)
                                        entervehicle(controller[i], vehid, 0)
                                        registertimer(200, "DelayEject", controller[1])
                                        movobjectcoords(m_playerObjId, x, y, z + 0.5)
                                        entervehicle(victims[i], m_vehicleId, seat)
                                    end
                                end
                            end
                        elseif victims[i] == controller[1] then
                            local bool = false
                            for j = 1, 16 do
                                for k = 1, 16 do
                                    if Control_Table[j][k] == victims[i] then
                                        Control_Table[j][k] = nil
                                        bool = true
                                        break
                                    end
                                end
                                if bool then
                                    break
                                end
                            end
                            local m_objectId = getplayerobjectid(controller[1])
                            if m_objectId then
                                local m_object = getobject(m_objectId)
                                local m_vehicleId = readdword(m_object + 0x11C)
                                local m_vehicle = getobject(m_vehicleId)
                                if m_vehicle then
                                    local seat = readword(m_object + 0x120)
                                    entervehicle(controller[1], m_vehicleId, 0)
                                    entervehicle(controller[1], m_vehicleId, seat)
                                    sendresponse(getname(controller[1]) .. " is now being controlled by " .. getname(controller[1]), command, executor)
                                else
                                    sendresponse(getname(controller[1]) .. " is no longer being controlled", command, executor)
                                end
                            end
                        end
                    end
                end
            else
                sendresponse("Victims can only be controlled by one person.", command, executor)
            end
        else
            sendresponse("Error 005: Invalid Player", command, executor)
        end
    else
        sendresponse("Error 004: Invalid Syntax: " .. command .. " [victims] [controller]", command, executor)
    end
end

function Command_Count(executor, command, count)
    if count == 1 and uniques_enabled then
        sendresponse("There are " .. tostring(UNIQUES) .. " unique users that have been to this server", command, executor)
    elseif not uniques_enabled then
        sendresponse("'sv_uniques_enabled' is currently disabled.", command, executor)
    else
        sendresponse("Error 004: Invalid Syntax: " .. command, command, executor)
    end
end

function Command_CountUniques(executor, command, boolean, count)
    if count == 1 then
        if uniques_enabled then
            sendresponse("Unique Player Counting is currently on", command, executor)
        else
            sendresponse("Unique Player Counting is currently off", command, executor)
        end
    elseif count == 2 then
        if (boolean == "1" or boolean == "true") and uniques_enabled ~= true then
            uniques_enabled = true
            sendresponse("Unique Player Counting is now enabled", command, executor)
            local file = io.open(string.format("%s\\Uniques.txt", profilepath), "r")
            if file then
                for line in file:lines() do
                    local words = tokenizestring(line, ",")
                    local count = #words
                    if count == 3 then
                        Unique_Table[words[1]] = { words[2], words[3] }
                        UNIQUES = UNIQUES + 1
                    end
                end
                file:close()
            end
        elseif (boolean == "1" or boolean == "true") and uniques_enabled == true then
            sendresponse("Unique Player Counting is already enabled", command, executor)
        elseif (boolean == "0" or boolean == "false") and uniques_enabled ~= false then
            uniques_enabled = false
            sendresponse("Unique Player Counting is now disabled", command, executor)
        elseif uniques_enabled == nil then
            uniques_enabled = false
            sendresponse("Unique Player Counting is now disabled", command, executor)
        elseif (boolean == "0" or boolean == "false") and uniques_enabled == false then
            sendresponse("Unique Player Counting is already disabled", command, executor)
        else
            sendresponse("Error 009: Invalid Boolean: 0 for false, 1 for true", command, executor)
        end
    else
        sendresponse("Error 004: Invalid Syntax: " .. command .. " {boolean}", command, executor)
    end
end

function Command_Commands(executor, command, count)
    if count == 1 and executor ~= nil then
        local ACCESS
        local level
        if Admin_Table[gethash(executor)] then
            ACCESS = tonumber(Admin_Table[gethash(executor)].level)
        elseif IpAdmins[getip(executor)] then
            ACCESS = tonumber(IpAdmins[getip(executor)].level)
        end
        sendresponse("Commands: ", command, executor)
        if ACCESS == 0 then
            sendresponse("All Commands", command, executor)
        else
            local words = tokenizestring(Access_Table[ACCESS], ",")
            local count = #words
            local response = ""
            for i = 1, count do
                response = response .. " - " .. words[i]
                if i % 3 == 0 then
                    response = response .. "\n"
                end
            end
            sendresponse(response, command, executor)
        end
    elseif executor == nil then
        sendresponse("All Commands", command, executor)
    else
        sendresponse("Error 004: Invalid Syntax: " .. command, command, executor)
    end
end

function Command_Crash(executor, command, player, count)
    if count == 2 and not gameend then
        local players = getvalidplayers(player, executor)
        if players then
            for i = 1, #players do
                if CheckAccess(executor, command, players[i], getaccess(executor)) then
                    local m_objectId = createobject(rwarthog_tag_id, 0, 0, false, 0, 1, 2)
                    for j = 0, 20 do
                        entervehicle(players[i], m_objectId, j)
                        exitvehicle(players[i])
                    end
                    destroyobject(m_objectId)
                    sendresponse(getname(players[i]) .. " had their game crashed by an admin", command, executor)
                else
                    local Command = getvalidformat(command)
                    sendresponse("You cannot execute " .. Command .. " on this admin.", command, executor)
                    sendresponse(tostring(getname(executor)) .. " attempted to use " .. Command .. " on you", command, players[i])
                end
            end
        else
            sendresponse("Error 005: Invalid Player", command, executor)
        end
    elseif gameend then
        sendresponse("You cannot crash a player while the game is ended. Wait until next game.", command, executor)
    else
        sendresponse("Error 004: Invalid Syntax: " .. command .. " [player]", command, executor)
    end
end

function Command_DamageMultiplier(executor, command, player, value, count)
    if count == 2 then
        local players = getvalidplayers(player, executor)
        if players then
            for i = 1, #players do
                sendresponse(getname(players[i]) .. " has a damage multiplier of " .. dmgmultiplier[getip(players[i])], command, executor)
            end
        else
            sendresponse("Error 005: Invalid Player", command, executor)
        end
    elseif count == 3 then
        value = tonumber(value)
        if value then
            local players = getvalidplayers(player, executor)
            if players then
                for i = 1, #players do
                    dmgmultiplier[getip(players[i])] = value
                    sendresponse(getname(players[i]) .. " has had his damage multiplier changed to " .. value, command, executor)
                end
            else
                sendresponse("Error 005: Invalid Player", command, executor)
            end
        else
            sendresponse("Invalid Damage Multiplier", command, executor)
        end
    else
        sendresponse("Error 004: Invalid Syntax: " .. command .. " [player] [damage multiplier]", command, executor)
    end
end

function Command_Deathless(executor, command, boolean, count)
    if count == 1 then
        if deathless then
            sendresponse("Deathless is currently enabled.", command, executor)
        else
            sendresponse("Deathless is currently disabled", command, executor)
        end
    elseif count == 2 then
        if (boolean == "1" or boolean == "true") and not deathless then
            sendresponse("Deathless player is now on. You cannot die.", command, executor)
            deathless = true
        elseif boolean == "1" or boolean == "true" then
            sendresponse("Deathless is already enabled", command, executor)
        elseif (boolean == "0" or boolean == "false") and deathless then
            sendresponse("Deathless player is now off.", command, executor)
            deathless = false
        elseif deathless == nil then
            sendresponse("Deathless player is now off.", command, executor)
            deathless = false
        elseif boolean == "0" or boolean == "false" then
            sendresponse("Deathless is already disabled", command, executor)
        else
            sendresponse("Error 009: Invalid Boolean: 0 for false, 1 for true", command, executor)
        end
    else
        sendresponse("Error 004: Invalid Syntax: " .. command .. " {boolean}", command, executor)
    end
end

function Command_DelRconPassword(executor, command, password, count)
    if count == 2 then
        local bool = false
        for k, v in pairs(RCON_PASSWORDS) do
            if RCON_PASSWORDS[k] ~= nil and RCON_PASSWORDS[k] ~= { } then
                for key, value in ipairs(RCON_PASSWORDS[k]) do
                    if RCON_PASSWORDS[k][key].password == password then
                        table.remove(RCON_PASSWORDS, k)
                        bool = true
                    end
                end
            end
        end
        if bool then
            sendresponse(password .. " is no longer an rcon password", command, executor)
        else
            sendresponse(password .. " is not an rcon password", command, executor)
        end
    else
        sendresponse("Error 004: Invalid Syntax: " .. command .. " [password]", command, executor)
    end
end

function Command_Execute(executor, command, ACCESS)
    local t = tokenizecmdstring(command)
    if t[2] == nil or t[2] == "sv_script_reload" then
        return
    end
    if CheckAccess(executor, t[2], t[3], ACCESS) then
        sendresponse("Executed " .. string.sub(command, 4), command, executor)
        local response = svcmd(string.sub(command, 4), true)
        if response then
            if type(response) == "table" then
                local Response = response[1]
                local count = #response
                while (count > 1) do
                    Response = Response .. " " .. response[count]
                    count = count - 1
                end
                sendresponse(Response, command, executor)
            else
                sendresponse(response[1], command, executor)
            end
        end
    else
        local Command = getvalidformat(t[2])
        sendresponse("You cannot execute " .. Command .. " on this admin.", command, executor)
        sendresponse(tostring(getname(executor)) .. " attemped to use " .. Command .. " on you", command, players[i])
    end
end

function Command_Eject(executor, command, player, count)
    if count == 1 and executor ~= nil then
        local m_objectId = getplayerobjectid(executor)
        if m_objectId then
            local m_object = getobject(m_objectId)
            if m_object then
                if isinvehicle(executor) then
                    exitvehicle(executor)
                    sendresponse("Ejecting you from your vehicle", command, executor)
                else
                    sendresponse("You are not in a vehicle", command, executor)
                end
            else
                sendresponse("You are dead", command, executor)
            end
        end
    elseif count == 1 and executor == nil then
        sendresponse("The Server cannot be ejected froma vehicle", command, executor)
    elseif count == 2 then
        local players = getvalidplayers(player, executor)
        if players then
            for i = 1, #players do
                local m_player = getplayer(players[i])
                local m_objectId = getplayerobjectid(players[i])
                if m_objectId then
                    local m_object = getobject(m_objectId)
                    if m_object then
                        if isinvehicle(players[i]) then
                            exitvehicle(players[i])
                            sendresponse("Ejecting " .. getname(players[i]) .. " from his/her vehicle", command, executor)
                        else
                            sendresponse(getname(players[i]) .. " is not in a vehicle", command, executor)
                        end
                    else
                        sendresponse(getname(players[i]) .. " is dead", command, executor)
                    end
                end
            end
        else
            sendresponse("Error 005: Invalid Player", command, executor)
        end
    else
        sendresponse("Error 004: Invalid Syntax: " .. command .. " [player]", command, executor)
    end
end

function Command_Falldamage(executor, command, boolean, count)
    if count == 1 then
        if falldamage then
            sendresponse("Fall damage is currently on", command, executor)
        else
            sendresponse("Fall damage is currently off", command, executor)
        end
    elseif count == 2 then
        if (boolean == "1" or boolean == "true") and not falldamage then
            falldamage = true
            sendresponse("Fall damage is now on", command, executor)
        elseif (boolean == "1" or boolean == "true") then
            sendresponse("Fall damage is already on", command, executor)
        elseif boolean ~= "0" and boolean ~= "false" then
            sendresponse("Error 009: Invalid Boolean: 0 for false, 1 for true", command, executor)
        elseif (boolean == "0" or boolean == "false") and(falldamage or falldamage == nil) then
            falldamage = false
            sendresponse("Fall damage is now off", command, executor)
        elseif boolean == "0" or boolean == "false" then
            sendresponse("Fall damage is already off", command, executor)
        else
            sendresponse("Error 009: Invalid Boolean: 0 for false, 1 for true", command, executor)
        end
    else
        sendresponse("Error 004: Invalid Syntax: " .. command .. " [boolean]", command, executor)
    end
end

function Command_FirstJoinMessage(executor, command, boolean, count)
    if count == 1 then
        if firstjoin_message then
            sendresponse("First Join Message is currently on", command, executor)
        else
            sendresponse("First Join Message is currently off", command, executor)
        end
    elseif count == 2 then
        if (boolean == "1" or boolean == "true") and firstjoin_message ~= true then
            firstjoin_message = true
            sendresponse("First Join Message is now enabled", command, executor)
        elseif (boolean == "1" or boolean == "true") and firstjoin_message == true then
            sendresponse("First Join Message is already enabled", command, executor)
        elseif (boolean == "0" or boolean == "false") and firstjoin_message ~= false then
            firstjoin_message = false
            sendresponse("First Join Message is now disabled", command, executor)
        elseif firstjoin_message == nil then
            firstjoin_message = false
            sendresponse("First Join Message is now disabled", command, executor)
        elseif (boolean == "0" or boolean == "false") and firstjoin_message == false then
            sendresponse("First Join Message is already disabled", command, executor)
        else
            sendresponse("Error 009: Invalid Boolean: 0 for false, 1 for true", command, executor)
        end
    else
        sendresponse("Error 004: Invalid Syntax: " .. command .. " {boolean}", command, executor)
    end
end

function PlayersInVehicles(executor, command, objname, objtype, mapId, player)
    for i = 0, 15 do
        if getplayer(i) then
            local name = getname(i)
            local m_player = getplayer(i)
            if isinvehicle(i) then
                local m_playerObjId = getplayerobjectid(i)
                if m_playerObjId then
                    local m_object = getobject(m_playerObjId)
                    local m_vehicleId = readdword(m_object + 0x11C)
                    if m_object then
                        sendresponse(tostring(getname(i)) .. " is in a " .. tostring(objname) .. "", command, executor)
                    end
                end
            end
        end
    end
end

function Command_Follow(executor, command, player, count)
    if count == 2 then
        local players = getvalidplayers(player, executor)
        if players then
            for i = 1, #players do
                if executor ~= players[i] then
                    sendresponse(getname(executor) .. " is now following " .. getname(players[i]), command, executor)
                    local id = resolveplayer(executor)
                    local arguments = { executor, players[i] }
                    follow[id] = registertimer(20, "FollowTimer", arguments)
                else
                    sendresponse("You cannot follow yourself", command, executor)
                end
            end
        elseif player == "stop" or player == "none" then
            local id = resolveplayer(executor)
            if follow[id] then
                sendresponse(getname(executor) .. " is no longer following", command, executor)
                if follow[id] then
                    removetimer(follow[id])
                    follow[id] = nil
                end
            end
        else
            sendresponse("Error 005: Invalid Player", command, executor)
        end
    else
        sendresponse("Error 004: Invalid Syntax: " .. command .. " [player]", command, executor)
    end
end

function Command_Gethash(executor, command, player, count)
    if count == 2 then
        local players = getvalidplayers(player, executor)
        if players then
            for i = 1, #players do
                sendresponse(getname(players[i]) .. ": " .. gethash(players[i]), command, executor)
            end
        else
            sendresponse("Error 005: Invalid Player", command, executor)
        end
    else
        sendresponse("Error 004: Invalid Syntax: " .. command .. " [player]", command, executor)
    end
end

function Command_Getip(executor, command, player, count)
    if count == 2 then
        local players = getvalidplayers(player, executor)
        if players then
            for i = 1, #players do
                local id = resolveplayer(players[i])
                local ip = getip(players[i])
                sendresponse(getname(players[i]) .. ": " .. tostring(ip), command, executor)
            end
        else
            sendresponse("Error 005: Invalid Player", command, executor)
        end
    else
        sendresponse("Error 004: Invalid Syntax: " .. command .. " [player]", command, executor)
    end
end

function Command_Getloc(executor, command, player, count)
    if count == 1 and executor ~= nil then
        local m_playerObjId = getplayerobjectid(executor)
        if m_playerObjId then
            if getobject(m_playerObjId) then
                local x, y, z = getobjectcoords(m_playerObjId)
                x = round(x, 2)
                y = round(y, 2)
                z = round(z, 2)
                sendresponse("Your coords are: X: " .. x .. "  Y: " .. y .. "  Z: " .. z, command, executor)
            else
                sendresponse("You are dead", command, executor)
            end
        end
    elseif count == 1 and executor == nil then
        sendresponse("The server does not have a location.", command, executor)
    elseif count == 2 then
        local players = getvalidplayers(player, executor)
        if players then
            for i = 1, #players do
                local m_playerObjId = getplayerobjectid(players[i])
                if m_playerObjId then
                    if getobject(m_playerObjId) then
                        local x, y, z = getobjectcoords(m_playerObjId)
                        x = round(x, 2)
                        y = round(y, 2)
                        z = round(z, 2)
                        sendresponse(getname(players[i]) .. "'s coords are: X: " .. x .. "  Y: " .. y .. "  Z: " .. z, command, executor)
                    else
                        sendresponse(getname(players[i]) .. " is dead", command, executor)
                    end
                end
            end
        else
            sendresponse("Error 005: Invalid Player", command, executor)
        end
    else
        sendresponse("Error 004: Invalid Syntax: " .. command .. " [player]", command, executor)
    end
end

function Command_Godmode(executor, command, player, count)
    if count == 1 and executor ~= nil then
        if deathless ~= 1 then
            local m_playerObjId = getplayerobjectid(executor)
            if m_playerObjId then
                local m_object = getobject(m_playerObjId)
                if m_object then
                    local ip = getip(executor)
                    if not gods[ip] then
                        writefloat(m_object + 0xE0, 99999999)
                        writefloat(m_object + 0xE4, 99999999)
                        sendresponse("You have been given godmode.", command, executor)
                        gods[ip] = 0
                    else
                        sendresponse("You are already in godmode", command, executor)
                    end
                else
                    sendresponse("You are dead", command, executor)
                end
            else
                sendresponse("You are dead", command, executor)
            end
        else
            sendresponse("Deathless is now enabled You cannot give out godmode", command, executor)
        end
    elseif count == 1 and executor == nil then
        sendresponse("The Server cannot be in god mode", command, executor)
    elseif count == 2 then
        if deathless ~= 1 then
            local players = getvalidplayers(player, executor)
            if players then
                for i = 1, #players do
                    local m_playerObjId = getplayerobjectid(players[i])
                    if m_playerObjId then
                        local m_object = getobject(m_playerObjId)
                        if m_object then
                            local ip = getip(players[i])
                            if not gods[ip] then
                                writefloat(m_object + 0xE0, 99999999)
                                writefloat(m_object + 0xE4, 99999999)
                                sendresponse(getname(players[i]) .. " has been given godmode", command, executor)
                                gods[ip] = 0
                            else
                                sendresponse(getname(players[i]) .. " is already in godmode", command, executor)
                            end
                        else
                            sendresponse(getname(players[i]) .. " is dead", command, executor)
                        end
                    else
                        sendresponse(getname(players[i]) .. " is dead", command, executor)
                    end
                end
            else
                sendresponse("Error 005: Invalid Player", command, executor)
            end
        else
            sendresponse("Deathless is now enabled You cannot give out godmode", command, executor)
        end
    else
        sendresponse("Error 004: Invalid Syntax: " .. command .. " {player}", command, executor)
    end
end

function Command_Hashcheck(boolean)
    if (boolean == "1" or boolean == "true") and not hash_check then
        hash_check = true
        writebyte(hashcheck_addr, 0x74)
    elseif (boolean == "0" or boolean == "false") and hash_check then
        hash_check = false
        writebyte(hashcheck_addr, 0xEB)
    elseif hash_check == nil then
        hash_check = false
        writebyte(hashcheck_addr, 0xEB)
    end
end

function Command_HashDuplicates(executor, command, boolean, count)
    if count == 1 then
        if hash_duplicates then
            sendresponse("Hash Duplicate Checking is currently enabled", command, executor)
        else
            sendresponse("Hash Duplicate Checking is currently disabled", command, executor)
        end
    elseif count == 2 then
        if (boolean == "1" or boolean == "true") and not hash_duplicates then
            hash_duplicates = true
            writebit(hash_duplicate_patch, 0, 1)
            sendresponse("Hash Duplicate Checking is now enabled", command, executor)
        elseif (boolean == "1" or boolean == "true") then
            sendresponse("Hash Duplicate Checking is already enabled", command, executor)
        elseif boolean ~= "0" and boolean ~= "false" then
            sendresponse("Error 009: Invalid Boolean: 0 for false, 1 for true", command, executor)
        elseif (boolean == "0" or boolean == "false") and hash_duplicates or(hash_duplicates == nil) then
            hash_duplicates = false
            writebit(hash_duplicate_patch, 0, 0)
            sendresponse("Hash Duplicate Checking is now disabled", command, executor)
        elseif boolean == "0" or boolean == "false" then
            sendresponse("Hash Duplicate Checking is already disabled", command, executor)
        else
            sendresponse("Error 009: Invalid Boolean: 0 for false, 1 for true", command, executor)
        end
    else
        sendresponse("Error 004: Invalid Syntax: " .. command .. " [boolean]", command, executor)
    end
end

function Command_Hax(executor, command, player, count)
    if count == 2 then
        local players = getvalidplayers(player, executor)
        if players then
            for i = 1, #players do
                local m_player = getplayer(players[i])
                setscore(players[i], 9999)
                writeword(m_player + 0x9C, 9999)
                writeword(m_player + 0xA4, 9999)
                writeword(m_player + 0xAC, 9999)
                writeword(m_player + 0xAE, 9999)
                writeword(m_player + 0xB0, 9999)
                sendresponse(getname(players[i]) .. " has been haxed", command, executor)
            end
        else
            sendresponse("Error 005: Invalid Player", command, executor)
        end
    else
        sendresponse("Error 004: Invalid Syntax: " .. command .. " [player]", command, executor)
    end
end

function Command_Heal(executor, command, player, count)
    if count == 1 and executor ~= nil then
        local m_playerObjId = getplayerobjectid(executor)
        if m_playerObjId then
            local m_object = getobject(m_playerObjId)
            if m_object then
                local obj_health = readfloat(m_object + 0xE0)
                if obj_health < 1 then
                    local m_vehicleId = readdword(m_object + 0x11C)
                    if m_vehicleId == nil then
                        local x, y, z = getobjectcoords(m_playerObjId)
                        local healthpack = createobject(healthpack_tag_id, 0, 0, false, x, y, z + 0.5)
                        if healthpack ~= nil then writefloat(getobject(healthpack) + 0x70, -2) end
                    else
                        writefloat(m_object + 0xE0, 1)
                    end
                    sendresponse("You have been healed", command, executor)
                else
                    sendresponse("You are already at full health", command, executor)
                end
            else
                sendresponse("You are dead", command, executor)
            end
        else
            sendresponse("You are dead", command, executor)
        end
    elseif count == 1 and executor == nil then
        sendresponse("The Server cannot be healed", command, executor)
    elseif count == 2 then
        local players = getvalidplayers(player, executor)
        if players then
            for i = 1, #players do
                local m_playerObjId = getplayerobjectid(players[i])
                if m_playerObjId then
                    local m_object = getobject(m_playerObjId)
                    if m_object then
                        local obj_health = readfloat(m_object + 0xE0)
                        if obj_health < 1 then
                            local m_vehicleId = readdword(m_object + 0x11C)
                            if m_vehicleId == nil then
                                local x, y, z = getobjectcoords(m_playerObjId)
                                local healthpack = createobject(healthpack_tag_id, 0, 0, false, x, y, z + 0.5)
                                if healthpack ~= nil then writefloat(getobject(healthpack) + 0x70, -2) end
                            else
                                writefloat(m_object + 0xE0, 1)
                            end
                            sendresponse(getname(players[i]) .. " has been healed", command, executor)
                        else
                            sendresponse(getname(players[i]) .. " is already at full health", command, executor)
                        end
                    else
                        sendresponse(getname(players[i]) .. " is dead", command, executor)
                    end
                else
                    sendresponse(getname(players[i]) .. " is dead", command, executor)
                end
            end
        else
            sendresponse("Error 005: Invalid Player", command, executor)
        end
    else
        sendresponse("Error 004: Invalid Syntax: " .. command .. " {player}", command, executor)
    end
end

function Command_Hide(executor, command, player, count)
    if count == 1 and executor ~= nil then
        local id = resolveplayer(executor)
        if id ~= nil then
            if hidden[id] == nil then
                sendresponse("You are now hidden", command, executor)
                hidden[id] = true
            else
                sendresponse("You are already hidden", command, executor)
            end
        else
            sendresponse("The server cannot hide itself", command, executor)
        end
    elseif count == 1 and executor == nil then
        sendresponse("The server cannot be hidden", command, executor)
    elseif count == 2 then
        local players = getvalidplayers(player, executor)
        if players then
            for i = 1, #players do
                local id = resolveplayer(players[i])
                if hidden[id] == nil then
                    sendresponse(getname(players[i]) .. " is now hidden", command, executor)
                    hidden[id] = true
                else
                    sendresponse(getname(players[i]) .. " is already hidden", command, executor)
                end
            end
        else
            sendresponse("Error 005: Invalid Player", command, executor)
        end
    else
        sendresponse("Error 004: Invalid Syntax: " .. command .. " {player}", command, executor)
    end
end

function Command_Infammo(executor, command, boolean, count)
    if count == 1 then
        if infammo then
            sendresponse("Infinite ammo is currently enabled", command, executor)
        else
            sendresponse("Infinite ammo is currently disabled", command, executor)
        end
    elseif count == 2 then
        if (boolean == "1" or boolean == "true") and not infammo then
            nadetimer = registertimer(300, "nadeTimer")
            for c = 0, 15 do
                if getplayer(c) then
                    local m_ObjId = getplayerobjectid(c)
                    if m_ObjId then
                        local m_Object = getobject(m_ObjId)
                        for i = 0, 3 do
                            local m_weaponId = readdword(m_Object + 0x2F8 +(i * 4))
                            if m_weaponId then
                                writeword(getobject(m_weaponId) + 0x2B6, 9999)
                            end
                        end
                    end
                end
            end
            infammo = true
            sendresponse("Infinite Ammo is now enabled", command, executor)
        elseif (boolean == "1" or boolean == "true") then
            sendresponse("Infammo is already enabled", command, executor)
        elseif boolean ~= "0" and boolean ~= "false" then
            sendresponse("Error 009: Invalid Boolean: 0 for false, 1 for true", command, executor)
        elseif (boolean == "0" or boolean == "false") and infammo then
            for c = 0, 15 do
                if getplayer(c) then
                    local m_ObjId = getplayerobjectid(c)
                    if m_ObjId then
                        local m_Object = getobject(m_ObjId)
                        writebyte(m_Object + 0x31E, 0)
                        writebyte(m_Object + 0x31F, 0)
                    end
                end
            end
            infammo = false
            sendresponse("Infinite Ammo is now disabled", command, executor)
        elseif infammo == nil then
            sendresponse("Infinite Ammo is now disabled", command, executor)
            infammo = false
        elseif boolean == "0" or boolean == "false" then
            sendresponse("Infammo is already disabled", command, executor)
        else
            sendresponse("Error 009: Invalid Boolean: 0 for false, 1 for true", command, executor)
        end
    else
        sendresponse("Error 004: Invalid Syntax: " .. command .. " [boolean]", command, executor)
    end
end

function Command_Info(executor, command, player, count)
    if count == 2 then
        local players = getvalidplayers(player, executor)
        if players then
            for i = 1, #players do
                local player_number = resolveplayer(players[i])
                local m_player = getplayer(players[i])
                local hash = gethash(players[i])
                local ip = getip(players[i])
                local m_playerObjId = getplayerobjectid(players[i])
                if m_playerObjId then
                    local m_object = getobject(m_playerObjId)
                    if m_object then
                        local gametype_maximum_health = readfloat(0x671340 + 0x54)
                        local player_name = getname(players[i])
                        local player_team = getteam(players[i])
                        local player_respawn_time = readdword(m_player + 0x2C)
                        local player_invis_time = readword(m_player + 0x68)
                        local player_speed = readfloat(m_player + 0x6C)
                        local player_objective_mode = readbyte(m_player + 0x74)
                        local player_objective_mode2 = readbyte(m_player + 0x7A)
                        local player_killstreak = readword(m_player + 0x96)
                        local player_kills = readword(m_player + 0x9C)
                        local player_assists = readword(m_player + 0xA4)
                        local player_betrays = readword(m_player + 0xAC)
                        local player_deaths = readword(m_player + 0xAE)
                        local player_suicides = readword(m_player + 0xB0)
                        local Player_Ping = readword(m_player + 0xDC)
                        local player_x_coord, player_y_coord, player_z_coord = getobjectcoords(m_playerObjId)

                        local obj_max_health = readfloat(m_object + 0xD8)
                        local obj_max_shields = readfloat(m_object + 0xDC)
                        local obj_health = readfloat(m_object + 0xE0)
                        local obj_shields = readfloat(m_object + 0xE4)
                        local obj_flashlight_mode = readbyte(m_object + 0x206)
                        local obj_crouch = readbyte(m_object + 0x2A0)
                        local obj_weap_type = readbyte(m_object + 0x2F2)
                        local obj_nade_type = readbyte(m_object + 0x31C)
                        local obj_primary_nades = readbyte(m_object + 0x31E)
                        local obj_secondary_nades = readbyte(m_object + 0x31F)
                        local obj_flashlight_level = readfloat(m_object + 0x344)
                        local obj_invis_scale = readfloat(m_object + 0x37C)
                        local obj_airborne = readbyte(m_object + 0x4CC)

                        local obj_primary_weap_id = readdword(m_object + 0x2F8)
                        local obj_secondary_weap_id = readdword(m_object + 0x2FC)
                        if obj_primary_weap_id then
                            primary_weap = getobject(obj_primary_weap_id)
                        end
                        if obj_secondary_weap_id then
                            secondary_weap = getobject(obj_secondary_weap_id)
                        end

                        local m_vehicle = getobject(m_playerObjId)
                        if obj_crouch == 1 or obj_crouch == 5 or obj_crouch == 6 or obj_crouch == 13 or obj_crouch == 17 then
                            primary_weap = getobject(readdword(m_vehicle + 0x2F8))
                        end
                        if primary_weap then
                            primary_weap_heat = readfloat(primary_weap + 0x23C)
                            primary_weap_age = readfloat(primary_weap + 0x240)
                            primary_weap_ammo = readword(primary_weap + 0x2B6)
                            primary_weap_clip = readword(primary_weap + 0x2B8)
                        end
                        if secondary_weap then
                            secondary_weap_heat = readfloat(secondary_weap + 0x23C)
                            secondary_weap_age = readfloat(secondary_weap + 0x240)
                            secondary_weap_ammo = readword(secondary_weap + 0x2B6)
                            secondary_weap_clip = readword(secondary_weap + 0x2B8)
                        end

                        local teamsize = getteamsize(player_team)
                        if team_play then
                            if player_team == 0 then
                                player_team = "Red"
                            elseif player_team == 1 then
                                player_team = "Blue"
                            else
                                player_team = "Hidden"
                            end
                        else
                            player_team = "FFA"
                        end

                        if player_objective_mode == 0x22 and player_objective_mode2 == 0x71 then
                            player_objective_mode = "Hill"
                        elseif player_objective_mode == 0x23 and player_objective_mode2 == 0x71 then
                            player_objective_mode = "Juggernaut"
                        elseif player_objective_mode == 0x23 and player_objective_mode2 == 0x72 then
                            player_objective_mode = "It"
                        elseif player_objectivemode == 0x29 and player_objective_mode2 == 0x70 then
                            player_objective_mode = "Ball"
                        else
                            player_objective_mode = "None"
                        end

                        if obj_weap_type == 2 and player_objective_mode == "None" then
                            player_objective_mode = "Flag"
                        end

                        player_respawn_time = round(player_respawn_time / 30, 2)
                        player_invis_time = round(player_invis_time / 30, 2)

                        player_betrays = player_betrays - player_suicides

                        player_x_coord = round(player_x_coord)
                        player_y_coord = round(player_y_coord)
                        player_z_coord = round(player_z_coord)

                        obj_invis_scale = round(obj_invis_scale * 100, 2)

                        if obj_invis_scale == 0 then
                            obj_invis_scale = "No"
                        else
                            obj_invis_scale = obj_invis_scale .. "%"
                        end

                        local invis_info = "Invis: " .. obj_invis_scale

                        if obj_invis_scale ~= "No" then
                            invis_info = "Invis: " .. obj_invis_scale .. " (" .. player_invis_time .. " secs)"
                        end

                        if obj_flashlight_mode == 8 then
                            obj_flashlight_mode = "On"
                        else
                            obj_flashlight_mode = "Off"
                        end

                        obj_flashlight_level = round(obj_flashlight_level * 100)

                        if primary_weap_age == 0 then
                            if primary_weap_ammo ~= 0 or primary_weap_clip ~= 0 then
                                if primary_weap then
                                    writefloat(primary_weap + 0x240, 1)
                                    primary_weap_age = 1
                                end
                            end
                        end

                        if secondary_weap_age == 0 then
                            if secondary_weap_ammo ~= 0 or secondary_weap_clip ~= 0 then
                                if secondary_weap then
                                    writefloat(secondary_weap + 0x240, 1)
                                    secondary_weap_age = 1
                                end
                            end
                        end

                        if obj_weap_type == 1 then
                            primary_weap_heat = readfloat(secondary_weap + 0x23C)
                            primary_weap_age = readfloat(secondary_weap + 0x240)
                            primary_weap_ammo = readword(secondary_weap + 0x2B6)
                            primary_weap_clip = readword(secondary_weap + 0x2B8)
                            secondary_weap_heat = readfloat(primary_weap + 0x23C)
                            secondary_weap_age = readfloat(primary_weap + 0x240)
                            secondary_weap_ammo = readword(primary_weap + 0x2B6)
                            secondary_weap_clip = readword(primary_weap + 0x2B8)
                        end

                        if primary_weap_heat ~= nil then
                            primary_weap_heat = round(primary_weap_heat * 100)
                        end
                        if primary_weap_age ~= nil then
                            primary_weap_age = round((1 - primary_weap_age) * 100)
                        end
                        if secondary_weap_heat ~= nil then
                            secondary_weap_heat = round(secondary_weap_heat * 100)
                        end
                        if secondary_weap_age ~= nil then
                            secondary_weap_age = round((1 - secondary_weap_age) * 100)
                        end

                        local primary_weap_info = "Primary: Empty"
                        local secondary_weap_info = "Secondary: Empty"

                        if obj_health ~= 0 then
                            if obj_crouch == 1 or obj_crouch == 5 or obj_crouch == 6 or obj_crouch == 13 or obj_crouch == 17 then
                                if primary_weap_age == 100 and primary_weap_ammo == 0 and primary_weap_clip == 0 then
                                    primary_weap_info = "Primary: Infinite"
                                else
                                    primary_weap_info = "Primary Ammo: " .. primary_weap_clip .. " / " .. primary_weap_ammo
                                end
                            else

                                if primary_weap then
                                    if primary_weap_age == 0 then
                                        if primary_weap_ammo ~= 0 or primary_weap_clip ~= 0 then
                                            primary_weap_info = "Primary Ammo: " .. primary_weap_clip .. " / " .. primary_weap_ammo
                                        end
                                    else
                                        primary_weap_info = "Primary Battery: " .. primary_weap_heat .. "% / " .. primary_weap_age .. "%"
                                    end
                                end

                                if secondary_weap then
                                    if secondary_weap_age == 0 then
                                        if secondary_weap_ammo ~= 0 or secondary_weap_clip ~= 0 then
                                            secondary_weap_info = "Secondary Ammo: " .. secondary_weap_clip .. " / " .. secondary_weap_ammo
                                        end
                                    else
                                        secondary_weap_info = "Secondary Battery: " .. secondary_weap_heat .. "% / " .. secondary_weap_age .. "%"
                                    end
                                end

                            end
                        end

                        local nade_info = "Frag Grenades: " .. obj_primary_nades .. " | " .. "Plasma Grenades: " .. obj_secondary_nades
                        if obj_nade_type == 1 then
                            nade_info = "Plasma Grenades: " .. obj_secondary_nades .. " | " .. "Frag Grenades: " .. obj_primary_nades
                        end

                        if obj_crouch == 0 then
                            obj_crouch = "Warthog: Driver"
                        elseif obj_crouch == 1 then
                            obj_crouch = "Warthog: Gunner"
                        elseif obj_crouch == 2 then
                            obj_crouch = "Warthog: Passenger"
                        elseif obj_crouch == 3 then
                            obj_crouch = "Stance: Crouching"
                        elseif obj_crouch == 4 then
                            obj_crouch = "Stance: Standing"
                        elseif obj_crouch == 5 then
                            obj_crouch = "Ghost: Driver"
                        elseif obj_crouch == 6 then
                            obj_crouch = "Banshee: Pilot"
                        elseif obj_crouch == 13 then
                            obj_crouch = "Scorpion: Driver"
                        elseif obj_crouch == 17 then
                            obj_crouch = "Shade: Gunner"
                        elseif obj_crouch == 20 or obj_crouch == 21 or obj_crouch == 22 or obj_crouch == 23 then
                            obj_crouch = "Scorpion: Passenger"
                        end

                        if obj_crouch == "Stance: Crouching" or obj_crouch == "Stance: Standing" then
                            if obj_airborne == 1 then
                                obj_crouch = "Stance: Airborne"
                            end
                        end

                        if obj_health == 0 and obj_shields == 0 then
                            obj_crouch = "Stance: Dead"
                        end

                        obj_max_health = round(obj_health * obj_max_health)
                        obj_max_shields = round(obj_shields * obj_max_shields)
                        obj_health = round(obj_health * 100)
                        obj_shields = round(obj_shields * 100)

                        local health_info = "Health: " .. obj_health .. "% (" .. obj_max_health .. ") | " .. "Shields: " .. obj_shields .. "% (" .. obj_max_shields .. ")"

                        if obj_health == 0 and obj_shields == 0 and player_respawn_time ~= 0 then
                            if player_respawn_time == 1 then
                                health_info = "Respawn: " .. player_respawn_time .. " sec"
                            else
                                health_info = "Respawn: " .. player_respawn_time .. " secs"
                            end
                        end

                        if Suspend_Table[ip] == 2 then
                            health_info = "Respawn: Never"
                        end
                        if hidden[player_number] then
                            hidden_boolean = "True"
                        else
                            hidden_boolean = "False"
                        end
                        if gods[ip] then
                            god_boolean = "True"
                        else
                            god_boolean = "False"
                        end
                        if afk[player_number][1] then
                            afk_boolean = "True"
                        else
                            afk_boolean = "False"
                        end
                        if Admin_Table[hash] or IpAdmins[ip] then
                            admin_status = "True"
                        else
                            admin_status = "False"
                        end
                        sendresponse("----------", command, executor)
                        sendresponse("Name: " .. player_name .. " (" .. player_number .. ") | " .. "Team: " .. player_team .. " (" .. teamsize .. ")  |  Speed: " .. round(player_speed, 2) .. " | " .. "Location: " .. player_x_coord .. ", " .. player_y_coord .. ", " .. player_z_coord, command, executor)
                        sendresponse("Hash: " .. hash .. " | " .. " IP: " .. ip, command, executor)
                        sendresponse("Admin: " .. admin_status .. " | " .. "Ping: " .. Player_Ping .. " | " .. obj_crouch, command, executor)
                        sendresponse("Kills: " .. player_kills .. " (" .. player_killstreak .. ") | " .. "Assists: " .. player_assists .. " | " .. "Betrays: " .. player_betrays .. " | " .. "Suicides: " .. player_suicides .. " | " .. "Deaths: " .. player_deaths, command, executor)
                        sendresponse(health_info .. " | " .. invis_info .. "\n" .. "Light: " .. obj_flashlight_mode .. " (" .. obj_flashlight_level .. "%)", command, executor)
                        sendresponse(primary_weap_info .. " | " .. secondary_weap_info .. " | " .. "Objective: " .. player_objective_mode, command, executor)
                        sendresponse(nade_info, command, executor)
                        sendresponse("Hidden: " .. hidden_boolean .. " | God: " .. god_boolean .. " | AFK: " .. afk_boolean, command, executor)
                        sendresponse("----------", command, executor)
                    else
                        sendresponse("The selected player is dead", command, executor)
                    end
                else
                    sendresponse("The selected player is dead", command, executor)
                end
            end
        else
            sendresponse("Error 005: Invalid Player", command, executor)
        end
    else
        sendresponse("Error 004: Invalid Syntax: " .. command .. " [player]", command, executor)
    end
end

function Command_Ipadminadd(executor, command, player, nickname, level, count)
    if count == 4 and tonumber(level) then
        local words = tokenizestring(player, ".")
        local count = #words
        if count == 4 then
            if IpAdmins[player] then
                sendresponse(nickname .. " is already an IP admin", command, executor)
            elseif not nickname:find(",") then
                if tonumber(level) <= #Access_Table then
                    IpAdmins[player] = IpAdmins[player] or { }
                    IpAdmins[player].name = nickname
                    IpAdmins[player].level = level
                    sendresponse(nickname .. " is now an IP admin", tostring(command), tostring(executor))
                    registertimer(0, "reloadadmins")
                else
                    sendresponse("That level does not exist.", command, executor)
                end
            else
                sendresponse("Nicknames must contain no commas.", command, executor)
            end
        elseif count > 1 then
            sendresponse("Invalid IP Address Format (xxx.xxx.xxx.xxx)", command, executor)
        else
            local players = getvalidplayers(player, executor)
            if players then
                if not players[2] then
                    local ip = getip(players[1])
                    if IpAdmins[ip] then
                        sendresponse(getname(tostring(players[1])) .. " is already an IP admin", command, executor)
                    elseif not nickname:find(",") then
                        if tonumber(level) <= #Access_Table then
                            IpAdmins[ip] = IpAdmins[ip] or { }
                            IpAdmins[ip].name = nickname
                            IpAdmins[ip].level = level
                            sendresponse(getname(tostring(players[1])) .. " is now an IP admin", tostring(command), tostring(executor))
                            registertimer(0, "reloadadmins")
                        else
                            sendresponse("That level does not exist.", command, executor)
                        end
                    else
                        sendresponse("Nicknames must contain no commas.", command, executor)
                    end
                else
                    sendresponse("You cannot add more than one admin with the same nickname", command, executor)
                end
            else
                sendresponse("Error 005: Invalid Player", command, executor)
            end
        end
    else
        sendresponse("Error 004: Invalid Syntax: " .. command .. " [player or IP] [nickname] [level]", command, executor)
    end
end

function Command_ipadmindelete(executor, command, nickname, count)
    if count == 2 then
        if type(IpAdmins) ~= nil then
            local bool = true
            for k, v in pairs(IpAdmins) do
                if IpAdmins[k] then
                    if IpAdmins[k].name == nickname then
                        IpAdmins[k] = nil
                        bool = false
                    end
                end
            end
            if bool then
                sendresponse("There are no IP admins with a nickname of '" .. nickname .. "'", command, executor)
            else
                sendresponse(nickname .. " is no longer an IP admin", command, executor)
            end
        else
            sendresponse("There are no IP admins on this server.", command, executor)
        end
    else
        sendresponse("Error 004: Invalid Syntax: " .. command .. " [nickname]", command, executor)
    end
end

function Command_Ipban(executor, command, player, time, message, count)
    ipcount = 0
    if player then
        local words = tokenizestring(player, ".")
        ipcount = #words
    end
    if ipcount == 4 then
        local ipbantime = wordtotime(time) or -1
        local name = "the Server"
        if executor ~= nil then name = getname(executor) end
        message = tostring(message) or "None Given"
        BanReason("The IP: " .. player .. " was banned by " .. name .. " Reason: " .. message .. " Type: IP Ban")
        IP_BanList[player] = { }
        table.insert(IP_BanList[player], { ["name"] = "Player", ["ip"] = player, ["time"] = ipbantime, ["id"] = IP_BanID })
        IP_BanID = IP_BanID + 1
        sendresponse(player .. " has been banned from the server", command, executor)
    elseif ipcount > 1 then
        sendresponse("Invalid IP Address Format (xxx.xxx.xxx.xxx)", command, executor)
    else
        if count >= 2 and count <= 4 then
            local players = getvalidplayers(player, executor)
            if players then
                local name = "the Server"
                if executor ~= nil then name = getname(executor) end
                for i = 1, #players do
                    if CheckAccess(executor, command, players[i], getaccess(executor)) then
                        local ipbantime = wordtotime(time) or -1
                        message = tostring(message) or "None Given"
                        BanReason(getname(players[i]) .. " was banned by " .. name .. " Reason: " .. message .. " Type: IP Ban")
                        say(getname(players[i]) .. " was IP banned by " .. name .. " Reason: " .. message)
                        local ip = getip(players[i])
                        IP_BanList[ip] = { }
                        table.insert(IP_BanList[ip], { ["name"] = getname(players[i]), ["ip"] = getip(players[i]), ["time"] = ipbantime, ["id"] = IP_BanID })
                        IP_BanID = IP_BanID + 1
                        Ipban(players[i])
                        msg = getname(players[i]) .. " has been IP banned from the server"
                        hprintf(msg)
                        sendresponse(msg, command, executor)
                    else
                        local Command = getvalidformat(command)
                        sendresponse("You cannot execute " .. Command .. " on this admin.", command, executor)
                        sendresponse(tostring(getname(executor)) .. " attemped to use " .. Command .. " on you", command, players[i])
                    end
                end
            else
                sendresponse("Error 005: Invalid Player", command, executor)
            end
        else
            sendresponse("Error 004: Invalid Syntax: " .. command .. " [player or ip] {time} {message} ", command, executor)
        end
    end
end

function Command_Ipbanlist(executor, command, count)
    if count == 1 then
        if IP_BanList ~= { } then
            local response = "ID - Name - IP - Time"
            local response_table = { }
            local bool = true
            for k, v in pairs(IP_BanList) do
                if IP_BanList[k] ~= { } then
                    for key, value in pairs(IP_BanList[k]) do
                        local id = IP_BanList[k][key].id
                        response_table[id] = id .. "  |  " .. IP_BanList[k][key].name .. "  |  " .. IP_BanList[k][key].ip .. "  |  " .. timetoword(IP_BanList[k][key].time)
                    end
                end
            end
            for i = 0, IP_BanID do
                if response_table[i] then
                    bool = false
                    response = response .. "\n" .. response_table[i]
                end
            end
            if bool then
                response = "IP Banlist is empty"
            end
            sendresponse(response, command, executor)
        end
    else
        sendresponse("Error 004: Invalid Syntax: " .. command, command, executor)
    end
end

function Command_Ipunban(executor, command, ID, count)
    if count == 2 and tonumber(ID) then
        ID = tonumber(ID)
        local response = "Invalid ID"
        if ID <= IP_BanID then
            local bool = false
            for k, v in pairs(IP_BanList) do
                if IP_BanList[k] ~= { } then
                    for key, value in pairs(IP_BanList[k]) do
                        if IP_BanList[k][key].id == ID then
                            bool = true
                            response = k .. " has been unipbanned"
                            table.remove(IP_BanList[k])
                            break
                        end
                    end
                end
                if bool then
                    break
                end
            end
            sendresponse(response, command, executor)
        else
            sendresponse(response, command, executor)
        end
    else
        sendresponse("Error 004: Invalid Syntax: " .. command .. " [ID]", command, executor)
    end
end

function Command_Iprangeban(executor, command, player, time, message, count)
    local ipcount = 0
    if player then
        local words = tokenizestring(player, ".")
        ipcount = #words
    end
    if ipcount == 2 then
        local ipbantime = wordtotime(time) or -1
        local name = "the Server"
        if executor ~= nil then name = getname(executor) end
        message = tostring(message) or "None Given"
        BanReason("The IP: " .. player .. " was Banned by " .. name .. " Reason: " .. message .. " Type: IP Range Ban")
        IpRange_BanList[player] = { }
        table.insert(IpRange_BanList[player], { ["name"] = "Player", ["ip"] = player, ["time"] = ipbantime, ["id"] = IP_BanID })
        IpRange_BanID = IpRange_BanID + 1
        sendresponse(player .. " has been banned from the server", command, executor)
    elseif ipcount > 1 then
        sendresponse("Invalid IP Address Format (xxx.xxx)", command, executor)
    else
        if count >= 2 and count <= 4 then
            local players = getvalidplayers(player, executor, command)
            if players then
                local name = "the Server"
                if executor ~= nil then name = getname(executor) end
                for i = 1, #players do
                    if CheckAccess(executor, command, players[i], getaccess(executor)) then
                        local ipbantime = wordtotime(time) or -1
                        message = tostring(message) or "None Given"
                        BanReason(getname(players[i]) .. " was banned by " .. name .. " Reason: " .. message .. " Type: IP Range Ban")
                        say(getname(players[i]) .. " was IP banned by " .. name .. " Reason: " .. message)
                        local ip = getip(players[i])
                        local words = tokenizestring(ip, ".")
                        local ip2 = words[1] .. "." .. words[2]
                        IpRange_BanList[ip2] = { }
                        table.insert(IpRange_BanList[ip2], { ["name"] = getname(players[i]), ["ip"] = ip2, ["time"] = ipbantime, ["id"] = IpRange_BanID })
                        IpRange_BanID = IpRange_BanID + 1
                        Ipban(players[i])
                        msg = getname(players[i]) .. " has been IP banned from the server"
                        hprintf(msg)
                        sendresponse(msg, command, executor)
                    else
                        local Command = getvalidformat(command)
                        sendresponse("You cannot execute " .. Command .. " on this admin.", command, executor)
                        sendresponse(tostring(getname(executor)) .. " attemped to use " .. Command .. " on you", command, players[i])
                    end
                end
            else
                sendresponse("Error 005: Invalid Player", command, executor)
            end
        else
            sendresponse("Error 004: Invalid Syntax: " .. command .. " [player or ip] {time} {message} ", command, executor)
        end
    end
end

function Command_Iprangebanlist(executor, command, count)
    if count == 1 then
        if IpRange_BanList ~= { } then
            local response = "ID - Name - IP - Time"
            local response_table = { }
            local bool = true
            for k, v in pairs(IpRange_BanList) do
                if IpRange_BanList[k] ~= { } then
                    for key, value in pairs(IpRange_BanList[k]) do
                        local id = IpRange_BanList[k][key].id
                        response_table[id] = id .. "  |  " .. IpRange_BanList[k][key].name .. "  |  " .. IpRange_BanList[k][key].ip .. "  |  " .. timetoword(IpRange_BanList[k][key].time)
                    end
                end
            end
            for i = 0, IpRange_BanID do
                if response_table[i] then
                    bool = false
                    response = response .. "\n" .. response_table[i]
                end
            end
            if bool then
                response = "IP Range Banlist is empty"
            end
            sendresponse(response, command, executor)
        end
    else
        sendresponse("Error 004: Invalid Syntax: " .. command, command, executor)
    end
end

function Command_Iprangeunban(executor, command, ID, count)
    if count == 2 and tonumber(ID) then
        ID = tonumber(ID)
        local response = "Invalid ID"
        if ID <= IpRange_BanID then
            local bool = false
            for k, v in pairs(IpRange_BanList) do
                if IpRange_BanList[k] ~= { } then
                    for key, value in pairs(IpRange_BanList[k]) do
                        if IpRange_BanList[k][key].id == ID then
                            bool = true
                            response = k .. " has been uniprangebanned"
                            table.remove(IpRange_BanList[k])
                            break
                        end
                    end
                end
                if bool then
                    break
                end
            end
            sendresponse(response, command, executor)
        else
            sendresponse(response, command, executor)
        end
    else
        sendresponse("Error 004: Invalid Syntax: " .. command .. " [ID]", command, executor)
    end
end

function Command_Invis(executor, command, player, time, count)
    if count == 1 and executor ~= nil then
        local m_objectId = getplayerobjectid(executor)
        if m_objectId then
            if getobject(m_objectId) and Ghost_Table[getip(executor)] == nil then
                Ghost_Table[getip(executor)] = true
                sendresponse("You are now invisible", command, executor)
            elseif Ghost_Table[getip(executor)] then
                sendresponse("You are already invisible", command, executor)
            else
                sendresponse("You are dead dead", command, executor)
            end
        else
            sendresponse("You are dead dead", command, executor)
        end
    elseif count == 1 and executor == nil then
        sendresponse("The server cannot be invisible", command, executor)
    elseif count == 2 then
        local players = getvalidplayers(player, executor)
        if players then
            for i = 1, #players do
                local m_objectId = getplayerobjectid(players[i])
                if m_objectId then
                    if getobject(m_objectId) and Ghost_Table[getip(players[i])] == nil then
                        Ghost_Table[getip(players[i])] = true
                        sendresponse(getname(players[i]) .. " is now invisible", command, executor)
                    elseif Ghost_Table[getip(players[i])] then
                        sendresponse(getname(players[i]) .. " is already invisible", command, executor)
                    else
                        sendresponse(getname(players[i]) .. " is dead", command, executor)
                    end
                else
                    sendresponse(getname(players[i]) .. " is dead", command, executor)
                end
            end
        else
            sendresponse("Error 005: Invalid Player", command, executor)
        end
    elseif count == 3 and tonumber(time) then
        local players = getvalidplayers(player, executor)
        if players then
            for i = 1, #players do
                local m_objectId = getplayerobjectid(players[i])
                if m_objectId then
                    if getobject(m_objectId) and Ghost_Table[getip(players[i])] == nil then
                        Ghost_Table[getip(players[i])] = tonumber(time)
                        sendresponse(getname(players[i]) .. " is now invisible for " .. time .. " seconds", command, executor)
                        privatesay(players[i], "You are now invisible for " .. time .. " seconds.")
                    elseif Ghost_Table[getip(players[i])] then
                        sendresponse(getname(players[i]) .. " is already invisible", command, executor)
                    else
                        sendresponse(getname(players[i]) .. " is dead", command, executor)
                    end
                else
                    sendresponse(getname(players[i]) .. " is dead", command, executor)
                end
            end
        else
            sendresponse("Error 005: Invalid Player", command, executor)
        end
    else
        sendresponse("Error 004: Invalid Syntax: " .. command .. " [player] {time}", command, executor)
    end
end

function Command_Kick(executor, command, player, message, count)
    if count == 2 or count == 3 then
        local players = getvalidplayers(player, executor, command)
        if players then
            local name = "the Server."
            if executor ~= nil then name = getname(executor) end
            for i = 1, #players do
                if CheckAccess(executor, command, players[i], getaccess(executor)) then
                    if executor ~= players[i] then
                        message = message or "None Given"
                        WriteLog(profilepath .. "\\logs\\Player Kicks.log", getname(players[i]) .. " was kicked by " .. name .. " Reason: " .. message)
                        say(getname(players[i]) .. " was kicked by " .. name .. " Reason: " .. message)
                        msg = getname(players[i]) .. " has been kicked from the server"
                        sendresponse(msg, command, executor)
                        svcmd("sv_kick " .. resolveplayer(players[i]))
                    else
                        sendresponse("You cannot kick yourself", command, executor)
                    end
                else
                    local Command = getvalidformat(command)
                    sendresponse("You cannot execute " .. Command .. " on this admin.", command, executor)
                    sendresponse(tostring(getname(executor)) .. " attemped to use " .. Command .. " on you", command, players[i])
                end
            end
        else
            sendresponse("Error 005: Invalid Player", command, executor)
        end
    else
        sendresponse("Error 004: Invalid Syntax: " .. command .. ' [player] {reason}', command, executor)
    end
end

function Command_Kill(executor, command, player, count)
    if count == 2 then
        local players = getvalidplayers(player, executor)
        if players then
            for i = 1, #players do
                kill(players[i])
                sendresponse(getname(players[i]) .. " has been killed", command, executor)
            end
        else
            sendresponse("Error 005: Invalid Player", command, executor)
        end
    else
        sendresponse("Error 004: Invalid Syntax: " .. command .. " [player]", command, executor)
    end
end

function Command_KillingSpree(executor, command, boolean, count)
    if count == 1 then
        if killing_spree then
            sendresponse("Killing Spree Notifications is currently on", command, executor)
        else
            sendresponse("Killing Spree Notifications is currently off", command, executor)
        end
    elseif count == 2 then
        if (boolean == "1" or boolean == "true") and killing_spree ~= true then
            killing_spree = true
            sendresponse("Killing Spree Notifications is now enabled", command, executor)
        elseif (boolean == "1" or boolean == "true") and killing_spree == true then
            sendresponse("Killing Spree Notifications is already enabled", command, executor)
        elseif (boolean == "0" or boolean == "false") and killing_spree ~= false then
            killing_spree = false
            sendresponse("Killing Spree Notifications is now disabled", command, executor)
        elseif killing_spree == nil then
            killing_spree = false
            sendresponse("Killing Spree Notifications is now disabled", command, executor)
        elseif (boolean == "0" or boolean == "false") and killing_spree == false then
            sendresponse("Killing Spree Notifications is already disabled", command, executor)
        else
            sendresponse("Error 009: Invalid Boolean: 0 for false, 1 for true", command, executor)
        end
    else
        sendresponse("Error 004: Invalid Syntax: " .. command .. " {boolean}", command, executor)
    end
end

function Command_Launch(executor, command, player, count)
    if count == 2 then
        local players = getvalidplayers(player, executor)
        if players then
            for i = 1, #players do
                local m_objectId = getplayerobjectid(players[i])
                if m_objectId then
                    local m_object = getobject(m_objectId)
                    if m_object then
                        local m_vehicleId = readdword(m_object + 0x11C)
                        local m_vehicle = getobject(m_vehicleId)
                        if m_vehicle then
                            sendresponse(getname(players[i]) .. " has been launched", command, executor)
                            local tagName = getobjecttag(m_vehicleId)
                            writebit(m_vehicle + 0x10, 2, 0)
                            if tagName == "vehicles\\scorpion\\scorpion_mp" then
                                writefloat(m_vehicle + 0x94, 15)
                                writefloat(m_vehicle + 0x70, 0.35)
                                writefloat(m_vehicle + 0x6C, 0.35)
                            elseif tagName == "vehicles\\banshee\\banshee_mp" then
                                writefloat(m_vehicle + 0x90, 30)
                                writefloat(m_vehicle + 0x70, 0.35)
                                writefloat(m_vehicle + 0x6C, -0.4)
                            elseif tagName == "vehicles\\ghost\\ghost_mp" then
                                writefloat(m_vehicle + 0x8C, 7)
                                writefloat(m_vehicle + 0x70, 0.35)
                            elseif tagName == "vehicles\\warthog\\mp_warthog" then
                                writefloat(m_vehicle + 0x94, 10)
                                writefloat(m_vehicle + 0x70, 0.35)
                            elseif tagName == "vehicles\\rwarthog\\rwarthog" then
                                writefloat(m_vehicle + 0x94, 15)
                                writefloat(m_vehicle + 0x70, 0.35)
                            else
                                writefloat(m_vehicle + 0x94, 10)
                                writefloat(m_vehicle + 0x70, 0.35)
                            end
                        else
                            sendresponse(getname(players[i]) .. " is not in a vehicle", command, executor)
                        end
                    else
                        sendresponse(getname(players[i]) .. " is dead", command, executor)
                    end
                else
                    sendresponse(getname(players[i]) .. " is dead", command, executor)
                end
            end
        else
            sendresponse("Error 005: Invalid Player", command, executor)
        end
    else
        sendresponse("Error 004: Invalid Syntax: " .. command .. " [player]", command, executor)
    end
end

function Command_List(executor, command, word, count)
    local word = tonumber(word)
    if count == 2 then
        if word == 1 then
            sendresponse("sv_setafk\nsv_admin_list\nsv_admin_add\nsv_admin_del\nsv_revoke\nsv_alias", command, executor)
            sendresponse("sv_adminblocker\nsv_anticaps\nsv_antispam\nsv_ban", command, executor)
        elseif word == 2 then
            sendresponse("sv_bos\nsv_boslist\nsv_bosplayers\nsv_chatcommands\nsv_change_level", command, executor)
            sendresponse("sv_changeteam\nsv_crash\nsv_commands\nsv_control\nsv_count", command, executor)
        elseif word == 3 then
            sendresponse("sv_uniques_enabled\nsv_deathless\nsv_eject\nsv_falldamage\nsv_firstjoin_message", command, executor)
            sendresponse("sv_follow\nsv_gethash\nsv_getip\nsv_getloc\nsv_setgod", command, executor)
        elseif word == 4 then
            sendresponse("sv_cheat_hax\nsv_heal\nsv_help\nsv_hide\nsv_hitler\nsv_ipadminadd\nsv_ipadmindelete", command, executor)
            sendresponse("sv_ipban\nsv_ipbanlist\nsv_info", command, executor)
        elseif word == 5 then
            sendresponse("sv_infinite_ammo\nsv_ipunban\nsv_invis\nsv_kick\nsv_kill\nsv_killspree\nsv_launch", command, executor)
            sendresponse("sv_list\nsv_scrim\nsv_login", command, executor)
        elseif word == 6 then
            sendresponse("sv_map\nsv_mnext\nsv_reset\nsv_move\nsv_mute\nsv_nameban\nsv_namebanlist", command, executor)
            sendresponse("sv_nameunban\nsv_noweapons\nsv_os\n", command, executor)
        elseif word == 7 then
            sendresponse("sv_pvtmessage\nsv_pvtsay\nsv_players_more\nsv_players\nsv_resetweapons\nsv_resp", command, executor)
            sendresponse("sv_rtv_enabled\nsv_rtv_needed\nsv_serveradmin_message\nsv_scrimmode\n", command, executor)
        elseif word == 8 then
            sendresponse("sv_spawn\nsv_give\nsv_spammax\nsv_spamtimeout\nsv_setammo\nsv_setassists", command, executor)
            sendresponse("sv_setcolor\nsv_setdeaths\nsv_setfrags\nsv_setkills\n", command, executor)
        elseif word == 9 then
            sendresponse("sv_setmode\nsv_pass\nsv_setscore\nsv_respawn_time\nsv_setplasmas\nsv_setspeed", command, executor)
            sendresponse("sv_specs\nsv_mc\nsv_superban\nsv_suspend\n", command, executor)
        elseif word == 10 then
            sendresponse("sv_status\nsv_takeweapons\nsv_tbagdet\nsv_test\nsv_textban\nsv_textbanlist", command, executor)
            sendresponse("sv_textunban\nsv_time_cur\nsv_unbos\nsv_cheat_unhax\n", command, executor)
        elseif word == 11 then
            sendresponse("sv_unhide\nsv_ungod\nsv_uninvis\nsv_unmute\nsv_unsuspend\nsv_viewadmins", command, executor)
            sendresponse("sv_votekick_enabled\nsv_votekick_needed\nsv_votekick_action\nsv_welcomeback_message\n", command, executor)
        elseif word == 12 then
            sendresponse("sv_write\nsv_balance\nsv_stickman\nsv_addrcon\nsv_delrcon\nsv_rconlist", command, executor)
            sendresponse("sv_iprangeban\nsv_iprangeunban\nsv_iprangebanlist\nsv_read", command, executor)
        elseif word == 13 then
            sendresponse("sv_load\nsv_unload\nsv_resetplayer\nsv_damage\nsv_hash_duplicates", command, executor)
            sendresponse("sv_multiteam_vehicles", command, executor)
        else
            sendresponse("The commands list is only 13 pages", command, executor)
        end
    else
        sendresponse("Error 004: Invalid Syntax: " .. command .. " {page}", command, executor)
    end
end

function Command_Lo3(executor, command, count)
    if count == 1 then
        if lo3_timer == nil then
            lo3_timer = registertimer(2000, "lo3Timer")
        end
        sendresponse("Live on three.", command, executor)
    else
        sendresponse("Error 004: Invalid Syntax: " .. command, command, executor)
    end
end

function Command_Login(executor, command, username, password, count)
    if count == 1 and executor ~= nil and next(Admin_Table) == nil and next(Admin_Table) == nil then
        Temp_Admins[getip(executor)] = true
        sendresponse("You have successfully logged in, you are now able to use chat commands.", command, executor)
    elseif executor == nil then
        sendresponse("The server cannot use this command.", command, executor)
    elseif next(Admin_Table) ~= nil and next(Admin_Table) ~= nil then
        sendresponse("This command is currently unavailable", command, executor)
    else
        sendresponse("Error 004: Invalid Syntax: " .. command, command, executor)
    end
end

function Command_Map(executor, command)
    local args = tokenizecmdstring(command)
    local count = #args
    if count > 2 and tonumber(args) == nil then
        local found = false
        local arguments = ""
        for i = 4, #args do
            if arguments == nil then
                arguments = args[i]
            else
                arguments = arguments .. " " .. args[i]
            end
            if args[i] == "commands" and args[i] ~= args[1] and args[i] ~= args[2] and args[i] ~= args[3] and not Persistent then
                found = true
            end
        end
        if not found then
            arguments = arguments .. " commands"
        end
        arguments = string.gsub(arguments, "  ", " ")
        if tonumber(arguments) == nil then
            local response = ""
            if string.sub(args[1], 1, 2) ~= "sv" then
                response = svcmd("sv_map " .. args[2] .. " \"" .. args[3] .. "\" " .. tostring(arguments), true)
            else
                response = svcmd("sv_map " .. args[2] .. " \"" .. args[3] .. "\" " .. tostring(arguments), true)
            end
            if response == "" or response == nil then return end
            sendresponse(response, args[1], executor)
        else
            sendresponse("Internal Error Occured Check the Command Script Errors log", args[1], executor)
            cmderrors("Error Occured at Command_Map")
        end
    else
        sendresponse("Error 004: Invalid Syntax: " .. args[1] .. " [map] [gametype] {script1} {script2}...", args[1], executor)
    end
end

function Command_Mapnext(executor, command, count)
    if count == 1 then
        if executor then
            svcmdplayer("sv_map_next", executor)
        else
            svcmd("sv_map_next", true)
        end
    else
        sendresponse("Error 004: Invalid Syntax: " .. command, command, executor)
    end
end

function Command_Mapreset(executor, command, count)
    if count == 1 then
        sendresponse("The map has been reset", command, executor)
        svcmd("sv_map_reset")
    else
        sendresponse("Error 004: Invalid Syntax: " .. command, command, executor)
    end
end

function Command_Move(executor, command, player, X, Y, Z, count)
    if count == 5 then
        if tonumber(X) and tonumber(Y) and tonumber(Z) then
            local players = getvalidplayers(player, executor)
            if players then
                for i = 1, #players do
                    local m_playerObjId = getplayerobjectid(players[i])
                    if m_playerObjId then
                        local m_objectId = nil
                        if isinvehicle(players[i]) then
                            local m_vehicleId = readdword(getobject(m_playerObjId) + 0x11C)
                            m_objectId = m_vehicleId
                        elseif m_playerObjId then
                            m_objectId = m_playerObjId
                        end
                        if m_objectId then
                            local x, y, z = getobjectcoords(m_objectId)
                            movobjectcoords(m_objectId, x + X, y + Y, z + Z)
                            sendresponse(getname(players[i]) .. " has been moved", command, executor)
                            sendresponse("You have been moved.", "\\", players[i])
                        end
                    else
                        sendresponse(getname(players[i]) .. " is dead", command, executor)
                    end
                end
            else
                sendresponse("Error 005: Invalid Player", command, executor)
            end
        else
            sendresponse("They must all be numbers", command, executor)
        end
    else
        sendresponse("Error 004: Invalid Syntax: " .. command .. " [player] [x] [y] [z]", command, executor)
    end
end

function Command_Mute(executor, command, player, count)
    if count == 2 then
        local players = getvalidplayers(player, executor)
        if players then
            for i = 1, #players do
                local ip = getip(players[i])
                local mute
                if Admin_Table[gethash(players[i])] or IpAdmins[ip] then
                    mute = true
                    sendresponse(getname(players[i]) .. " is an Admin, you cannot mute them", command, executor)
                    break
                end
                if not mute then
                    if not Mute_Table[ip] and not SpamTimeOut_Table[ip] then
                        Mute_Table[ip] = true
                        sendresponse(getname(players[i]) .. " was muted by an admin", command, executor)
                    else
                        sendresponse(getname(players[i]) .. " has already been muted.", command, executor)
                    end
                else
                    sendresponse("Admins cannot be muted.", command, executor)
                end
            end
        else
            sendresponse("Error 005: Invalid Player", command, executor)
        end
    else
        sendresponse("Error 004: Invalid Syntax: " .. command .. " [player]", command, executor)
    end
end

function Command_MultiTeamVehicles(executor, command, boolean, count)
    if gametype == 2 and not team_play then
        if count == 1 then
            if multiteam_vehicles then
                sendresponse("Multi Team Vehicles are currently enabled", command, executor)
            else
                sendresponse("Multi Team Vehicles are currently disabled", command, executor)
            end
        elseif count == 2 then
            if (boolean == "1" or boolean == "true") and not multiteam_vehicles then
                multiteam_vehicles = true
                for i = 0, 15 do
                    local m_player = getplayer(i)
                    if m_player then
                        writebyte(m_player + 0x20, 0)
                    end
                end
                sendresponse("Multi Team Vehicles are now enabled", command, executor)
            elseif (boolean == "1" or boolean == "true") and multiteam_vehicles then
                sendresponse("Multi Team Vehicles are already enabled", command, executor)
            elseif (boolean == "0" or boolean == "false") and multiteam_vehicles or multiteam_vehicles == nil then
                multiteam_vehicles = false
                for i = 0, 15 do
                    local m_player = getplayer(i)
                    if m_player then
                        writebyte(m_player + 0x20, i)
                    end
                end
                sendresponse("Multi Team Vehicles are now disabled", command, executor)
            elseif (boolean == "0" or boolean == "false") and not multiteam_vehicles then
                sendresponse("Multi Team Vehicles are already disabled", command, executor)
            else
                sendresponse("Error 009: Invalid Boolean: 0 for false, 1 for true", command, executor)
            end
        else
            sendresponse("Error 004: Invalid Syntax: " .. command .. " {boolean}", command, executor)
        end
    else
        sendresponse("This command is currently disabled for this game", command, executor)
    end
end

function Command_Nameban(executor, command, player, count)
    if count == 2 and tonumber(command) == nil then
        local players = getvalidplayers(player, executor, command)
        if players then
            for i = 1, #players do
                if CheckAccess(executor, command, players[i], getaccess(executor)) then
                    local name = getname(players[i])
                    local bool = true
                    for i = 1, #Name_Bans do
                        if Name_Bans[i] == name then bool = false break end
                    end
                    if bool then
                        table.insert(Name_Bans, name)
                        Ipban(players[i])
                        msg = name .. " has been name banned from the server"
                        sendresponse(msg, "/", executor)
                    end
                else
                    local Command = getvalidformat(command)
                    sendresponse("You cannot execute " .. Command .. " on this admin.", command, executor)
                    sendresponse(tostring(getname(executor)) .. " attemped to use " .. Command .. " on you", command, players[i])
                end
            end
        else
            sendresponse("Error 005: Invalid Player", command, executor)
        end
    else
        sendresponse("Error 004: Invalid Syntax: " .. command .. " [player]", command, executor)
    end
end

function Command_Namebanlist(executor, command, count)
    if count == 1 then
        if Name_Bans == { } or Name_Bans == nil or #Name_Bans == 0 then
            sendresponse("There are no names banned from the server.", command, executor)
            return
        end
        for i = 1, #Name_Bans do
            if Name_Bans[i] then
                sendresponse("[" .. i .. "] " .. Name_Bans[i], command, executor)
            end
        end
    else
        sendresponse("Error 004: Invalid Syntax: " .. command, command, executor)
    end
end

function Command_Nameunban(executor, command, ID, count)
    if count == 2 then
        local ID = tonumber(ID)
        if Name_Bans[ID] then
            sendresponse(Name_Bans[ID] .. " is now allowed in the server again.", command, executor)
            Name_Bans[ID] = nil
        else
            sendresponse("That name has not been banned.", command, executor)
        end
    else
        sendresponse("Error 004: Invalid Syntax: " .. command .. " [ID]", command, executor)
    end
end

function Command_Noweapons(executor, command, boolean, count)
    if count == 1 then
        if noweapons then
            sendresponse("Noweapons mode is currently enabled.", command, executor)
        else
            sendresponse("Noweapons mode is currently disabled.", command, executor)
        end
    elseif count == 2 then
        if (boolean == "1" or boolean == "true") and not noweapons then
            for i = 0, 15 do
                if getplayer(i) then
                    local m_objectId = getplayerobjectid(i)
                    if m_objectId then
                        local m_object = getobject(m_objectId)
                        if m_object then
                            for j = 0, 3 do
                                local weap_id = readdword(m_object + 0x2F8 +(j * 4))
                                if getobject(weap_id) then
                                    destroyobject(weap_id)
                                end
                            end
                        end
                    end
                end
            end
            sendresponse("Noweapons is now on. You cannot pick up weapons.", command, executor)
            noweapons = true
        elseif boolean == "1" or boolean == "true" then
            sendresponse("Noweapons is already enabled", command, executor)
        elseif boolean ~= "0" and boolean ~= "false" then
            sendresponse("Error 009: Invalid Boolean: 0 for false, 1 for true", command, executor)
        elseif (boolean == "0" or boolean == "false") and noweapons then
            for i = 0, 15 do
                if getplayer(i) and getplayerobjectid(i) then
                    local ip = getip(i)
                    if Noweapons[ip] then Noweapons[ip] = nil end
                    resetweapons(i)
                end
            end
            sendresponse("Noweapons mode is now off.", command, executor)
            noweapons = false
        elseif noweapons == nil then
            sendresponse("Noweapons mode is now off.", command, executor)
            noweapons = false
        elseif boolean == "0" or boolean == "false" then
            sendresponse("Noweapons is already disabled", command, executor)
        else
            sendresponse("Error 009: Invalid Boolean: 0 for false, 1 for true", command, executor)
        end
    else
        sendresponse("Error 004: Invalid Syntax: " .. command .. " [boolean]", command, executor)
    end
end

function Command_Nuke(executor, command, player, count)
    if count == 2 then
        local players = getvalidplayers(player, executor)
        if players then
            for i = 1, #players do
                local name = getname(players[i])
                local m_objectId = getplayerobjectid(players[i])
                if m_objectId ~= nil then
                    local m_object = getobject(m_objectId)
                    local x, y, z = getobjectcoords(m_objectId)
                    for j = 1, 5 do
                        local nukeproj = createobject(rocket_tag_id, m_objectId, 0, false, x, y, z + 10)
                        table.insert(nukes, nukeproj)
                        local m_proj = getobject(nukeproj)
                        writefloat(m_proj + 0x70, -5)
                    end
                else
                    sendresponse("You cannot Nuke: " .. name .. " - because he is re-spawning.", command, executor)
                end
            end
        else
            sendresponse("Error 005: Invalid Player", command, executor)
        end
    else
        sendresponse("Error 004: Invalid Syntax: " .. command .. " [player]", command, executor)
    end
end

function Command_Overshield(executor, command, player, count)
    if count == 1 and executor ~= nil then
        local m_playerObjId = getplayerobjectid(executor)
        if m_playerObjId then
            local m_object = getobject(m_playerObjId)
            if m_object then
                local obj_shields = readfloat(m_object + 0xE4)
                if obj_shields <= 1 then
                    local m_vehicleId = readdword(m_object + 0x11C)
                    if m_vehicleId == nil then
                        local x, y, z = getobjectcoords(m_playerObjId)
                        local os = createobject(overshield_tag_id, 0, 0, false, x, y, z + 0.5)
                        if os ~= nil then writefloat(getobject(os) + 0x70, -2) end
                    else
                        writefloat(m_object + 0xE4, 3)
                    end
                    sendresponse("You have given yourself an Over-Shield", command, executor)
                else
                    sendresponse("You already have an Over-Shield", command, executor)
                end
            else
                sendresponse("You are dead", command, executor)
            end
        else
            sendresponse("You are dead", command, executor)
        end
    elseif count == 1 and executor == nil then
        sendresponse("The server cannot have an Over-Shield.", command, executor)
    elseif count == 2 then
        local players = getvalidplayers(player, executor)
        if players then
            for i = 1, #players do
                local m_playerObjId = getplayerobjectid(players[i])
                if m_playerObjId then
                    local m_object = getobject(m_playerObjId)
                    if m_object then
                        local obj_shields = readfloat(m_object + 0xE4)
                        if obj_shields <= 1 then
                            local m_vehicleId = readdword(m_object + 0x11C)
                            if m_vehicleId == nil then
                                local x, y, z = getobjectcoords(m_playerObjId)
                                local os = createobject(overshield_tag_id, 0, 0, false, x, y, z + 0.5)
                                if os ~= nil then writefloat(getobject(os) + 0x70, -2) end
                            else
                                writefloat(m_object + 0xE4, 3)
                            end
                            sendresponse(getname(players[i]) .. " has been given an Over-Shield", command, executor)
                        else
                            sendresponse(getname(players[i]) .. " already has an Over-Shield", command, executor)
                        end
                    else
                        sendresponse(getname(players[i]) .. " is dead", command, executor)
                    end
                else
                    sendresponse(getname(players[i]) .. " is dead", command, executor)
                end
            end
        else
            sendresponse("Error 005: Invalid Player", command, executor)
        end
    else
        sendresponse("Error 004: Invalid Syntax: " .. command .. " {player}", command, executor)
    end
end

function Command_Players(executor, command, count)

    if count == 1 then
        sendresponse("Player Search:", command, executor)
        sendresponse("[ ID.    -    Name.    -    Team.    -    IP.    -    Ping. ]", command, executor)
        for i = 0, 15 do
            if getplayer(i) then
                local name = getname(i)
                local id = resolveplayer(i)
                local player_team = getteam(i)
                local port = getport(i)
                local ip = getip(i)
                local hash = gethash(i)
                local ping = readword(getplayer(i) + 0xDC)
                if team_play then
                    if player_team == 0 then
                        player_team = "Red Team"
                    elseif player_team == 1 then
                        player_team = "Blue Team"
                    else
                        player_team = "Hidden"
                    end
                else
                    player_team = "FFA"
                end
                sendresponse(" (" .. id .. ")  " .. name .. "   |   " .. player_team .. "  -  (IP: " .. ip .. ")  -  (Ping: " .. ping .. ")", command, executor)
            end
        end
    else
        sendresponse("Error 004: Invalid Syntax: " .. command, command, executor)
    end
end


function Command_PlayersMore(executor, command, count)
    if count == 1 or count == 2 and t[2] == "more" then
        sendresponse("[ID - Name -  Team - Status - IP]", command, executor)
        for i = 0, 15 do
            if getplayer(i) then
                local ip = getip(i)
                local player_team = getteam(i)
                if team_play then
                    if player_team == 0 then
                        player_team = "Red"
                    elseif player_team == 1 then
                        player_team = "Blue"
                    else
                        player_team = "Hidden"
                    end
                else
                    player_team = "FFA"
                end
                if Admin_Table[gethash(i)] or IpAdmins[ip] then
                    ifadmin = "Admin"
                else
                    ifadmin = "Regular"
                end
                sendresponse(resolveplayer(i) .. " - " .. getname(i) .. " - " .. player_team .. " - " .. ifadmin .. " - " .. ip, command, executor)
            end
        end
    else
        sendresponse("Error 004: Invalid Syntax: " .. command, command, executor)
    end
end

function Command_PrivateMessage(executor, command, boolean, count)
    if count == 1 then
        if pm_enabled then
            sendresponse("Private Messaging is currently on", command, executor)
        else
            sendresponse("Private Messaging is currently off", command, executor)
        end
    elseif count == 2 then
        if (boolean == "1" or boolean == "true") and pm_enabled ~= true then
            pm_enabled = true
            sendresponse("Private Messaging is now enabled", command, executor)
        elseif (boolean == "1" or boolean == "true") and pm_enabled == true then
            sendresponse("Private Messaging is already enabled", command, executor)
        elseif (boolean == "0" or boolean == "false") and pm_enabled ~= false then
            pm_enabled = false
            sendresponse("Private Messaging is now disabled", command, executor)
        elseif pm_enabled == nil then
            pm_enabled = false
            sendresponse("Private Messaging is now disabled", command, executor)
        elseif (boolean == "0" or boolean == "false") and pm_enabled == false then
            sendresponse("Private Messaging is already disabled", command, executor)
        else
            sendresponse("Error 009: Invalid Boolean: 0 for false, 1 for true", command, executor)
        end
    else
        sendresponse("Error 004: Invalid Syntax: " .. command .. " {boolean}", command, executor)
    end
end

function Command_Privatesay(executor, args, count)
    if count >= 3 and tonumber(args[1]) == nil then
        local players = getvalidplayers(args[2], executor)
        if players then
            local message = ""
            for i = 3, #args do
                message = message .. args[i] .. " "
            end
            for i = 1, #players do
                privateSay(players[i], tostring(message))
            end
            sendresponse("Private messages sent.", args[1], executor)
        else
            sendresponse("Error 005: Invalid Player", args[1], executor)
        end
    else
        sendresponse("Error 004: Invalid Syntax: " .. args[1] .. " [player] [message]", args[1], executor)
    end
end

function Command_RconPasswordList(executor, command, count)
    if count == 1 then
        local Response = "[rcon] - [level]\n"
        for k, v in pairs(RCON_PASSWORDS) do
            if RCON_PASSWORDS[k] ~= nil and RCON_PASSWORDS[k] ~= { } then
                for key, value in ipairs(RCON_PASSWORDS[k]) do
                    Response = Response .. "[ " .. RCON_PASSWORDS[k][key].password .. " ] - [ " .. RCON_PASSWORDS[k][key].level .. " ]\n"
                end
            end
        end
        sendresponse(Response, command, executor)
    else
        sendresponse("Error 004: Invalid Syntax: " .. command, command, executor)
    end
end

function Command_Read(executor, command, type, struct, offset, value, player, count)
    local offset = tonumber(offset)
    if count > 4 and count < 7 and tonumber(type) == nil and tonumber(struct) == nil and offset then
        local players = getvalidplayers(player, executor)
        if players then
            for i = 1, #players do
                local m_objectId = getplayerobjectid(players[i])
                if m_objectId then
                    if struct == "player" then
                        struct = getplayer(players[i])
                    elseif struct == "object" then
                        struct = getobject(m_objectId)
                        if struct == nil then sendresponse(getname(players[i]) .. " is not alive.", command, executor) return end
                    elseif getobject(m_objectId) == nil then
                        sendresponse(getname(players[i]) .. " is not alive.", command, executor)
                        return
                    elseif struct == "weapon" then
                        local m_object = getobject(m_objectId)
                        struct = getobject(readdword(m_object + 0x118))
                        if struct == nil then sendresponse(getname(players[i]) .. " is not holding a weapon", command, executor) return end
                    elseif tonumber(struct) == nil then
                        sendresponse("Invalid Struct. Valid structs are: player, object, and weapon", command, executor)
                        return
                    end
                end
                if value then
                    if type == "byte" then
                        response = tostring(readbyte(struct + offset, value))
                    elseif type == "float" then
                        response = tostring(readfloat(struct + offset, value))
                    elseif type == "word" then
                        response = tostring(readword(struct + offset, value))
                    elseif type == "dword" then
                        response = tostring(readdword(struct + offset, value))
                    else
                        sendresponse("Error 010: Invalid Type. Valid types are byte, float, word, and dword", command, executor)
                        return
                    end
                    sendresponse("Reading " .. tostring(value) .. " to struct " .. tostring(struct) .. " at offset " .. tostring(offset) .. " was a success", command, executor)
                    sendrespose(response, command, executor)
                end
            end
        else
            sendresponse("Error 005: Invalid Player", command, executor)
        end
    else
        sendresponse("Error 004: Invalid Syntax: " .. command .. " [type] [struct] [offset] [value] [player]", command, executor)
    end
end

function Command_ResetPlayer(executor, command, player, count)
    if count == 2 then
        local players = getvalidplayers(player, executor)
        if players then
            for i = 1, #players do
                local ip = getip(players[i])
                local m_objectId = getplayerobjectid(players[i])
                local m_object
                if m_objectId then
                    m_object = getobject(m_objectId)
                end
                local id = resolveplayer(players[i])
                local m_player = getplayer(players[i])
                follow[id] = nil
                resetweapons(players[i])
                cleanupdrones(players[i])
                if m_object then
                    writefloat(m_object + 0xE0, 1)
                    writefloat(m_object + 0xE4, 1)
                end
                writedword(m_player + 0x2C, 0)
                Ghost_Table[ip] = nil
                mode[ip] = nil
                gods[ip] = nil
                hidden[id] = nil
                hidden[id] = nil
                Noweapons[ip] = nil
                for j = 1, 16 do
                    for k = 1, 16 do
                        if Control_Table[j][k] == players[i] then
                            Control_Table[j][k] = nil
                            bool = true
                            break
                        end
                    end
                    if bool then
                        break
                    end
                end
                sendresponse(getname(players[i]) .. " has been reset.", command, executor)
            end
        end
    else
        sendresponse("Error 004: Invalid Syntax: " .. command .. " [player]", command, executor)
    end
end

function Command_Resetweapons(executor, command, player, count)
    if count == 2 then
        local players = getvalidplayers(player, executor)
        if players then
            for i = 1, #players do
                local ip = getip(players[i])
                if ip then
                    if Noweapons[ip] then
                        Noweapons[ip] = nil
                        local m_objectId = getplayerobjectid(players[i])
                        if m_objectId then
                            local m_object = getobject(m_objectId)
                            if m_object then
                                resetweapons(players[i])
                                sendresponse(getname(players[i]) .. " had their weapons reset", command, executor)
                            end
                        end
                    else
                        sendresponse(getname(players[i]) .. " never had their weapons taken away", command, executor)
                    end
                end
            end
        else
            sendresponse("Error 005: Invalid Player", command, executor)
        end
    else
        sendresponse("Error 004: Invalid Syntax: " .. command .. " [player]", command, executor)
    end
end

function Command_Resp(executor, command, player, time, count)
    if count == 3 and tonumber(time) then
        local players = getvalidplayers(player, executor)
        if players then
            for i = 1, #players do
                local m_player = getplayer(players[i])
                local m_objectId = getplayerobjectid(players[i])
                if m_objectId == nil then
                    writedword(m_player + 0x2c, time * 33)
                    sendresponse("Setting " .. getname(players[i]) .. "'s re-spawn time to " .. time .. " seconds", command, executor)
                else
                    sendresponse(getname(players[i]) .. " is alive. You cannot execute this command on him.", command, executor)
                end
            end
        else
            sendresponse("Error 005: Invalid Player", command, executor)
        end
    else
        sendresponse("Error 004: Invalid Syntax: " .. command .. " [player] [time]", command, executor)
    end
end

function Command_RTVEnabled(executor, command, boolean, count)
    if count == 1 then
        if rockthevote then
            sendresponse("RockTheVote is currently on", command, executor)
        else
            sendresponse("RockTheVote is currently off", command, executor)
        end
    elseif count == 2 then
        if (boolean == "1" or boolean == "true") and rockthevote ~= true then
            rockthevote = true
            if rtv_required == nil then
                rtv_required = 0.6
            end
            sendresponse("RockTheVote is now enabled The default percentage needed is 60%.", command, executor)
            sendresponse("Change this with sv_rtv_needed", command, executor)
        elseif (boolean == "1" or boolean == "true") and rockthevote == true then
            sendresponse("RockTheVote is already enabled", command, executor)
        elseif (boolean == "0" or boolean == "false") and rockthevote ~= false then
            rockthevote = false
            sendresponse("RockTheVote is now disabled", command, executor)
        elseif rockthevote == nil then
            rockthevote = false
            sendresponse("RockTheVote is now disabled", command, executor)
        elseif (boolean == "0" or boolean == "false") and rockthevote == false then
            sendresponse("RockTheVote is already disabled", command, executor)
        else
            sendresponse("Error 009: Invalid Boolean: 0 for false, 1 for true", command, executor)
        end
    else
        sendresponse("Error 004: Invalid Syntax: " .. command .. " {boolean}", command, executor)
    end
end

function Command_RTVRequired(executor, command, percent, count)
    if count == 1 then
        if rtv_required == nil then rtv_required = 0.6 end
        sendresponse(tostring(rtv_required * 100) .. "% votes required for RTV", command, executor)
    elseif count == 2 and tonumber(percent) then
        if tonumber(percent) <= 1 then
            sendresponse("Votes required for RTV has been set to " .. tonumber(percent) * 100 .. "%", command, executor)
            rtv_required = tonumber(percent)
        end
    else
        sendresponse("Error 004: Invalid Syntax: " .. command .. " [votes required (as a decimal)]", command, executor)
    end
end

function Command_SAMessage(executor, command, boolean, count)
    if count == 1 then
        if sa_message then
            sendresponse("Server Admin Message is currently on", command, executor)
        else
            sendresponse("Server Admin Message is currently off", command, executor)
        end
    elseif count == 2 then
        if (boolean == "1" or boolean == "true") and sa_message ~= true then
            sa_message = true
            sendresponse("Server Admin Message is now enabled", command, executor)
        elseif (boolean == "1" or boolean == "true") and sa_message == true then
            sendresponse("Server Admin Message is already enabled", command, executor)
        elseif (boolean == "0" or boolean == "false") and sa_message ~= false then
            sa_message = false
            sendresponse("Server Admin Message is now disabled", command, executor)
        elseif sa_message == nil then
            sa_message = false
            sendresponse("Server Admin Message is now disabled", command, executor)
        elseif (boolean == "0" or boolean == "false") and sa_message == false then
            sendresponse("Server Admin Message is already disabled", command, executor)
        else
            sendresponse("Error 009: Invalid Boolean: 0 for false, 1 for true", command, executor)
        end
    else
        sendresponse("Error 004: Invalid Syntax: " .. command .. " {boolean}", command, executor)
    end
end

function Command_Say(executor, arg, count)
    if count >= 2 then
        local message = ""
        for i = 2, #arg do
            message = message .. arg[i] .. " "
        end
        Say("** SERVER ** " .. message, 5)
        sendresponse("Server Message Sent:", arg[1], executor)
        sendresponse(message, arg[1], executor)
    else
        sendresponse("Error 004: Invalid Syntax: " .. arg[1] .. " [message]", arg[1], exectuor)
    end
end

function Command_ScrimMode(executor, command, boolean, count)
    if count == 1 then
        if Scrim_Mode then
            sendresponse("Scrim Mode is currently on", command, executor)
        else
            sendresponse("Scrim Mode is currently off", command, executor)
        end
    elseif count == 2 then
        if (boolean == "1" or boolean == "true") and Scrim_Mode ~= true then
            Scrim_Mode = true
            falldamage = true
            deathless = false
            for i = 0, 15 do
                if getplayer(i) and getplayerobjectid(i) then
                    local ip = getip(i)
                    local m_objectId = getplayerobjectid(i)
                    local m_object
                    if m_objectId then
                        m_object = getobject(m_objectId)
                    end
                    local id = resolveplayer(i)
                    local m_player = getplayer(i)
                    follow[id] = nil
                    resetweapons(i)
                    cleanupdrones(i)
                    dmgmultiplier[ip] = 1.0
                    if m_object then
                        writefloat(m_object + 0xE0, 1)
                        writefloat(m_object + 0xE4, 1)
                    end
                    writedword(m_player + 0x2C, 0)
                    Ghost_Table[ip] = nil
                    mode[ip] = nil
                    gods[ip] = nil
                    hidden[id] = nil
                    hidden[id] = nil
                    if Noweapons[ip] then Noweapons[ip] = nil end
                    if infammo then
                        kill(i)
                    end
                end
            end
            for i = 0, 15 do
                for j = 1, 16 do
                    if Control_Table[j] then
                        for k = 1, 16 do
                            if Control_Table[j][k] == i then
                                Control_Table[j][k] = nil
                                bool = true
                                break
                            end
                        end
                    end
                    if bool then
                        break
                    end
                end
            end
            infammo = false
            Control_Table = { }
            follow = { }
            hidden = { }
            gods = { }
            Ghost_Table = { }
            mode = { }
            Noweapons = { }
            nukes = { }
            objects = { }
            objspawnid = { }
            Suspend_Table = { }
            Vehicle_Drone_Table = { }
            sendresponse("Scrim Mode is now enabled", command, executor)
        elseif (boolean == "1" or boolean == "true") and Scrim_Mode == true then
            sendresponse("Scrim Mode is already enabled", command, executor)
        elseif (boolean == "0" or boolean == "false") and Scrim_Mode ~= false then
            Scrim_Mode = false
            sendresponse("Scrim Mode is now disabled", command, executor)
        elseif Scrim_Mode == nil then
            Scrim_Mode = false
            sendresponse("Scrim Mode is now disabled", command, executor)
        elseif (boolean == "0" or boolean == "false") and Scrim_Mode == false then
            sendresponse("Scrim Mode is already disabled", command, executor)
        else
            sendresponse("Error 009: Invalid Boolean: 0 for false, 1 for true", command, executor)
        end
    else
        sendresponse("Error 004: Invalid Syntax: " .. command .. " {boolean}", command, executor)
    end
end

function Command_ScriptLoad(executor, command, count)
    if count >= 1 then
        local arg = tokenizecmdstring(command)
        command = "sv_script_load"
        for i = 2, #arg do
            command = command .. " " .. arg[i]
        end
        if executor then
            svcmdplayer(command, executor)
        else
            response = svcmd(command)
            sendresponse(response, arg[1], executor)
        end
    end
end

function Command_ScriptUnload(executor, command, count)
    if count >= 1 then
        local arg = tokenizecmdstring(command)
        command = "sv_script_unload"
        for i = 2, #arg do
            if arg[i] ~= "commands" and arg[i] ~= "command" and arg[i] ~= "cmd" and arg[i] ~= "cmds" then
                command = command .. " " .. arg[i]
            end
        end
        if executor then
            svcmdplayer(command, executor)
        else
            response = svcmd(command)
            sendresponse(response, arg[1], executor)
        end
    end
end

function Command_Setammo(executor, command, player, type, ammo, count)
    if count == 4 and tonumber(ammo) then
        local players = getvalidplayers(player, executor)
        if players then
            for i = 1, #players do
                local m_objectId = getplayerobjectid(players[i])
                if m_objectId then
                    local m_object = getobject(m_objectId)
                    if m_object then
                        local m_weaponId = readdword(m_object + 0x118)
                        if m_weaponId then
                            local m_weapon = getobject(m_weaponId)
                            if m_weapon then
                                if type == "unloaded" or type == "1" then
                                    writedword(m_weapon + 0x2B6, tonumber(ammo))
                                    sendresponse(getname(players[i]) .. " had their unloaded ammo changed to " .. ammo, command, executor)
                                elseif type == "2" or type == "loaded" then
                                    writedword(m_weapon + 0x2B8, tonumber(ammo))
                                    updateammo(m_weaponId)
                                    sendresponse(getname(players[i]) .. " had their loaded ammo changed to " .. ammo, command, executor)
                                else
                                    sendresponse("Error 010: Invalid Type: 1 for unloaded, 2 for loaded ammo", command, executor)
                                end
                            else
                                sendresponse(getname(players[i]) .. " is not holding any weapons", command, executor)
                            end
                        else
                            sendresponse(getname(players[i]) .. " is not holding any weapons", command, executor)
                        end
                    else
                        sendresponse(getname(players[i]) .. " is dead", command, executor)
                    end
                else
                    sendresponse(getname(players[i]) .. " is dead", command, executor)
                end
            end
        else
            sendresponse("Error 005: Invalid Player", command, executor)
        end
    else
        sendresponse("Error 004: Invalid Syntax: " .. command .. " [player] [type] [ammo]", command, executor)
    end
end

function Command_Setassists(executor, command, player, assists, count)
    if count == 3 and tonumber(assists) then
        local players = getvalidplayers(player, executor)
        if players then
            for i = 1, #players do
                local m_player = getplayer(players[i])
                local Assists = tonumber(assists)
                if Assists > 0x7FFF then
                    writewordsigned(m_player + 0xA4, 0x7FFF)
                elseif Assists < -0x7FFF then
                    writewordsigned(m_player + 0xA4, -0x7FFF)
                else
                    writewordsigned(m_player + 0xA4, Assists)
                end
                sendresponse(getname(players[i]) .. " had their assists set to " .. assists, command, executor)
            end
        else
            sendresponse("Error 005: Invalid Player", command, executor)
        end
    else
        sendresponse("Error 004: Invalid Syntax: " .. command .. " [player] [assists]", command, executor)
    end
end

function Command_Setcolor(executor, command, player, color, count)
    if count == 2 then
        local players = getvalidplayers(player, executor)
        if players then
            for i = 1, #players do
                sendresponse(getname(players[i]) .. " is currently " .. getcolor(players[i]), command, executor)
            end
        else
            sendresponse("Error 005: Invalid Player", command, executor)
        end
    elseif count == 3 then
        local players = getvalidplayers(player, executor)
        if players then
            for i = 1, #players do
                local m_player = getplayer(players[i])
                local m_objectId = getplayerobjectid(players[i])
                if m_objectId then
                    local x, y, z = getobjectcoords(m_objectId)
                    if color == "white" then
                        writebyte(m_player + 0x60, 0)
                    elseif color == "black" then
                        writebyte(m_player + 0x60, 1)
                    elseif color == "red" then
                        writebyte(m_player + 0x60, 2)
                    elseif color == "blue" then
                        writebyte(m_player + 0x60, 3)
                    elseif color == "gray" then
                        writebyte(m_player + 0x60, 4)
                    elseif color == "yellow" then
                        writebyte(m_player + 0x60, 5)
                    elseif color == "green" then
                        writebyte(m_player + 0x60, 6)
                    elseif color == "pink" then
                        writebyte(m_player + 0x60, 7)
                    elseif color == "purple" then
                        writebyte(m_player + 0x60, 8)
                    elseif color == "cyan" then
                        writebyte(m_player + 0x60, 9)
                    elseif color == "cobalt" then
                        writebyte(m_player + 0x60, 10)
                    elseif color == "orange" then
                        writebyte(m_player + 0x60, 11)
                    elseif color == "teal" then
                        writebyte(m_player + 0x60, 12)
                    elseif color == "sage" then
                        writebyte(m_player + 0x60, 13)
                    elseif color == "brown" then
                        writebyte(m_player + 0x60, 14)
                    elseif color == "tan" then
                        writebyte(m_player + 0x60, 15)
                    elseif color == "maroon" then
                        writebyte(m_player + 0x60, 16)
                    elseif color == "salmon" then
                        writebyte(m_player + 0x60, 17)
                    else
                        sendresponse("Invalid Color", command, executor)
                        return
                    end
                    sendresponse(getname(players[i]) .. " had their color changed to " .. color .. "", command, executor)
                    if m_objectId ~= nil then
                        destroyobject(m_objectId)
                        if colorspawn == nil then colorspawn = { } end
                        if colorspawn[players[i]] == nil then colorspawn[players[i]] = { } end
                        colorspawn[players[i]][1] = x
                        colorspawn[players[i]][2] = y
                        colorspawn[players[i]][3] = z
                    end
                end
            end
        else
            sendresponse("Error 005: Invalid Player", command, executor)
        end
    else
        sendresponse("Error 004: Invalid Syntax: " .. command .. " [player] {color}", command, executor)
    end
end

function Command_Setdeaths(executor, command, player, deaths, count)
    if count == 3 and tonumber(deaths) then
        local players = getvalidplayers(player, executor)
        if players then
            for i = 1, #players do
                local m_player = getplayer(players[i])
                Deaths = tonumber(deaths)
                if Deaths > 0x7FFF then
                    writewordsigned(m_player + 0xAE, 0x7FFF)
                elseif Deaths < -0x7FFF then
                    writewordsigned(m_player + 0xAE, -0x7FFF)
                else
                    writewordsigned(m_player + 0xAE, Deaths)
                end
                sendresponse(getname(players[i]) .. " had their deaths set to " .. deaths, command, executor)
            end
        else
            sendresponse("Error 005: Invalid Player", command, executor)
        end
    else
        sendresponse("Error 004: Invalid Syntax: " .. command .. " [player] [deaths]", command, executor)
    end
end

function Command_Setfrags(executor, command, player, frags, count)
    if count == 3 and tonumber(frags) then
        local players = getvalidplayers(player, executor)
        if players then
            for i = 1, #players do
                local m_objectId = getplayerobjectid(players[i])
                if m_objectId then
                    local m_object = getobject(m_objectId)
                    if m_object then
                        if tonumber(frags) <= 255 then
                            writebyte(m_object + 0x31E, frags)
                            sendresponse("Setting " .. getname(players[i]) .. "'s frag grenades to " .. frags, command, executor)
                            sendresponse("Your frag grenades were set to " .. frags, command, players[i])
                        else
                            writebyte(m_object + 0x31E, 255)
                            sendresponse("Setting " .. getname(players[i]) .. "'s frag grenades to " .. frags, command, executor)
                            sendresponse("Your frag grenades were set to " .. frags, command, players[i])
                        end
                    else
                        sendresponse(getname(players[i]) .. " is dead", command, executor)
                    end
                else
                    sendresponse(getname(players[i]) .. " is dead", command, executor)
                end
            end
        else
            sendresponse("Error 005: Invalid Player", command, executor)
        end
    else
        sendresponse("Error 004: Invalid Syntax: " .. command .. " [player] [amount]", command, executor)
    end
end

function Command_Setkills(executor, command, player, kills, count)
    if count == 3 then
        local players = getvalidplayers(player, executor)
        if players then
            for i = 1, #players do
                local m_player = getplayer(players[i])
                kills = tonumber(kills)
                if kills > 0x7FFF then
                    writewordsigned(m_player + 0x9C, 0x7FFF)
                elseif kills < -0x7FFF then
                    writewordsigned(m_player + 0x9C, -0x7FFF)
                else
                    writewordsigned(m_player + 0x9C, kills)
                end
                sendresponse(getname(players[i]) .. " had their kills set to " .. kills, command, executor)
            end
        else
            sendresponse("Error 005: Invalid Player", command, executor)
        end
    else
        sendresponse("Error 004: Invalid Syntax: " .. command .. " [player] [kills]", command, executor)
    end
end

function Command_Setmode(executor, command, player, Mode, object, count)
    if player == nil then
        sendresponse("Error 004: Invalid Syntax: " .. command .. " [player] [mode] {object (for SpawnGun only)}", command, executor)
        return
    end
    local players = getvalidplayers(player, executor)
    if players then
        if count == 3 then
            for i = 1, #players do
                if Mode == "destroy" then
                    mode[getip(players[i])] = "destroy"
                    sendresponse(getname(players[i]) .. " is now in (destroy) mode", command, executor)
                elseif Mode == "portalgun" then
                    mode[getip(players[i])] = "portalgun"
                    sendresponse(getname(players[i]) .. " is now in (PortalGun) mode", command, executor)
                elseif Mode == "entergun" then
                    mode[getip(players[i])] = "entergun"
                    sendresponse(getname(players[i]) .. " is now in (EnterGun) mode", command, executor)
                elseif Mode == "normal" or Mode == "none" or Mode == "regular" then
                    objspawnid[getip(players[i])] = nil
                    mode[getip(players[i])] = nil
                    sendresponse(getname(players[i]) .. " is now in normal mode", command, executor)
                elseif Mode == "gravitygun" then
                    mode[gethash(players[i])] = "gravitygun"
                    sendresponse(getname(players[i]) .. " is now in (GravityGun) mode\n It is recommended to use a Single-Projectile Weapon, i.e (sniper,pistol,plasma - pistol/rifle ect)", command, executor)
                else
                    sendresponse("Invalid Mode!\n(1): Destroy\n(2): PortalGun\n(3) EnterGun\n(4): SpawnGun\n(5): GravityGun\n(6): Normal", command, executor)
                end
            end
        elseif count == 4 then
            for i = 1, #players do
                if Mode == "spawngun" then
                    local objexists = false
                    objspawnid[getip(players[i])] = nil
                    mode[getip(players[i])] = nil
                    for j = 1, #objects do
                        if object == objects[j][1] then
                            mode[getip(players[i])] = "spawngun"
                            objspawnid[getip(players[i])] = objects[j][3]
                            sendresponse(getname(players[i]) .. " is now spawning " .. objects[j][1] .. "", command, executor)
                            objexists = true
                            break
                        end
                    end
                    if objexists == false then
                        sendresponse("Object does not exist. Make sure you are spelling it right.", command, executor)
                    end
                end
            end
        else
            -- 		Invalid Syntax <command> [player] [mode] {object}
            -- 	Invalid Mode!
            -- 	(1) Destroy
            -- 	(2) PortalGun
            -- 	(3) EnterGun
            -- 	(4) SpawnGun
            -- 	(5) GravityGun
            -- 	(6) Normal

            sendresponse("Error 004: Invalid Syntax: " .. command .. " [player] [mode] {object}", command, executor)
            sendresponse("Invalid Mode!\n(1): Destroy\n(2): PortalGun\n(3) EnterGun\n(4): SpawnGun\n(5): GravityGun\n(6): Normal", command, executor)
        end
    else
        sendresponse("Error 005: Invalid Player", command, executor)
    end
end

function Command_Setpassword(executor, command, password, count)
    if count == 1 then
        local response = svcmd("sv_password", true)
        if response then
            sendresponse(response, command, executor)
        else
            sendresponse("Critical Error: " .. passwrd .. "'", command, executor)
        end
    elseif count == 2 then
        if password == "" then
            svcmd('sv_password ""')
            sendresponse("Password has been taken off", command, executor)
            passwrd = nil
        elseif passwrd then
            svcmd('sv_password ' .. password)
            sendresponse("The password is now " .. password, command, executor)
            passwrd = password
        else
            sendresponse("Internal Error Occurred. Check the Command Script Errors log", command, executor)
            cmderrors("Error Occurred at Command_Setpassword")
        end
    else
        sendresponse("Error 004: Invalid Syntax: " .. command .. " {password}", command, executor)
    end
end

function Command_Setplasmas(executor, command, player, plasmas, count)
    if count == 3 and tonumber(plasmas) then
        local players = getvalidplayers(player, executor)
        if players then
            for i = 1, #players do
                local m_objectId = getplayerobjectid(players[i])
                if m_objectId then
                    local m_object = getobject(m_objectId)
                    if m_object then
                        if tonumber(plasmas) <= 255 then
                            writebyte(m_object + 0x31F, tonumber(plasmas))
                            sendresponse("Setting " .. getname(players[i]) .. "'s plasma grenades to: " .. plasmas, command, executor)
                            sendresponse("Your plasma grenades were set to: " .. plasmas, command, players[i])
                        else
                            writebyte(m_object + 0x31F, 255)
                            sendresponse("Setting " .. getname(players[i]) .. "'s plasma grenades to " .. plasmas, command, executor)
                            sendresponse("Your plasma grenades were set to: " .. plasmas, command, players[i])
                        end
                    else
                        sendresponse(getname(players[i]) .. " is dead!", command, executor)
                    end
                else
                    sendresponse(getname(players[i]) .. " is dead!", command, executor)
                end
            end
        else
            sendresponse("Error 005: Invalid Player", command, executor)
        end
    else
        sendresponse("Error 004: Invalid Syntax: sv_setplasmas [player] [amount]", command, executor)
    end
end

function Command_Setresp(executor, command, time, count)
    if count == 2 then
        if time == "default" then
            respset = false
            sendresponse("Re-Spawn time set to the Game Type's default setting", command, executor)
        elseif tonumber(time) then
            resptime = time
            respset = true
            sendresponse("Re-Spawn time set to " .. time .. " seconds", command, executor)
        elseif respset == nil then
            sendresponse("Re-Spawn time not set. Defaulting to Game Type's default setting.", command, executor)
        else
            sendresponse("Error 004: Invalid Syntax: " .. command .. " [seconds]", command, executor)
        end
    else
        sendresponse("Error 004: Invalid Syntax: " .. command .. " [seconds]", command, executor)
    end
end

function Command_Setscore(executor, command, player, score, count)
    if count == 3 and tonumber(score) then
        local players = getvalidplayers(player, executor)
        if players then
            for i = 1, #players do
                setscore(players[i], tonumber(score))
                sendresponse(getname(players[i]) .. " had their score set to " .. score .. "", command, executor)
            end
        else
            sendresponse("Error 005: Invalid Player", command, executor)
        end
    else
        sendresponse("Error 004: Invalid Syntax: " .. command .. " [player] [score]", command, executor)
    end
end

function Command_Setspeed(executor, command, player, speed, count)
    if count == 2 then
        local players = getvalidplayers(player, executor)
        if players then
            for i = 1, #players do
                local m_player = getplayer(players[i])
                local cur_speed = readfloat(m_player + 0x6C)
                sendresponse(getname(players[i]) .. "'s speed is currently " .. cur_speed, command, executor)
            end
        else
            sendresponse("Error 005: Invalid Player", command, executor)
        end
    elseif count == 3 and tonumber(speed) then
        local players = getvalidplayers(player, executor)
        if players then
            for i = 1, #players do
                setspeed(players[i], tonumber(speed))
                sendresponse(getname(players[i]) .. " had their speed changed to " .. speed, command, executor)
            end
        else
            sendresponse("Error 005: Invalid Player", command, executor)
        end
    else
        sendresponse("Error 004: Invalid Syntax: " .. command .. " [player] {speed}", command, executor)
    end
end

function Command_Setteleport(executor, command, locname, player, count)
    if count == 2 then
        response = false
        sendresponse("Error 004: Invalid Syntax: " .. command .. " [locname] [player]", command, executor)
    elseif count == 3 then
        local players = getvalidplayers(player, executor)
        if players then
            for i = 1, #players do
                local m_objectId = getplayerobjectid(players[i])
                if m_objectId then
                    if getobject(m_objectId) then
                        svcmdplayer("sv_teleport_add " .. tostring(locname), players[i])
                        if string.find(response, "corresponds") then
                            sendresponse("Teleport location " .. locname .. " now corresponds to: " .. getname(players[i]) .. "'s location", command, executor)
                        else
                            say(tostring(response))
                            sendresponse(locname .. " is already added", command, executor)
                        end
                    else
                        sendresponse("Cannot add Teleport because the player is dead!", command, executor)
                    end
                else
                    sendresponse("Cannot add Teleport because the player is dead!", command, executor)
                end
            end
        else
            sendresponse("Error 005: Invalid Player", command, executor)
        end
    else
        sendresponse("Error 004: Invalid Syntax: " .. command .. " [locname] [player]", command, executor)
    end
end

function Command_TeleportList(executor, command, count)
    if count == 2 then
        local response = svcmd("sv_teleport_list", true)
        sendresponse(tostring(response), command, executor)
    end
end

function Command_Spawn(executor, command, object, player, amount, resptime, recycle, type, count)
    local bool = true
    if type == "enter" then
        if count == 2 then
            if executor ~= nil then
                player = resolveplayer(executor)
            else
                sendresponse("ATTENTION - You cannot spawn a Vehicle at the Server's location...", command, executor)
                return
            end
        elseif count == 3 then
            if string.lower(player) == "me" and executor ~= nil then
                player = resolveplayer(executor)
            end
        else
            sendresponse("Error 004: Invalid Syntax: " .. command .. " [vehicle] {player}", command, executor)
            return
        end
        message = command .. " " .. object .. " " .. player
    elseif type == "give" then
        if count == 2 then
            if executor ~= nil then
                player = resolveplayer(executor)
            else
                sendresponse("ATTENTION - You cannot spawn a Weapon at the Server's location...", command, executor)
                return
            end
        elseif count == 3 then
            if string.lower(player) == "me" and executor ~= nil then
                player = resolveplayer(executor)
            end
        else
            sendresponse("Error 004: Invalid Syntax: " .. command .. " [weapon] {player}", command, executor)
            return
        end
        message = command .. " " .. object .. " " .. player
    elseif type == "spawn" then
        if object then
            if count == 2 then
                if executor ~= nil then
                    message = command .. " " .. object .. " " .. resolveplayer(executor)
                else
                    sendresponse("ATTENTION - You cannot spawn an object at the Server's location...", command, executor)
                    return
                end
            elseif count == 3 then
                if string.lower(player) == "me" and executor ~= nil then
                    player = resolveplayer(executor)
                end
                message = command .. " " .. object .. " " .. player
            elseif count == 4 then
                message = command .. " " .. object .. " " .. player .. " " .. amount
            elseif count == 5 then
                message = command .. " " .. object .. " " .. player .. " " .. amount .. " " .. resptime
            elseif count == 6 then
                message = command .. " " .. object .. " " .. player .. " " .. amount .. " " .. resptime .. " " .. recycle
            else
                sendresponse("Error 004: Invalid Syntax: " .. command .. " [object] {player} {amount} {resptime} {recycle}", command, executor)
                return
            end
        else
            sendresponse("Missing Object", command, executor)
            return
        end
    else
        sendresponse(" - An unknown error has occured -", command, executor)
    end
    --------------------------------------------------------------------------------------------------------------------------------------------------------------------------	
    if type == "spawn" then
        bool = true
        if object == "cyborg" or object == "bot" or object == "mastercheif" or object == "biped" or object == "bipd" then
            Spawn(message, "Cyborg", "bipd", cyborg_tag_id, executor, type)

        elseif object == "cyb" then
            Spawn(message, "cyb", "bipd", cyb_tag_id, executor, type)

        elseif object == "carbine" then
            Spawn(message, "carbine", "weap", carbine_tag_id, executor, type)

        elseif object == "revsniper" then
            Spawn(message, "revsniper", "weap", revsniper_tag_id, executor, type)

        elseif object == "covspiker" then
            Spawn(message, "covspiker", "weap", covspiker_tag_id, executor, type)

        elseif object == "covpr" then
            Spawn(message, "covpr", "weap", covplasmarifle_tag_id, executor, type)

        elseif object == "covpp" then
            Spawn(message, "covpp", "weap", covpp_tag_id, executor, type)

        elseif object == "covbr" then
            Spawn(message, "covbr", "weap", covbr_tag_id, executor, type)

        elseif object == "covsmg" then
            Spawn(message, "covsmg", "weap", covsmg_tag_id, executor, type)

        elseif object == "yohog" then
            Spawn(message, "yohog", "weap", yohog_tag_id, executor, type)

        elseif object == "fhog" then
            Spawn(message, "fhog", "weap", fhog_tag_id, executor, type)

        elseif object == "captain" or object == "keyes" then
            Spawn(message, "Captain Keyes", "bipd", captain_tag_id, executor, type)

        elseif object == "cortana" then
            Spawn(message, "Cortana", "bipd", cortana_tag_id, executor, type)

        elseif object == "cortana2" then
            Spawn(message, "Cortana2", "bipd", cortana2_tag_id, executor, type)

        elseif object == "crewman" then
            Spawn(message, "Crewman", "bipd", crewman_tag_id, executor, type)

        elseif object == "elite" then
            Spawn(message, "elite", "bipd", elite_tag_id, executor, type)

        elseif object == "elite2" then
            Spawn(message, "Elite Special", "bipd", elite2_tag_id, executor, type)

        elseif object == "engineer" then
            Spawn(message, "Engineer", "bipd", engineer_tag_id, executor, type)

        elseif object == "flood" then
            Spawn(message, "Flood Captain", "bipd", flood_tag_id, executor, type)

        elseif object == "flood2" then
            Spawn(message, "Flood Infection", "bipd", flood2_tag_id, executor, type)

        elseif object == "flood3" then
            Spawn(message, "Flood Carrier", "bipd", "characters\\floodcarrier\\floodcarrier", executor, type)

        elseif object == "floodelite" then
            Spawn(message, "FloodCombat Elite", "bipd", "characters\\floodcombat elite\\floodcombat elite", executor, type)

        elseif object == "floodhuman" then
            Spawn(message, "FloodCombat Human", "bipd", "characters\\floodcombat_human\\floodcombat_human", executor, type)

        elseif object == "pedobear" or object == "grunt" then
            Spawn(message, "Pedobear", "bipd", "characters\\grunt\\grunt", executor, type)

        elseif object == "hunter" then
            Spawn(message, "Hunter", "bipd", "characters\\hunter\\hunter", executor, type)

        elseif object == "marine" then
            Spawn(message, "Marine", "bipd", "characters\\marine\\marine", executor, type)

        elseif object == "marinesuicide" or object == "marine2" then
            Spawn(message, "Marine Suicidal", "bipd", "characters\\marine_suicidal\\marine_suicidal", executor, type)

        elseif object == "monitor" then
            Spawn(message, "Monitor", "bipd", "characters\\monitor\\monitor", executor, type)

        elseif object == "sentinel" then
            Spawn(message, "Sentinel", "bipd", "characters\\sentinel\\sentinel", executor, type)

        elseif object == "johnson" then
            Spawn(message, "Sgt. Johnson", "bipd", "characters\\johnson\\johnson", executor, type)

        elseif object == "camo" or object == "camouflage" then
            Spawn(message, "Camouflage", "eqip", camouflage_tag_id, executor, type)

        elseif object == "dblspd" then
            Spawn(message, "Double Speed", "eqip", doublespeed_tag_id, executor, type)

        elseif object == "fullspec" then
            Spawn(message, "Full-Spectrum Vision", "eqip", fullspec_tag_id, executor, type)

        elseif object == "fnade" or object == "nades" then
            Spawn(message, "Frag Grenade", "eqip", fragnade_tag_id, executor, type)

        elseif object == "pnade" then
            Spawn(message, "Plasma Grenade", "eqip", plasmanade_tag_id, executor, type)

        elseif object == "overshield" or object == "os" then
            Spawn(message, "OverShield", "eqip", overshield_tag_id, executor, type)

        elseif object == "rifleammo" then
            Spawn(message, "Assault Rifle Ammo", "eqip", rifleammo_tag_id, executor, type)

        elseif object == "healthpack" then
            Spawn(message, "Health Pack", "eqip", healthpack_tag_id, executor, type)

        elseif object == "needlerammo" then
            Spawn(message, "Needler Ammo", "eqip", needlerammo_tag_id, executor, type)

        elseif object == "pistolammo" then
            Spawn(message, "Pistol Ammo", "eqip", pistolammo_tag_id, executor, type)

        elseif object == "rocketammo" then
            Spawn(message, "Rocket Launcher Ammo", "eqip", rocketammo_tag_id, executor, type)

        elseif object == "shottyammo" then
            Spawn(message, "Shotgun Ammo", "eqip", shotgunammo_tag_id, executor, type)

        elseif object == "sniperammo" then
            Spawn(message, "Sniper Rifle Ammo", "eqip", sniperammo_tag_id, executor, type)

        elseif object == "flameammo" then
            Spawn(message, "Flamethrower Ammo", "eqip", flameammo_tag_id, executor, type)
        else
            bool = false
        end
        if bool then
            return
        end
    end
    --------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    if type ~= "enter" then
        bool = true
        if object == "energysword" or object == "esword" then
            Spawn(message, "Energy Sword", "weap", energysword_tag_id, executor, type)

        elseif object == "ball" or object == "oddball" then
            Spawn(message, "Oddball", "weap", oddball_tag_id, executor, type)

        elseif object == "flag" then
            Spawn(message, "Flag", "weap", flag_tag_id, executor, type)
            flag_id = gettagid("weap", "weapons\\flag\\flag")

        elseif object == "frg" or object == "fuelrod" or object == "rod" or object == "plasmacannon" then
            Spawn(message, "Fuel Rod", "weap", plasmacannon_tag_id, executor, type)

        elseif object == "ggun" or object == "gravitygun" then
            Spawn(message, "Gravity Gun", "weap", gravityrifle_tag_id, executor, type)

        elseif object == "needler" then
            Spawn(message, "Needler", "weap", needler_tag_id, executor, type)

        elseif object == "pistol" then
            Spawn(message, "Pistol", "weap", pistol_tag_id, executor, type)

        elseif object == "ppistol" or object == "plasmapistol" then
            Spawn(message, "Plasma Pistol", "weap", plasmapistol_tag_id, executor, type)

        elseif object == "prifle" or object == "plasmarifle" then
            Spawn(message, "Plasma Rifle", "weap", plasmarifle_tag_id, executor, type)

        elseif object == "rifle" or object == "arifle" or object == "assaultrifle" then
            Spawn(message, "Assault Rifle", "weap", assaultrifle_tag_id, executor, type)

        elseif object == "rocket" or object == "rocketlauncher" or object == "rox" then
            Spawn(message, "Rocket Launcher", "weap", rocketlauncher_tag_id, executor, type)

        elseif object == "shotty" or object == "shotgun" then
            Spawn(message, "Shotgun", "weap", shotgun_tag_id, executor, type)

        elseif object == "sniper" then
            Spawn(message, "Sniper Rifle", "weap", sniper_tag_id, executor, type)

        elseif object == "flamethrower" or object == "flame" then
            Spawn(message, "Flame Thrower", "weap", flamethrower_tag_id, executor, type)

        elseif object == "spiker" then
            Spawn(message, "Covenant Spiker", "weap", covspiker_tag_id, executor, type)

        elseif object == "covpr" then
            Spawn(message, "Covenant Plasma Rifle", "weap", covplasmarifle_tag_id, executor, type)

        elseif object == "covpp" then
            Spawn(message, "Covenant Plasma Pistol", "weap", covpp_tag_id, executor, type)

        elseif object == "covbr" then
            Spawn(message, "Covenant Brute Rifle", "weap", covbr_tag_id, executor, type)

        elseif object == "covsmg" then
            Spawn(message, "Covenant SMG", "weap", covsmg_tag_id, executor, type)

        elseif object == "yohog" then
            Spawn(message, "YoHog", "weap", yohog_tag_id, executor, type)

        elseif object == "fhog" then
            Spawn(message, "FHog", "weap", fhog_tag_id, executor, type)

        elseif object == "healthpack" or object == "hpack" then
            Spawn(message, "Health Pack", "eqip", healthpack_tag_id, executor, type)

        elseif object == "rifleammo" then
            Spawn(message, "Assault Rifle Ammo", "eqip", rifleammo_tag_id, executor, type)

        elseif object == "needlerammo" then
            Spawn(message, "Needler Ammo", "eqip", needlerammo_tag_id, executor, type)

        elseif object == "pistolammo" then
            Spawn(message, "Pistol Ammo", "eqip", pistolammo_tag_id, executor, type)

        elseif object == "rocketammo" then
            Spawn(message, "Rocket Launcher Ammo", "eqip", rocketammo_tag_id, executor, type)

        elseif object == "shotgunammo" then
            Spawn(message, "Shotgun Ammo", "eqip", shotgunammo_tag_id, executor, type)

        elseif object == "sniperammo" then
            Spawn(message, "Sniper Rifle Ammo", "eqip", sniperammo_tag_id, executor, type)

        elseif object == "Flamethrowerammo" then
            Spawn(message, "Flamethrower Ammo", "eqip", flameammo_tag_id, executor, type)
        else
            bool = false
        end
        if bool then
            return
        end
    end
    --------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    if type ~= "give" then
        bool = true
        if object == "wraith" then
            Spawn(message, "Wraith", "vehi", wraith_tag_id, executor, type)
        elseif object == "peli" or object == "pelican" then
            Spawn(message, "Pelican", "vehi", pelican_tag_id, executor, type)
        elseif object == "ghost" then
            Spawn(message, "Ghost", "vehi", ghost_tag_id, executor, type)
        elseif object == "hog" or object == "warthog" then
            Spawn(message, "Warthog", "vehi", warthog_tag_id, executor, type)
        elseif object == "rhog" or object == "rocketwarthog" then
            Spawn(message, "Rocket Warthog", "vehi", rwarthog_tag_id, executor, type)
        elseif object == "shee" or object == "banshee" then
            Spawn(message, "Banshee", "vehi", banshee_tag_id, executor, type)
        elseif object == "tank" or object == "scorpion" then
            Spawn(message, "Tank", "vehi", scorpion_tag_id, executor, type)
        elseif object == "turret" or object == "shade" then
            Spawn(message, "Gun Turret", "vehi", turret_tag_id, executor, type)
        else
            bool = false
        end
        if bool then
            return
        end
    end
    if bool == false then
        if type == "give" then
            sendresponse("Error 001: Invalid Weapon! (Type: 'Give')", command, executor)
        elseif type == "enter" then
            sendresponse("Error 002: Invalid Vehicle! (Type: 'Enter')", command, executor)
        elseif type == "spawn" then
            sendresponse("Error 003: Invalid Object! (Type: 'Spawn')", command, executor)
        end
    end
end
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function Command_SpamMax(executor, command, value, count)
    if count == 1 then
        SPAM_MAX = tonumber(SPAM_MAX) or 7
        sendresponse("Spam max is " .. SPAM_MAX, command, executor)
    elseif count == 2 and tonumber(value) then
        if value == 0 and AntiSpam ~= false then
            AntiSpam = false
            sendresponse("AntiSpam is now disabled", command, executor)
        elseif value == 0 and AntiSpam == false then
            sendresponse("AntiSpam is already disabled", command, executor)
        else
            SPAM_MAX = tonumber(value)
            sendresponse("The Spam Max is now: " .. value, command, executor)
        end
    else
        sendresponse("Error 004: Invalid Syntax:  " .. command .. " [value]", command, executor)
    end
end

function Command_SpamTimeOut(executor, command, time, count)
    if count == 1 then
        SPAM_TIMEOUT = tonumber(SPAM_TIMEOUT) or 60
        sendresponse("Spam timeout is " .. round(SPAM_TIMEOUT / 60, 1) .. " minute(s)", command, executor)
    elseif count == 2 and tonumber(time) then
        time = tonumber(time)
        if time == 0 and AntiSpam ~= false then
            AntiSpam = false
            sendresponse("AntiSpam is now disabled", command, executor)
        elseif time == 0 and AntiSpam == false then
            sendresponse("AntiSpam is already disabled", command, executor)
        else
            SPAM_TIMEOUT = tonumber(time * 60)
            sendresponse("The Spam timeout is now " .. tostring(time) .. " minute(s)", command, executor)
        end
    else
        sendresponse("Error 004: Invalid Syntax:  " .. command .. " [time]", command, executor)
    end
end

function Command_Specs(executor, command, count)
    if count == 1 then
        local specs = readtagname(specs_addr)
        sendresponse("The server specs are: " .. tostring(specs), command, executor)
    else
        sendresponse("Error 004: Invalid Syntax: " .. command, command, executor)
    end
end

function Command_StartMapcycle(executor, command, count)
    if count == 1 then
        local response = svcmd("sv_mapcycle_begin", true)
        sendresponse(response[1], command, executor)
        svcmd("sv_mapcycle_begin")
    else
        sendresponse("Error 004: Invalid Syntax: " .. command, command, executor)
    end
end

function Command_Status(executor, command, count)
    if count == 1 then
        local response = "Admin Blocker: " .. tostring(admin_blocker) .. "  |  Anti Caps: " .. tostring(anticaps) .. "  |  Anti Spam: " .. tostring(AntiSpam) .. "\n"
        response = response .. "" .. "Chat Commands: " .. tostring(chatcommands) .. "  |  Deathless: " .. tostring(deathless) .. "  |  Falldamage: " .. tostring(falldamage) .. "\n"
        response = response .. "" .. "First Join Message: " .. tostring(firstjoin_message) .. "  |  Hash Check: " .. tostring(hash_check) .. "  |  Infinite Ammo: " .. tostring(infammo) .. "\n"
        response = response .. "" .. "Killspree: " .. tostring(killing_spree) .. "  |  Noweapons: " .. tostring(noweapons) .. "\n"
        response = response .. "" .. "Pvtmessage: " .. tostring(pm_enabled) .. "  |  Respawn_time: " .. tostring(respset) .. "  |  Rtv_enabled: " .. tostring(rockthevote) .. "\n"
        response = response .. "" .. "Rtv_needed: " .. tostring(rtv_required) .. "  |  Serveradmin_message: " .. tostring(sa_message) .. "  |  Spam Max: " .. tostring(SPAM_MAX) .. "\n"
        response = response .. "" .. "Spamtimeout: " .. tostring(SPAM_TIMEOUT) .. "seconds  |  Tbagdet: " .. tostring(tbag_detection) .. "  |  Uniques Enabled: " .. tostring(uniques_enabled) .. "\n"
        response = response .. "" .. "Version Check: " .. tostring(version_check) .. "  |  Version: " .. tostring(Version) .. "  |  Votekick Enabled: " .. tostring(votekick_allowed) .. "\n"
        response = response .. "" .. "Votekick Needed: " .. tostring(votekick_required) .. "  |  Votekick Action: " .. tostring(votekick_action) .. "  |  Welcomeback Message: " .. tostring(wb_message)
        sendresponse(response, command, executor)
    else
        sendresponse("Error 004: Invalid Syntax: " .. command, command, executor)
    end
end

function Command_Superban(executor, command, player, message, count)
    if count == 2 or count == 3 then
        local players = getvalidplayers(player, executor, command)
        if players then
            local name = "the Server"
            if executor ~= nil then name = getname(executor) end
            for i = 1, #players do
                message = tostring(message) or "None Given"
                BanReason(getname(players[i]) .. " was banned by " .. name .. " Reason: " .. message .. " Type: Super Ban")
                say(getname(players[i]) .. " was Super banned by " .. name .. " Reason: " .. message)
                table.insert(Name_Bans, getname(players[i]))
                local ip = getip(players[i])
                IP_BanList[ip] = { }
                table.insert(IP_BanList[ip], { ["name"] = getname(players[i]), ["ip"] = ip, ["time"] = - 1, ["id"] = IP_BanID })
                IP_BanID = IP_BanID + 1
                local words = tokenizestring(ip, ".")
                local ip2 = words[1] .. "." .. words[2]
                IpRange_BanList[ip2] = { }
                table.insert(IpRange_BanList[ip2], { ["name"] = getname(players[i]), ["ip"] = ip2, ["time"] = ipbantime, ["id"] = IpRange_BanID })
                IpRange_BanID = IpRange_BanID + 1
                svcmd("sv_ban " .. resolveplayer(players[i]))
            end
        else
            sendresponse("Error 005: Invalid Player", command, executor)
        end
    else
        sendresponse("Error 004: Invalid Syntax: " .. command .. " [player] {reason}", command, executor)
    end
end

function Command_Suspend(executor, command, player, time, count)
    local players = getvalidplayers(player, executor)
    if players then
        for i = 1, #players do
            if Suspend_Table[getip(players[i])] == nil then
                local m_player = getplayer(players[i])
                local player_respawn_time = readdword(m_player + 0x2c)
                if count == 2 then
                    kill(players[i])
                    writedword(m_player + 0x2C, 2592000)
                    Suspend_Table[getip(players[i])] = 2
                    sendresponse(getname(players[i]) .. " has been suspended by an Admin.", command, executor)
                elseif count == 3 then
                    kill(players[i])
                    writedword(m_player + 0x2C, time * 30)
                    Suspend_Table[getip(players[i])] = 1
                    if tonumber(time) == 1 then
                        sendresponse(getname(players[i]) .. " was suspended by an admin for " .. time .. " second", command, executor)
                    else
                        sendresponse(getname(players[i]) .. " was suspended by an admin for " .. time .. " seconds", command, executor)
                    end
                else
                    sendresponse("Error 004: Invalid Syntax: sv_suspend [player] {time}", command, executor)
                end
            else
                sendresponse(getname(players[i]) .. " has already been suspended.", command, executor)
            end
        end
    else
        sendresponse("Error 005: Invalid Player", command, executor)
    end
end

function Command_Takeweapons(executor, command, player, count)
    if count == 2 then
        local players = getvalidplayers(player, executor)
        if players then
            for i = 1, #players do
                local ip = getip(players[i])
                if Noweapons[ip] == nil then
                    Noweapons[ip] = 1
                    local m_objectId = getplayerobjectid(players[i])
                    if m_objectId then
                        local m_object = getobject(m_objectId)
                        if m_object then
                            for j = 0, 3 do
                                local m_weaponId = readdword(m_object + 0x2F8 + j * 4)
                                local m_weapon = getobject(m_weaponId)
                                if m_weapon then
                                    destroyobject(m_weaponId)
                                end
                            end
                        end
                    end
                    sendresponse(getname(players[i]) .. " now has no weapons", command, executor)
                else
                    sendresponse(getname(players[i]) .. " already has no weapons", command, executor)
                end
            end
        else
            sendresponse("Error 005: Invalid Player", command, executor)
        end
    else
        sendresponse("Error 004: Invalid Syntax: " .. command .. " [player]", command, executor)
    end
end

function Command_TbagDetection(executor, command, boolean, count)
    if count == 1 then
        if tbag_detection then
            sendresponse("Tbag Detection is currently on", command, executor)
        else
            sendresponse("Tbag Detection is currently off", command, executor)
        end
    elseif count == 2 then
        if (boolean == "1" or boolean == "true") and tbag_detection ~= true then
            tbag_detection = true
            sendresponse("Tbag Detection is now enabled", command, executor)
        elseif (boolean == "1" or boolean == "true") and tbag_detection == true then
            sendresponse("Tbag Detection is already enabled", command, executor)
        elseif (boolean ~= "0" and boolean ~= "false") then
            sendresponse("Error 009: Invalid Boolean: 0 for false, 1 for true", command, executor)
        elseif (boolean == "0" or boolean == "false") and tbag_detection ~= false then
            tbag_detection = false
            sendresponse("Tbag Detection is now disabled", command, executor)
        elseif tbag_detection == nil then
            tbag_detection = true
            sendresponse("Tbag Detection is now enabled", command, executor)
        elseif (boolean == "0" or boolean == "false") and tbag_detection == false then
            sendresponse("Tbag Detection is already disabled", command, executor)
        else
            sendresponse("Error 009: Invalid Boolean: 0 for false, 1 for true", command, executor)
        end
    else
        sendresponse("Error 004: Invalid Syntax: " .. command .. " {boolean}", command, executor)
    end
end

function Command_TeleportDelete(executor, command, location, count)
    if count == 3 then
        tostring(location)
        local response = svcmd("sv_teleport_del " .. location, true)
        sendresponse(tostring(response[1]), command, executor)
    else
        sendresponse("Error 004: Invalid Syntax: " .. command .. " [ID]", command, executor)
    end
end

function Command_Teleport(executor, command, player, location, y, z, count)
    if count == 3 then
        local players = getvalidplayers(player, executor)
        if players then
            for i = 1, #players do
                local response = svcmd("sv_teleport " .. resolveplayer(players[i]) .. " " .. location, true)
                if string.find(response[1], "valid") then
                    sendresponse("Location '" .. tostring(location) .. "' does not exist for this map", command, executor)
                else
                    sendresponse("Teleporting " .. getname(players[i]) .. " to location '" .. location .. "'", command, executor)
                end
            end
        else
            sendresponse("Error 005: Invalid Player", command, executor)
        end
    elseif count == 5 then
        location = tonumber(t[3])
        y = tonumber(t[4])
        z = tonumber(t[5])
        local players = getvalidplayers(player, executor)
        if players then
            for i = 1, #players do
                local response = svcmd("sv_teleport " .. resolveplayer(players[i]) .. " " .. location .. " " .. y .. " " .. z, true)
                if string.find(response[1], "valid") then
                    sendresponse("Location '" .. tostring(location) .. "' does not exist for this map", command, executor)
                else
                    sendresponse("Teleporting " .. getname(players[i]) .. " to location '" .. location .. "'", command, executor)
                end
            end
        else
            sendresponse("Error 005: Invalid Player", command, executor)
        end
    else
        sendresponse("Error 004: Invalid Syntax: " .. command .. " [player] [location] or [x] [y] [z]", command, executor)
    end
end

function Command_Test(executor, command, arg1, arg2, arg3, arg4, count)
    if count == 1 then

    elseif count == 2 then

    elseif count == 3 then

    elseif count == 4 then

    elseif count == 5 then

    else

    end
end

function Command_Textban(executor, command, player, time, message, count)
    if count >= 2 and count <= 4 then
        local textbantime = wordtotime(time)
        local players = getvalidplayers(player, executor)
        if players then
            local name = "the Server"
            if executor ~= nil then name = getname(executor) end
            for i = 1, #players do
                local name = getname(players[i])
                local ip = getip(players[i])
                local hash = gethash(players[i])
                if Admin_Table[hash] or IpAdmins[ip] then
                    sendresponse("Admins cannot be banned from the chat.", command, executor)
                else
                    local bool = true
                    for k, v in pairs(Mute_Banlist) do
                        for key, value in pairs(Mute_Banlist[k]) do
                            if Mute_Banlist[k][key].ip == ip or Mute_Banlist[k][key].hash == hash then
                                bool = false
                                sendresponse(name .. " is already textbanned", command, executor)
                                break
                            end
                        end
                        if not bool then
                            break
                        end
                    end
                    if bool then
                        message = tostring(message) or "None Given"
                        BanReason(getname(players[i]) .. " was text banned by " .. name .. " Reason: " .. message)
                        say(getname(players[i]) .. " was text banned by " .. name .. " Reason: " .. message)
                        Mute_Banlist[ip] = { }
                        table.insert(Mute_Banlist[ip], { ["name"] = name, ["hash"] = hash, ["ip"] = ip, ["time"] = textbantime, ["id"] = TextBanID })
                        TextBanID = TextBanID + 1
                        local msg = ""
                        if textbantime == -1 then
                            msg = name .. " has been banned from the chat indefinitely"
                        else
                            msg = name .. " has been banned from the chat for " .. time .. ""
                        end
                        sendresponse(msg, command, executor)
                        hprintf(msg)
                    end
                end
            end
        else
            sendresponse("Error 005: Invalid Player", command, executor)
        end
    else
        sendresponse("Error 004: Invalid Syntax: " .. command .. " [player] {time} {reason}", command, executor)
    end
end

function Command_Textbanlist(executor, command, count)
    if count == 1 then
        local response = "[ ID   |   Name   |   Time Left ]\n"
        local response_table = { }
        for k, v in pairs(Mute_Banlist) do
            for key, value in ipairs(Mute_Banlist[k]) do
                local time = timetoword(Mute_Banlist[k][key].time)
                response_table[tonumber(Mute_Banlist[k][key].id)] = Mute_Banlist[k][key].name .. "  |  " .. time .. "\n"
            end
        end
        for i = 0, TextBanID do
            if response_table[i] then
                response = response .. "" .. i .. "  |  " .. response_table[i]
            end
        end
        sendresponse(response, command, executor)
    else
        sendresponse("Error 004: Invalid Syntax: " .. command, command, executor)
    end
end

function Command_Textunban(executor, command, ID, count)
    if count == 2 and tonumber(ID) then
        ID = tonumber(ID)
        local response = "Invalid ID"
        if ID <= TextBanID then
            local bool = false
            for k, v in pairs(Mute_Banlist) do
                if Mute_Banlist[k] ~= { } then
                    for key, value in ipairs(Mute_Banlist[k]) do
                        if Mute_Banlist[k][key].id == ID then
                            bool = true
                            response = Mute_Banlist[k][key].name .. " has been untextbanned"
                            table.remove(Mute_Banlist[k], key)
                            break
                        end
                    end
                end
                if bool then
                    break
                end
            end
            sendresponse(response, command, executor)
        else
            sendresponse(response, command, executor)
        end
    else
        sendresponse("Error 004: Invalid Syntax: " .. command .. " [ID]", command, executor)
    end
end

function Command_Teletoplayer(executor, command, player, player2, count)
    if count == 3 then
        local players = getvalidplayers(player, executor)
        if players then
            for i = 1, #players do
                local name = getname(players[i])
                local m_playerObjId = getplayerobjectid(players[i])
                if m_playerObjId then
                    local m_object = getobject(m_playerObjId)
                    if m_object then
                        local m_vehicleId = readdword(m_object + 0x11C)
                        local m_vehicle = getobject(m_vehicleId)
                        local players2 = getvalidplayers(player2, executor)
                        if players2 then
                            local m_objectId = getplayerobjectid(players2[1])
                            if m_objectId then
                                if players2[2] == nil and players[i] ~= players2[1] then
                                    local t_name = getname(players2[1])
                                    local player_x_coord, player_y_coord, player_z_coord = getobjectcoords(m_objectId)
                                    if m_vehicle then
                                        writefloat(m_vehicle + 0x5C, player_x_coord)
                                        writefloat(m_vehicle + 0x60, player_y_coord)
                                        writefloat(m_vehicle + 0x64, player_z_coord + 1.5)
                                        sendresponse(name .. " was teleported to " .. t_name, command, executor)
                                    elseif tonumber(player_z_coord) then
                                        movobjectcoords(m_playerObjId, player_x_coord, player_y_coord, player_z_coord + 1)
                                        sendresponse(name .. " was teleported to " .. t_name, command, executor)
                                    end
                                elseif players2[2] then
                                    sendresponse("You cannot teleport to multiple people.", command, executor)
                                end
                            else
                                sendresponse("The player you are trying to teleport to is dead", command, executor)
                            end
                        else
                            sendresponse("Error 005: Invalid Player", command, executor)
                        end
                    else
                        sendresponse("The player(s) you are trying to teleport are dead", command, executor)
                    end
                else
                    sendresponse("The player(s) you are trying to teleport are dead", command, executor)
                end
            end
        else
            sendresponse("Error 005: Invalid Player", command, executor)
        end
    else
        sendresponse("Error 004: Invalid Syntax: " .. command .. " [player] [player]", command, executor)
    end
end

function Command_Timelimit(executor, command, time, count)
    if count == 1 then
        local time_passed = readdword(readdword(gametime_base) + 0xC) / 1800
        local timelimit = readdword(gametype_base + 0x78) / 1800
        local time_left = timelimit - time_passed
        local Timelimit = readdword(timelimit_address)
        sendresponse("Current Timelimit is " .. round(timelimit) .. " minutes. Time remaining: " .. tostring(round(time_left, 0)) .. " minutes.", command, executor)
    elseif count == 2 and tonumber(time) then
        settimelimit(time)
        sendresponse("Timelimit set to " .. time .. " minutes", command, executor)
    else
        sendresponse("Error 004: Invalid Syntax: " .. command .. " {time}", command, executor)
    end
end

function Command_Unban(executor, command, id, count)
    if count == 2 and tonumber(id) then
        local response = svcmd("sv_unban " .. tonumber(id), true)
        if response then
            if string.find(response[1], "Unbanning") then
                sendresponse(response[1], command, executor)
            else
                sendresponse("That ID has not been banned.", command, executor)
            end
        else
            sendresponse("An unknown error has occured getting the reply from svcmd.", command, executor)
        end
    else
        sendresponse("Error 004: Invalid Syntax: " .. command .. " [Banlist ID]", command, executor)
    end
end

function Command_Unbos(executor, command, ID, count)
    if count == 2 then
        local entry = BosLog_Table[tonumber(ID)]
        local words = { }
        if entry == nil then
            sendresponse("Invalid Entry", command, executor)
        else
            local words = tokenizestring(entry, ",")
            local count = #words
            sendresponse("Removing " .. words[1] .. " - " .. words[2] .. " from BoS.", command, executor)
            table.remove(BosLog_Table, tonumber(ID))
        end
    else
        sendresponse("Error 004: Invalid Syntax: " .. command .. " [entry]", command, executor)
    end
end

function Command_Ungod(executor, command, player, count)
    if count == 1 and executor ~= nil then
        local m_playerObjId = getplayerobjectid(executor)
        if m_playerObjId then
            local m_object = getobject(m_playerObjId)
            if m_object then
                local ip = getip(executor)
                if gods[ip] then
                    writefloat(m_object + 0xE0, 1)
                    writefloat(m_object + 0xE4, 1)
                    sendresponse("You are no longer in godmode.", command, executor, command, executor)
                    gods[ip] = nil
                else
                    sendresponse("You are not in godmode", command, executor)
                end
            else
                sendresponse("You are dead", command, executor)
            end
        else
            sendresponse("You are dead", command, executor)
        end
    elseif count == 1 and executor == nil then
        sendresponse("The server is always god", command, executor)
    elseif count == 2 then
        local players = getvalidplayers(player, executor)
        if players then
            for i = 1, #players do
                local m_playerObjId = getplayerobjectid(players[i])
                if m_playerObjId then
                    local m_object = getobject(m_playerObjId)
                    if m_object then
                        local ip = getip(players[i])
                        if gods[ip] then
                            writefloat(m_object + 0xE0, 1)
                            writefloat(m_object + 0xE4, 1)
                            gods[ip] = nil
                            sendresponse(getname(players[i]) .. " is no longer in godmode", command, executor)
                        else
                            sendresponse(getname(players[i]) .. " is not in godmode", command, executor)
                        end
                    else
                        sendresponse("The selected player is dead", command, executor)
                    end
                else
                    sendresponse("The selected player is dead", command, executor)
                end
            end
        else
            sendresponse("Error 005: Invalid Player", command, executor)
        end
    else
        sendresponse("Error 004: Invalid Syntax: " .. command .. " [player]", command, executor)
    end
end

function Command_Unhax(executor, command, player, count)
    if count == 2 then
        local players = getvalidplayers(player, executor)
        if players then
            for i = 1, #players do
                local m_player = getplayer(players[i])
                setscore(players[i], 0)
                writeword(m_player + 0x9C, 0)
                writeword(m_player + 0xA4, 0)
                writeword(m_player + 0xAC, 0)
                writeword(m_player + 0xAE, 0)
                writeword(m_player + 0xB0, 0)
                sendresponse(getname(players[i]) .. " has been unhaxed", command, executor)
            end
        else
            sendresponse("Error 005: Invalid Player", command, executor)
        end
    else
        sendresponse("Error 004: Invalid Syntax: " .. command .. " [player]", command, executor)
    end
end

function Command_Unhide(executor, command, player, count)
    if count == 1 and executor ~= nil then
        local id = resolveplayer(executor)
        if id ~= nil then
            if hidden[id] then
                sendresponse("You are no longer hidden", command, executor)
                hidden[id] = nil
            else
                sendresponse("You are not hidden", command, executor)
            end
        else
            sendresponse("The server cannot unhide itself", command, executor)
        end
    elseif count == 1 and executor == nil then
        sendresponse("The server is always hidden", command, executor)
    elseif count == 2 then
        local players = getvalidplayers(player, executor)
        if players then
            for i = 1, #players do
                local id = resolveplayer(players[i])
                if hidden[id] then
                    sendresponse(getname(players[i]) .. " is no longer hidden", command, executor)
                    hidden[id] = nil
                else
                    sendresponse(getname(players[i]) .. " was never hidden", command, executor)
                end
            end
        else
            sendresponse("Error 005: Invalid Player", command, executor)
        end
    else
        sendresponse("Error 004: Invalid Syntax: " .. command .. " {player}", command, executor)
    end
end

function Command_Uninvis(executor, command, player, count)
    if count == 1 and executor ~= nil then
        local ip = getip(executor)
        if Ghost_Table[ip] == nil then
            sendresponse("You are not invisible", command, executor)
        else
            Ghost_Table[ip] = nil
            sendresponse("You are no longer invisible", command, executor)
        end
    elseif count == 1 and executor == nil then
        sendresponse("The server is always invisible", command, executor)
    elseif count == 2 and tonumber(command) == nil then
        local players = getvalidplayers(player, executor)
        if players then
            for i = 1, #players do
                local ip = getip(players[i])
                if Ghost_Table[ip] == nil then
                    sendresponse(getname(players[i]) .. " is not invisible", command, executor)
                else
                    Ghost_Table[ip] = nil
                    sendresponse(getname(players[i]) .. " is no longer invisible", command, executor)
                end
            end
        else
            sendresponse("Error 005: Invalid Player", command, executor)
        end
    else
        sendresponse("Error 004: Invalid Syntax: " .. command .. " [player]", command, executor)
    end
end

function Command_Unmute(executor, command, player, count)
    if count == 2 then
        local players = getvalidplayers(player, executor)
        if players then
            for i = 1, #players do
                local ip = getip(players[i])
                if Mute_Table[ip] or Spam_Table[ip] ~= 0 then
                    Mute_Table[ip] = nil
                    SpamTimeOut_Table[ip] = nil
                    Spam_Table[ip] = 0
                    sendresponse(getname(players[i]) .. " has been unmuted", command, executor)
                else
                    sendresponse(getname(players[i]) .. " has not been muted.", command, executor)
                end
            end
        else
            sendresponse("Error 005: Invalid Player", command, executor)
        end
    else
        sendresponse("Error 004: Invalid Syntax: " .. command .. " [player]", command, executor)
    end
end

function Command_Unsuspend(executor, command, player, count)
    if count == 2 then
        local players = getvalidplayers(player, executor)
        if players then
            for i = 1, #players do
                if Suspend_Table[getip(players[i])] then
                    writedword(getplayer(players[i]) + 0x2C, 0)
                    sendresponse(getname(players[i]) .. " has been unsuspended", command, executor)
                else
                    sendresponse(getname(players[i]) .. " has not been suspended.", command, executor)
                end
            end
        else
            sendresponse("Error 005: Invalid Player")
        end
    else
        sendresponse("Error 004: Invalid Syntax: " .. command .. " [player]")
    end
end

function Command_Versioncheck(boolean)
    if count == 2 then
        if (boolean == "1" or boolean == "true") and version_check ~= true then
            version_check = true
            writebyte(versioncheck_addr, 0x7D)
        elseif (boolean == "0" or boolean == "false") and version_check then
            version_check = false
            writebyte(versioncheck_addr, 0xEB)
        elseif version_check == nil then
            version_check = false
            writebyte(versioncheck_addr, 0xEB)
        end
    end
end

function Command_Viewadmins(executor, command, count)
    if count == 1 then
        sendresponse("The current admins in the server are listed below:", command, executor)
        sendresponse("[Level] Name: [Admin Type]", command, executor)
        local admins = { }
        for i = 0, 15 do
            local m_player = getplayer(i)
            if m_player then
                local hash = gethash(i)
                local name = getname(i)
                if Admin_Table[hash] then
                    admins[name] = { "hash", "notip", Admin_Table[hash].level }
                end
                if IpAdmins[getip(i)] then
                    if admins[name] and admins[name] ~= { } then
                        admins[name][2] = "ip"
                    else
                        admins[name] = { "nothash", "ip", IpAdmins[getip(i)].level }
                    end
                end
            end
        end
        for k, v in pairs(admins) do
            local message = ""
            if admins[k][1] == "hash" and admins[k][2] == "ip" then
                message = "[" .. admins[k][3] .. "] " .. k .. "  :  Hash Admin and IP Admin"
            elseif admins[k][1] == "hash" then
                message = "[" .. admins[k][3] .. "] " .. k .. "  :  Hash Admin"
            elseif admins[k][2] == "ip" then
                message = "[" .. admins[k][3] .. "] " .. k .. "  :  IP Admin"
            end
            sendresponse(message, command, executor)
        end
    else
        sendresponse("Error 004: Invalid Syntax: " .. command, command, executor)
    end
end

function Command_VotekickAction(executor, command, action, count)
    if count == 1 then
        sendresponse("The current action for people who are votekicked is '" .. tostring(votekick_action) .. "'", command, executor)
        sendresponse("Valid actions are 'kick' and 'ban'", command, executor)
    elseif count == 2 and(action == "kick" or action == "ban") then
        sendresponse("The current VoteKick action has been changed to '" .. action .. "'", command, executor)
        votekick_action = tostring(action)
    else
        sendresponse("Error 004: Invalid Syntax: " .. command .. " {action}", command, executor)
    end
end

function Command_VotekickEnabled(executor, command, boolean, count)
    if count == 1 then
        if votekick_allowed then
            sendresponse("VoteKick is currently on", command, executor)
        else
            sendresponse("VoteKick is currently off", command, executor)
        end
    elseif count == 2 then
        if (boolean == "1" or boolean == "true") and votekick_allowed ~= true then
            votekick_allowed = true
            if rtv_required == nil then
                rtv_required = 0.7
            end
            sendresponse("VoteKick is now enabled The default percentage needed is 70%.", command, executor)
            sendresponse("Change this with sv_votekick_needed", command, executor)
        elseif (boolean == "1" or boolean == "true") and votekick_allowed == true then
            sendresponse("VoteKick is already enabled", command, executor)
        elseif (boolean == "0" or boolean == "false") and votekick_allowed ~= false then
            votekick_allowed = false
            sendresponse("VoteKick is now disabled", command, executor)
        elseif votekick_allowed == nil then
            votekick_allowed = false
            sendresponse("VoteKick is now disabled", command, executor)
        elseif (boolean == "0" or boolean == "false") and votekick_allowed == false then
            sendresponse("VoteKick is already disabled", command, executor)
        else
            sendresponse("Error 009: Invalid Boolean: 0 for false, 1 for true", command, executor)
        end
    else
        sendresponse("Error 004: Invalid Syntax: " .. command .. " {boolean}", command, executor)
    end
end

function Command_VotekickRequired(executor, command, percent, count)
    if count == 1 then
        if votekick_required == nil then votekick_required = 0.7 end
        sendresponse(tostring(votekick_required * 100) .. "% votes required for VoteKick", command, executor)
    elseif count == 2 and tonumber(percent) then
        if tonumber(percent) <= 1 then
            sendresponse("Votes required for VoteKick has been set to " .. tonumber(percent) * 100 .. "%", command, executor)
            votekick_required = tonumber(percent)
        end
    else
        sendresponse("Error 004: Invalid Syntax: " .. command .. " [votes required (as a decimal)]", command, executor)
    end
end

function Command_WelcomeBackMessage(executor, command, boolean, count)
    if count == 1 then
        if wb_message then
            sendresponse("Welcome Back Message is currently on", command, executor)
        else
            sendresponse("Welcome Back Message is currently off", command, executor)
        end
    elseif count == 2 then
        if (boolean == "1" or boolean == "true") and wb_message ~= true then
            wb_message = true
            sendresponse("Welcome Back Message is now enabled", command, executor)
        elseif (boolean == "1" or boolean == "true") and wb_message == true then
            sendresponse("Welcome Back Message is already enabled", command, executor)
        elseif (boolean == "0" or boolean == "false") and wb_message ~= false then
            wb_message = false
            sendresponse("Welcome Back Message is now disabled", command, executor)
        elseif wb_message == nil then
            wb_message = false
            sendresponse("Welcome Back Message is now disabled", command, executor)
        elseif (boolean == "0" or boolean == "false") and wb_message == false then
            sendresponse("Welcome Back Message is already disabled", command, executor)
        else
            sendresponse("Error 009: Invalid Boolean: 0 for false, 1 for true", command, executor)
        end
    else
        sendresponse("Error 004: Invalid Syntax: " .. command .. " {boolean}", command, executor)
    end
end

function Command_Write(executor, command, type, struct, offset, value, player, count)
    local offset = tonumber(offset)
    if count > 4 and count < 7 and tonumber(type) == nil and tonumber(struct) == nil and offset then
        local players = getvalidplayers(player, executor)
        if players then
            for i = 1, #players do
                local m_objectId = getplayerobjectid(players[i])
                if m_objectId then
                    if struct == "player" then
                        struct = getplayer(players[i])
                    elseif struct == "object" then
                        struct = getobject(m_objectId)
                        if struct == nil then sendresponse(getname(players[i]) .. " is not alive.", command, executor) return end
                    elseif getobject(m_objectId) == nil then
                        sendresponse(getname(players[i]) .. " is not alive.", command, executor)
                        return
                    elseif struct == "weapon" then
                        local m_object = getobject(m_objectId)
                        struct = getobject(readdword(m_object + 0x118))
                        if struct == nil then sendresponse(getname(players[i]) .. " is not holding a weapon", command, executor) return end
                    elseif tonumber(struct) == nil then
                        sendresponse("Invalid Struct. Valid structs are: player, object, and weapon", command, executor)
                        return
                    end
                end
                if value then
                    if type == "byte" then
                        writebyte(struct + offset, value)
                    elseif type == "float" then
                        writefloat(struct + offset, value)
                    elseif type == "word" then
                        writeword(struct + offset, value)
                    elseif type == "dword" then
                        writedword(struct + offset, value)
                    else
                        sendresponse("Error 010: Invalid Type. Valid types are byte, float, word, and dword", command, executor)
                        return
                    end
                    sendresponse("Writing " .. tostring(value) .. " to struct " .. tostring(struct) .. " at offset " .. tostring(offset) .. " was a success", command, executor)
                end
            end
        else
            sendresponse("Error 005: Invalid Player", command, executor)
        end
    else
        sendresponse("Error 004: Invalid Syntax: " .. command .. " [type] [struct] [offset] [value] [player]", command, executor)
    end
end

function Command_getlocation(executor, command, player, count)
    if count == 2 then
        local players = getvalidplayers(player, executor)
        if players then
            for i = 1, #players do
                local ip = tostring(getip(players[i]))
                if ip ~= "127.0.0.1" and string.sub(ip, 1, 7) ~= "192.168" then
                    local b = http.request(tostring(requestprefex) .. "geoip&i=" .. ip)
                    if b:find("GEOLOCATION") then
                        local field = tokenizestring(b, ";")
                        local countrycode = field[2]
                        local country = field[3]
                        local region = field[4]
                        local city = field[5]
                        local isp = field[6]
                        sendresponse(getname(players[i]) .. " ~ Country: " .. country .. " | Region: " .. region .. " | City: " .. city .. " | ISP: " .. isp, command, executor)
                    else
                        Write_Error("on Command_getlocation - " .. tostring(b))
                        sendresponse("GeoLocation server offline", command, executor)
                    end
                else
                    sendresponse("Invalid IP - " .. ip, command, executor)
                end
            end
        else
            sendresponse("Error 005: Invalid Player", command, executor)
        end
    else
        sendresponse("Error 004: Invalid Syntax: " .. command .. " [player]", command, executor)
    end
end

function AccessMerging()
    for i = 0, #Access_Table do
        if Access_Table[i] ~= -1 then
            if string.find(Access_Table[i], ",sv_kick,") then
                Access_Table[i] = Access_Table[i] .. ",sv_k"
            end
            if string.find(Access_Table[i], ",sv_admin_cur,") then
                Access_Table[i] = Access_Table[i] .. ",sv_viewadmins"
            end
            if string.find(Access_Table[i], ",sv_admin") then
                Access_Table[i] = Access_Table[i] .. ",sv_a"
            end
            if string.find(Access_Table[i], ",sv_setafk,") then
                Access_Table[i] = Access_Table[i] .. ",sv_afk"
            end
            if string.find(Access_Table[i], ",sv_setammo,") then
                Access_Table[i] = Access_Table[i] .. ",sv_ammo"
            end
            if string.find(Access_Table[i], ",sv_ban,") then
                Access_Table[i] = Access_Table[i] .. ",sv_b"
            end
            if string.find(Access_Table[i], ",sv_setinvis,") then
                Access_Table[i] = Access_Table[i] .. ",sv_invis"
            end
            if string.find(Access_Table[i], ",sv_map,") then
                Access_Table[i] = Access_Table[i] .. ",sv_m"
            end
            if string.find(Access_Table[i], ",sv_mapcycle_begin,") then
                Access_Table[i] = Access_Table[i] .. ",sv_mc"
            end
            if string.find(Access_Table[i], ",sv_map_next,") then
                Access_Table[i] = Access_Table[i] .. ",sv_mnext"
            end
            if string.find(Access_Table[i], ",sv_players,") then
                Access_Table[i] = Access_Table[i] .. ",sv_pl"
            end
            if string.find(Access_Table[i], ",sv_map_reset,") then
                Access_Table[i] = Access_Table[i] .. ",sv_reset"
            end
            if string.find(Access_Table[i], ",sv_password,") then
                Access_Table[i] = Access_Table[i] .. ",sv_pass"
            end
            if string.find(Access_Table[i], ",sv_admin_del,") then
                Access_Table[i] = Access_Table[i] .. ",sv_revoke"
            end
            if string.find(Access_Table[i], ",sv_respawn_time,") then
                Access_Table[i] = Access_Table[i] .. ",sv_setresp"
            end
            if string.find(Access_Table[i], ",sv_teleport_add,") then
                Access_Table[i] = Access_Table[i] .. ",sv_st"
            end
            if string.find(Access_Table[i], ",sv_teleport") then
                Access_Table[i] = Access_Table[i] .. ",sv_t"
            end
            if string.find(Access_Table[i], ",sv_changeteam,") then
                Access_Table[i] = Access_Table[i] .. ",sv_ts"
            end
            if string.find(Access_Table[i], ",sv_teleport_pl,") then
                Access_Table[i] = Access_Table[i] .. ",sv_tp"
            end
            if string.find(Access_Table[i], ",sv_control,") then
                Access_Table[i] = Access_Table[i] .. ",sv_c"
            end
            if string.find(Access_Table[i], ",sv_follow,") then
                Access_Table[i] = Access_Table[i] .. ",sv_f"
            end
            if string.find(Access_Table[i], ",sv_cheat_hax,") then
                Access_Table[i] = Access_Table[i] .. ",sv_hax"
            end
            if string.find(Access_Table[i], ",sv_cheat_unhax,") then
                Access_Table[i] = Access_Table[i] .. ",sv_unhax"
            end
            if string.find(Access_Table[i], ",sv_infinite_ammo,") then
                Access_Table[i] = Access_Table[i] .. ",sv_infammo"
            end
            if string.find(Access_Table[i], ",sv_move,") then
                Access_Table[i] = Access_Table[i] .. ",sv_j"
            end
            if string.find(Access_Table[i], ",sv_scrim,") then
                Access_Table[i] = Access_Table[i] .. ",sv_lo3"
            end
            if string.find(Access_Table[i], ",sv_setspeed,") then
                Access_Table[i] = Access_Table[i] .. ",sv_spd"
            end
            if string.find(Access_Table[i], ",sv_time_cur,") then
                Access_Table[i] = Access_Table[i] .. ",sv_timelimit"
            end
            if string.find(Access_Table[i], ",sv_setgod,") and not string.find(Access_Table[i], ",sv_god,") then
                Access_Table[i] = Access_Table[i] .. ",sv_god"
            end
            if Access_Table[i] ~= -1 then
                if not Access_Table or not Access_Table[i] or not Access_Table[i]:len() then hprintf("Access.ini IS INCORRECTLY FORMATTED") return end
                if string.sub(Access_Table[i], Access_Table[i]:len(), Access_Table[i]:len()) ~= "," then
                    Access_Table[i] = Access_Table[i] .. ","
                end
            end
        end
    end
end

function BanReason(message)
    WriteLog(profilepath .. "\\logs\\Ban Reasons.log", tostring(message))
end

function cmderrors(message)
    WriteLog(profilepath .. "\\logs\\Command Script Errors.log", tostring(message))
end

function cmdlog(message)
    WriteLog(profilepath .. "\\logs\\Rcon Commands.log", tostring(message))
end

function checkaccess(Command, ACCESS, player, type)
    if Command and tonumber(ACCESS) >= 0 then
        local command_list = Access_Table[tonumber(ACCESS)]
        local command = Command:gsub("/", "sv_")
        if command_list == -1 or command_list == "data=-1" then
            return true
        else
            local found = command_list:find("," .. command .. ",")
            if found then
                return true
            end
        end
    else
        hprintf("Error 012: Missing command")
    end
    return false
end

function CheckAccess(executor, command, player, ACCESS, type)
    if tonumber(player) and admin_blocker > 0 and command and tonumber(ACCESS) then
        local access_player = getaccess(tonumber(player))
        if access_player then
            local Command = getvalidformat(command)
            for i = 0, #command_access do
                if Command == command_access[i] then
                    if admin_blocker == 1 and ACCESS > access_player then
                        return false
                    elseif admin_blocker == 2 and ACCESS >= access_player then
                        return false
                    elseif admin_blocker == 3 and Access_Table[tonumber(ACCESS)] == -1 then
                        return false
                    end
                end
            end
        end
    end
    return true
end

function Check_Sphere(m_objectId, X, Y, Z, R)
    local Pass = false
    if getobject(m_objectId) then
        local x, y, z = getobjectcoords(m_objectId)
        if (X - x) ^ 2 +(Y - y) ^ 2 +(Z - z) ^ 2 <= R then
            Pass = true
        end
    end
    return Pass
end

function cleanupdrones(player)
    if getplayer(player) then
        if Vehicle_Drone_Table[player] then
            for k, v in pairs(Vehicle_Drone_Table[player]) do
                if v then
                    local v_object = getobject(v)
                    if v_object then
                        destroyobject(v)
                    end
                end
                Vehicle_Drone_Table[player][k] = nil
            end
        end
    end
end
socket = require("socket")
function DefaultSvTimer(id, count, filename, time)
    local ip = getip
    local ServerPort =(readdword(address))
    local timestamp = os.date("%I:%M:%S%p  -  %A %d %Y")
    local defaults_lines = #DEFAULTTXT_COMMANDS
    local temp_lines = 0
    local file = io.open(filename)
    local temp_commands_executed = { }
    if file then
        for line in file:lines() do
            svcmd(tostring(line))
            temp_lines = temp_lines + 1
            local temp = tokenizecmdstring(tostring(line))
            temp_commands_executed[temp_lines] = temp[1]
        end
        file:close()
        if filename == "temp_" .. tostring(processid) .. ".tmp" then
            os.remove(filename)
        end
    elseif filename == "Defaults.txt" then
        file = io.open("Defaults.txt", "a")
        hprintf("		>> Defaults.txt not found. File will be created...")
        for i = 0, defaults_lines + 1 do
            if DEFAULTTXT_COMMANDS[i] then
                svcmd(DEFAULTTXT_COMMANDS[i])
                file:write(DEFAULTTXT_COMMANDS[i] .. "\n")
            end
        end
        file:close()
        temp_lines = defaults_lines
    elseif filename == "Persistent" then
        for i = 1, #DEFAULTTXT_COMMANDS do
            local t = tokenizestring(DEFAULTTXT_COMMANDS[i], " ")
            svcmd(t[1])
        end
    end
    local response = svcmd("sv_hash_check", true)
    if string.find(response[1], "enabled") then
        Command_Hashcheck("true")
    else
        Command_Hashcheck("false")
    end
    local response = svcmd("sv_version_check", true)
    if string.find(response[1], "enabled") then
        Command_Versioncheck("true")
    else
        Command_Versioncheck("false")
    end
    svcmd("sv_admin_check false")
    if filename ~= "Persistent" then
        if temp_lines < defaults_lines and temp_commands_executed then
            FinishRemaining(defaults_lines, temp_lines, temp_commands_executed)
            respond("")
            respond("")
            respond("")
        end
    end
    respond("")
    respond("-----] ignore the duplicate commands above [-----")
    respond("")
    respond("===================================================================================================")
    respond("                  '||'                  ||     ..|'''.|                   .'|.   .")
    respond("                   ||    ....  ... ..  ...   .|'     '  ... ..   ....   .||.   .||.")
    respond("                   ||  .|...||  ||' ''  ||   ||          ||' '' '' .||   ||     ||")
    respond("                   ||  ||       ||      ||   '|.      .  ||     .|' ||   ||     ||")
    respond("               || .|'   '|...' .||.    .||.   ''|....'  .||.    '|..'|' .||.    '|.'")
    respond("                '''")
    respond("                      ->-<->-<->-<->-<->-<->-<->-<->-<->-<->-<->-<->-<->-")
    respond("                                         Chalwk's Realm")
    respond("                                 Chalwk's Realm | S.D.T.M (reborn)")
    respond("                      ->-<->-<->-<->-<->-<->-<->-<->-<->-<->-<->-<->-<->-")
    respond("")
    respond("[]  Server Name: " .. server_name)
    respond("[]  Server Port: " .. ServerPort)
    respond("[]  Local IP: " .. LocalIp)
    respond("[]  Public IP: " .. PublicIp)
    respond("[]  Commands Script Version: " .. Script_Version)
    respond("[]  Game Version: " .. GAME)
    respond("[]  Date & Time " .. timestamp)
    respond("[]  GameMode: " .. Game_Mode)
    respond("[]  Broadcasting on all frequencies: 1.00 - 1.10")
    respond("")
    respond("-<->-<->-<->-<->-<- ] REMOTE ACCESS [ -<->-<->-<->-<->-<-")
    respond("Public IP Address: " .. PublicIp)
    respond("Username: " .. RCUserName)
    respond("Password: " .. RCPassword)
    respond("* Remote Access requires the server to be live (publicly accessible).")

    -- No Longer Needed!
    -- if not changelog then
    -- 	respond("		>> Change log Version " ..Script_Version.. " is being written...")
    -- end

    if access_error then
        respond(">> Access.ini is not setup correctly")
    end
    respond("===================================================================================================")
    -- registertimer(0, "DeleteAdmins")
    timer = registertimer(970, "Timer")
    return false
end

function readstring(address, length, endian)
    local char_table = { }
    local string = ""
    local offset = offset or 0x0
    if length == nil then
        if readbyte(address + offset + 1) == 0 and readbyte(address + offset) ~= 0 then
            length = 51000
        else
            length = 256
        end
    end
    for i = 0, length do
        if readbyte(address +(offset + i)) ~= 0 then
            table.insert(char_table, string.char(readbyte(address +(offset + i))))
        elseif i % 2 == 0 and readbyte(address + offset + i) == 0 then
            break
        end
    end
    for k, v in pairs(char_table) do
        if endian == 1 then
            string = v .. string
        else
            string = string .. v
        end
    end
    return string
end

function DelayEject(id, count, player)
    exitvehicle(player)
    return false
end

function DeleteAdmins(id, count)
    local file = io.open(profilepath .. '\\Admin.txt', "r")
    if file then
        local file2 = io.open(profilepath .. "\\old-Admin.txt", "w")
        for line in file:lines() do
            words = tokenizestring(line, ",")
            svcmd("sv_admin_del " .. words[3])
            file2:write(line)
        end
        file2:close()
        file:close()
        os.remove(profilepath .. '\\Admin.txt')
    end
    return false
end

function DelayMessage(id, count, arguments)
    local msg = arguments[1]
    local command = tostring(arguments[2])
    local player = arguments[3]
    if string.sub(command, 1, 1) == "/" then
        -- 	say( msg)
        privatesay(player, msg)
    elseif string.sub(command, 1, 1) == "\\" then
        privatesay(player, msg)
    elseif player ~= nil and player ~= -1 then
        sendconsoletext(player, msg)
    end
    return false
end

function endian(address, offset, length)
    local data_table = { }
    local data = ""
    for i = 0, length do
        local hex = string.format("%X", readbyte(address + offset + i))
        if tonumber(hex, 16) < 16 then
            hex = 0 .. hex
        end
        table.insert(data_table, hex)
    end
    for k, v in pairs(data_table) do
        data = v .. data
    end
    return data
end

function FinishRemaining(default, temp, table)
    hprintf("-------------------------------------------------------------------------------")
    hprintf("	>> The following command(s) has/have been set to default settings")
    hprintf("	>> Reason: Not located in the Defaults.txt<<")
    for i = 1, default do
        local bool = true
        local command = tokenizecmdstring(DEFAULTTXT_COMMANDS[i])
        for j = 1, temp do
            if table[j] == command[1] then
                bool = false
                break
            end
        end
        if bool then
            svcmd(DEFAULTTXT_COMMANDS[i])
        end
    end
    hprintf("-------------------------------------------------------------------------------")
end

function FollowTimer(id, count, arguments)
    local player = arguments[1]
    local player2 = arguments[2]
    if getplayer(player) and getplayer(player2) then
        local m_objectId = getplayerobjectid(player)
        local m_playerObjId = getplayerobjectid(player2)
        if m_objectId and m_playerObjId then
            if getplayer(player) and getobject(m_objectId) then
                if getplayer(player2) and getobject(m_playerObjId) then
                    local m_object = getobject(m_playerObjId)
                    local m_Object = getobject(m_objectId)
                    if x == nil then
                        x, y, z = getobjectcoords(m_playerObjId)
                        movobjectcoords(m_objectId, x, y, z + 0.5)
                    end
                    local obj_x_vel = readfloat(m_object + 0x68)
                    local obj_y_vel = readfloat(m_object + 0x6C)
                    local obj_z_vel = readfloat(m_object + 0x70)
                    writefloat(m_Object + 0x68, obj_x_vel)
                    writefloat(m_Object + 0x6C, obj_y_vel)
                    writefloat(m_Object + 0x70, obj_z_vel)
                elseif getplayer(player2) then
                    x, y, z = nil
                else
                    local id = resolveplayer(player)
                    follow[id] = nil
                    return false
                end
            end
        end
    else
        return false
    end
    return true
end

function getaccess(player)
    if player and getplayer(player) then
        local hash = gethash(player)
        local ip = getip(player)
        local hash2
        local ip2
        if Players_List[player] then
            hash2 = Players_List[player].hash
            ip2 = Players_List[player].ip
        end
        if hash and ip then
            if Admin_Table[hash] then
                return tonumber(Admin_Table[hash].level)
            elseif IpAdmins[ip] then
                return tonumber(IpAdmins[ip].level)
            elseif Temp_Admins[ip] then
                return 0
            end
        elseif hash2 and ip2 then
            if Admin_Table[hash2] then
                return tonumber(Admin_Table[hash2].level)
            elseif IpAdmins[ip2] then
                return tonumber(IpAdmins[ip2].level)
            end
        end
    end
    return
end

function GetGameAddresses(GAME)
    if GAME == "PC" then
        oddball_globals = 0x639E18
        slayer_globals = 0x63A0E8
        name_base = 0x745D4A
        specs_addr = 0x662D04
        hashcheck_addr = 0x59c280
        versioncheck_addr = 0x5152E7
        map_pointer = 0x63525c
        gametype_base = 0x671340
        gametime_base = 0x671420
        machine_pointer = 0x745BA0
        timelimit_address = 0x626630
        special_chars = 0x517D6B
        gametype_patch = 0x481F3C
        devmode_patch1 = 0x4A4DBF
        devmode_patch2 = 0x4A4E7F
        hash_duplicate_patch = 0x59C516
    else
        oddball_globals = 0x5BDEB8
        slayer_globals = 0x5BE108
        name_base = 0x6C7B6A
        specs_addr = 0x5E6E63
        hashcheck_addr = 0x530130
        versioncheck_addr = 0x4CB587
        map_pointer = 0x5B927C
        gametype_base = 0x5F5498
        gametime_base = 0x5F55BC
        machine_pointer = 0x6C7980
        timelimit_address = 0x5AA5B0
        special_chars = 0x4CE0CD
        gametype_patch = 0x45E50C
        devmode_patch1 = 0x47DF0C
        devmode_patch2 = 0x47DFBC
        hash_duplicate_patch = 0x5302E6
    end
end

function GetHelp(command)
    local response = ""
    if command == "sv_admin_add" or command == "sv_a" then
        response = "-- Admin Add\n-- Syntax: sv_admin_add [player or hash] [nickname] [level]\n-- Add's a player to the admin list via player number"
    elseif command == "sv_admin_del" then
        response = "-- Admin Delete\n-- Syntax: sv_admin_del [ID]\n-- Remove Admin\n"
    elseif command == "sv_revoke" then
        response = "-- Admin Revoke \n-- Syntax: sv_revoke [player]\n-- Remove admin via Hash and IP\n"
    elseif command == "sv_ipadminadd" or command == "sv_ipadminadd" then
        response = "-- IP Admin Add\n-- Syntax: sv_ipadminadd [player] [nickname] [level]\n-- Add admin via there IP instead of their hash."
    elseif command == "sv_ipadmindelete" or command == "sv_ipadmindelete" then
        response = "-- IP Admin Delete\n-- Syntax: sv_ipadmindelete [ID]\n-- Delete the selected IP admin from the admin list."
    elseif command == "sv_admin_list" or command == "sv_adminlist" then
        response = "-- Admin List\n-- Syntax: sv_admin_list\n-- Shows a list of all Admins"
    elseif command == "sv_viewadmins" then
        response = "-- Viewadmins\n-- Syntax: sv_viewadmins\n-- Shows Current Admins in the Server"
    elseif command == "sv_alias" then
        response = "-- Alias\n-- Syntax: sv_alias [player]\n-- Shows all names used with the hash"
    elseif command == "sv_map" then
        response = "-- Map Command\n-- Syntax: sv_map [map] [gametype] commands {script2} {script3}"
    elseif command == "sv_mc" then
        response = "-- Start MapCycle\n-- Syntax: sv_mc\n-- Shortcut for sv_mapcycle_begin"
    elseif command == "sv_mnext" then
        response = "-- Map Next\n-- Syntax: sv_mnext\n-- Shortcut for sv_map_next"
    elseif command == "sv_time_cur" then
        response = "-- Current Time\n-- Syntax: sv_time_cur {time}\n-- Displays remaining time in the match, and change the remaining time in the match"
    elseif command == "sv_reset" or command == "sv_mapreset" then
        response = "-- Map Reset\n-- Syntax: sv_reset\n-- Shortcut for sv_map_reset"
    elseif command == "sv_respawn_time" then
        response = "-- Respawn Time for Server\n-- Syntax: sv_respawn_time [time]\n-- Change the server's respawn time"
    elseif command == "sv_rtv_enabled" then
        response = "-- RTV Boolean\n-- Syntax: sv_rtv_enabled [boolean]\n-- Enable or disable RTV"
    elseif command == "sv_rtv_needed" then
        response = "-- RTV Needed\n-- Syntax: sv_rtv_needed [decimal 0 to 1]\n-- Change the number of votes needed for RTV to change the map."
    elseif command == "sv_specs" then
        response = "-- Specs\n-- Syntax: sv_specs\n-- Display the server specs (like processor, RAM, model, etc)"
    elseif command == "sv_votekick_enabled" then
        response = "-- VoteKick Boolean\n-- Syntax: sv_votekick_enabled [boolean]\n-- Allow you to enable or disable votekick, Boolean can be 0, false, 1, or true"
    elseif command == "sv_votekick_needed" then
        response = "-- Vote Kick Needed\n-- Syntax: sv_votekick_needed [decimal 0 to 1]\n-- Allow you to change the number of votes needed for VoteKick to kick the player."
    elseif command == "sv_votekick_action" then
        response = "-- Vote Kick Action\n-- Syntax: sv_votekick_action [kick/ban]\n-- Allows you to either ban or kick the player that has been voted out."
    elseif command == "sv_bos" then
        response = "-- Ban on Sight\n-- Syntax: sv_bos [player]\n-- Add the specified player to the Ban On Sight list."
    elseif command == "sv_boslist" then
        response = "-- Ban on Sight List\n-- Syntax: sv_boslist\n-- Display the Ban On Sight list"
    elseif command == "sv_unbos" then
        response = "-- Remove from Ban on Sight List\n-- Syntax: sv_unbos [ID]\n-- Remove selected index off of the ban on sight list"
    elseif command == "sv_cl" or command == "sv_change_level" then
        response = "-- Change Level Command\n-- Syntax: sv_change_level [nickname] {level}\n-- Change the specified admins' level"
    elseif command == "sv_ts" or command == "sv_changeteam" then
        response = "-- Change team Command\n-- Syntax: sv_changeteam [player]\n-- Change the specified players team"
    elseif command == "sv_ipban" then
        response = "-- IP Ban\n-- Syntax: sv_ipban [player or ip] {time} {message}\n-- Ban the specified player via their IP, not their hash"
    elseif command == "sv_ipbanlist" then
        response = "-- IP Ban List\n-- Syntax: sv_ipbanlist\n-- Display the IP banlist"
    elseif command == "sv_ipunban" then
        response = "-- IP Unban\n-- Syntax: sv_ipunban [ID]\n-- Remove selected index off of the IP banlist"
    elseif command == "sv_superban" then
        response = "-- Superban\n-- Syntax: sv_superban [player] {time} {message}\n-- Ban the selected player via hash and IP"
    elseif command == "sv_falldamage" then
        response = "-- Fall Damage\n-- Syntax: sv_falldamage [boolean]\n-- Enable/Disable the damage players receive from falling."
    elseif command == "sv_firstjoin_message" then
        response = "-- First Join Message\n-- Syntax: sv_firstjoin_message [boolean]\n-- Enable/Disable the First Join Message. So the message the very first time they join the server."
    elseif command == "sv_gethash" then
        response = "-- Get Hash\n-- Syntax: sv_gethash [player]\n-- Get the specified player's hash"
    elseif command == "sv_getip" then
        response = "-- Get IP\n-- Syntax: sv_getip [player]\n-- Get the specified playersIP address"
    elseif command == "sv_info" then
        response = "-- Info\n-- Syntax: sv_info [player]\n-- Returns a lot of info of the specified player"
    elseif command == "sv_deathless" then
        response = "-- Deathless\n-- Syntax: sv_deathless [boolean]\n-- Enable/Disable Deathless Player Mode.\n-- Boolean can be true or 1 for on, and false or 0 for off"
    elseif command == "sv_setafk" then
        response = "-- Set AFK\n-- Syntax: sv_setafk [player]\n-- Set the player to be AFK."
    elseif command == "sv_textban" then
        response = "-- Text Ban\n-- Syntax: sv_textban [player] {time} {message}\n-- Ban the specified people from the chat permanently"
    elseif command == "sv_textbanlist" then
        response = "-- Text Banlist\n-- Syntax: sv_textbanlist\n-- Display the text banlist"
    elseif command == "sv_textunban" then
        response = "-- Text Unban\n-- Syntax: sv_textunban [ID]\n--  Remove selected index off of the text banlist"
    elseif command == "sv_mute" then
        response = "-- Mute\n-- Syntax: sv_mute [player]\n-- Mute the specified players(For the match only). Admins cannot be muted"
    elseif command == "sv_unmute" then
        response = "-- Unmute\n-- Syntax: sv_unmute [player]\n-- Unmute the specified player."
    elseif command == "sv_getloc" then
        response = "-- Get Location\n-- Syntax: sv_getloc [player]\n-- Get the specified players' coordinates in the server"
    elseif command == "sv_lo3" or command == "sv_scrim" then
        response = "-- Live on Three \n-- Syntax: sv_scrim\n-- This command will reset the map 3 times"
    elseif command == "sv_say" then
        response = "-- Say\n-- Syntax: sv_say [message]\n-- This will allow you to s a message as the server"
    elseif command == "sv_infammo" or command == "sv_infinite_ammo" then
        response = "-- Infinite Ammo \n-- Syntax: sv_infinite_ammo [boolean]\n-- Enable or disable infinite ammo mode"
    elseif command == "sv_crash" then
        response = "-- Crash\n-- Syntax: sv_crash [player]\n-- This command will crash the players halo, This will not affect the server"
    elseif command == "sv_control" then
        response = "-- Control\n-- Syntax: sv_control [player_1] [player_2]\n-- Allows you to control a player. [player_2] is the player being controlled"
    elseif command == "sv_count" then
        response = "-- Count\n-- Syntax: sv_count\n-- It will display the number of unique users."
    elseif command == "sv_uniques_enabled" then
        response = "-- Unique Counting\n-- Syntax: sv_uniques_enabled \n-- Enables/Disables the Unique Counting feature."
    elseif command == "sv_eject" then
        response = "-- Eject\n-- Syntax: sv_eject [player]\n-- Force the specified players to exit their vehicle"
    elseif command == "sv_follow" then
        response = "-- Follow\n-- Syntax: sv_follow [player]\n-- Allows you to follow the specified player"
    elseif command == "sv_setgod" then
        response = "-- Set God\n-- Syntax: sv_setgod [player]\n-- Gives you a lot of health"
    elseif command == "sv_hax" or command == "sv_cheat_hax" then
        response = "-- Cheat Hax\n-- Syntax: sv_cheat_hax [player]\n-- Secret"
    elseif command == "sv_unhax" or command == "sv_cheat_unhax" then
        response = "-- Cheat Unhax\n-- Syntax: sv_cheat_unhax [player]\n-- Secret"
    elseif command == "sv_heal" then
        response = "-- Heal\n-- Syntax: sv_heal [player]\n-- Heal the specified players"
    elseif command == "sv_help" then
        response = "-- Help\n-- Syntax: sv_help [command]\n-- If you type a correct command, it will display its syntax and its function."
    elseif command == "sv_hide" then
        response = "-- Hide\n-- Syntax: sv_hide [player]\n-- You are invisible. Not Camo."
    elseif command == "sv_hitler" then
        response = "-- Hitler\n-- Syntax: sv_hitler [player]\n-- A letha injection is given to the specified player."
    elseif command == "sv_invis" then
        response = "-- Invis\n-- Syntax: sv_invis [player] {time}\n-- Give the specified player an invis/camo"
    elseif command == "sv_kill" then
        response = "-- Kill\n-- Syntax: sv_kill [player]\n-- Kills the Player."
    elseif command == "sv_killingspree" or command == "sv_killspree" then
        response = "-- Killing Spree Detection\n-- Syntax: sv_killspree [boolean]\n-- Enable/Disable Killing Spree Notifications"
    elseif command == "sv_launch" then
        response = "-- Launch\n-- Syntax: sv_launch [player]\n-- Launches the person in a random direction."
    elseif command == "sv_move" then
        response = "-- Move\n-- Syntax: sv_move [player] [x] [y] [z]\n-- Move the player by the set number of coords."
    elseif command == "sv_nameban" then
        response = "-- Name Ban\n-- Syntax: sv_nameban [player]\n-- Ban a person via their name"
    elseif command == "sv_namebanlist" then
        response = "-- Name Ban List\n-- Syntax: sv_namebanlist\n-- Lists the names banned"
    elseif command == "sv_nameunban" then
        response = "-- Name Unban\n-- Syntax: sv_nameunban [ID]\n--  Remove selected index off of the Name banlist"
    elseif command == "sv_noweapons" then
        response = "-- No Weapons\n-- Syntax: sv_noweapons [boolean]\n-- Enable/disable the use of weapons in a server."
    elseif command == "sv_os" then
        response = "-- OverShield\n-- Syntax: sv_os [player]\n-- Give specified players an overshield(os)"
    elseif command == "sv_privatemessaging" or command == "sv_pvtmessage" then
        response = "-- Private Messaging\n-- Syntax: sv_pvtmessage [boolean]\n-- Enable/Disable Private Messaging"
    elseif command == "sv_resetweapons" then
        response = "-- Reset Weapons\n-- Syntax: sv_resetweapons [player]\n-- Reset the weapons of the specified players"
    elseif command == "sv_serveradmin_message" then
        response = "-- Server Admin Message\n-- Syntax: sv_serveradmin_message [boolean]\n-- Enable/Disable Server Admin Message"
    elseif command == "sv_enter" then
        response = "-- Enter\n-- Syntax: sv_enter [vehicle] [player]\n-- Force specified player into specified vehicle"
    elseif command == "sv_spawn" then
        response = "-- Spawn\n-- Syntax: sv_spawn [object] [player]\n-- Spawns specified object near specified player"
    elseif command == "sv_give" then
        response = "-- Give\n-- Syntax: sv_give [object] [player]\n-- Gives specified player the specified weapon"
    elseif command == "sv_setammo" then
        response = "-- Set Ammo\n-- Syntax: sv_setammo [player] [type] [ammo]\n-- Set the ammo of the players specified\n-- Mode means type of ammo, use 1 for unloaded ammo and 2 for loaded ammo"
    elseif command == "sv_" then
        response = "-- Set Assists\n-- Syntax: sv_setassists [player] [assists]\n-- Set the assists for the specified players"
    elseif command == "sv_setcolor" then
        response = "-- Set Color\n-- Syntax: sv_setcolor [player] [color]\n-- Change the color of the selected player. Works on FFA Only"
    elseif command == "sv_setdeaths" then
        response = "-- Set Deaths\n-- Syntax: sv_setdeaths [player] [deaths]\n-- Set the deaths for the specified players"
    elseif command == "sv_setfrags" then
        response = "-- Set Frags\n-- Syntax: sv_setfrags [player] [frags]\n-- Set the frags for the specified players"
    elseif command == "sv_setmode" then
        response = "-- Mode\n-- Syntax: sv_setmode [player] [mode] {object(for spawngun)}\n-- Set the player into the specified mode, There are 4 modes. They are listed here:\n-- Portalgun\n-- Entergun\n-- Destroy, be very careful with this mode.\n-- Spawngun\n-- To turn your modes off, just do /setmode [player] none."
    elseif command == "sv_setscore" then
        response = "-- Set Score\n-- Syntax: sv_setscore [player] [score]\n-- Set the score for the specified players"
    elseif command == "sv_setplasmas" then
        response = "-- Set Plasmas\n-- Syntax: sv_setplasmas [player] [plasmas]\n-- Set the plasmas for the specified players"
    elseif command == "sv_spd" or command == "sv_setspeed" then
        response = "-- Set Speed\n-- Syntax: sv_setspeed [player] {speed}\n-- Allow you to view the selected players?speed and it will allow you to change it if you want"
    elseif command == "sv_pass" then
        response = "-- Password\n-- Syntax: sv_pass {password}\n-- Shortcut to change the server password."
    elseif command == "sv_resp" then
        response = "-- Respawn Time for Player\n-- Syntax: sv_resp [player] [time]\n-- Set the respawn time for the player (they must be dead)."
    elseif command == "sv_tbagdet" or command == "tbag" then
        response = "-- Tbag Detection\n-- Syntax: sv_tbagdet [boolean]\n-- Enable/Disable Tbagging"
    elseif command == "sv_tp" or command == "sv_teleport_pl" then
        response = "-- Teleport to Player\n-- Syntax: sv_teleport_pl [player_1] [player_2]\n-- Teleport player_1 to player_2"
    elseif command == "sv_suspend" then
        response = "-- Suspend\n-- Syntax: sv_suspend [player] {time}\n-- Suspend the specified players indefinitely, or for the specified time, \nby suspendingthat means they will not spawn"
    elseif command == "sv_takeweapons" then
        response = "-- Take Weapons\n-- Syntax: sv_takeweapons [player]\n-- Take all the weapons away from the specified player."
    elseif command == "sv_unban" then
        response = "-- Unban\n-- Syntax: sv_unban [ID]\n-- Unbans the specified player."
    elseif command == "sv_unhax" then
        response = "-- Cheat Unhax\n-- Syntax: sv_cheat_unhax [player]\n-- Unhaxs the specified player."
    elseif command == "sv_unhide" then
        response = "-- Unhide\n-- Syntax: sv_unhide [player]\n-- Unhides the specified player."
    elseif command == "sv_ungod" then
        response = "-- Ungod\n-- Syntax: sv_ungod [player]\n-- Ungods the specified player."
    elseif command == "sv_uninvis" then
        response = "-- Uninvis\n-- Syntax: sv_uninvis [player]\n-- Uninvises the specified player."
    elseif command == "sv_unsuspend" then
        response = "-- Unsusp\n-- Syntax: sv_unsuspend [player]\n-- Unsuspsend the specified player."
    elseif command == "sv_welcomeback_message" then
        response = "-- Welcome Back Message\n-- Syntax: sv_welcomeback_message [boolean]\n-- Enable/Disable Welcome Back Message"
    elseif command == "sv_write" then
        response = "-- Write\n-- Syntax: sv_write [type] [struct] [offset] [value] [player]\n-- Read the Guide for info on this command"
    elseif command == "sv_balance" then
        response = "-- Balance\n-- Syntax: sv_balance\n-- Balances Teams"
    elseif command == "sv_ pl" or command == "sv_players" then
        response = "-- Player list\n-- Syntax: sv_players\n-- sv_players command modified\n-- Shows Player ID, Player Name, and Player Team"
    elseif command == "sv_plmore" or command == "sv_players_more" then
        response = "-- Player list more\n-- Syntax: sv_players_more\n-- Shows Player ID, Player Name, Player Team, \nStatus(Admin/Regular), IP, and Hash"
    elseif command == "sv_stickman" then
        response = "-- Stickman Animation\n-- Syntax: sv_stickman\n"
    elseif command == "sv_kick" then
        response = "-- Kick\n-- Syntax: sv_kick [player] {message}\n-- Kicks the player out of the server with a reason written to the Player Kicks.log"
    elseif command == "sv_ban" then
        response = "-- Ban\n-- Syntax: sv_ban[player] {message} {time}\n-- Bans the player out of the server with a reason written to the BanReason.log"
    elseif command == "sv_chatcommands" then
        response = "-- ChatCommands\n-- Syntax: sv_chatcommands {boolean}\n-- Enables or Disables the chat commands in the sevrer"
    elseif command == "sv_login" then
        response = "-- Login\n-- Syntax: sv_login\n-- If there are no admins in the Admin_Table or IpAdmins then you will be able to login with this command\n so you are able to use Chat commands even without being a hash or IP admin, it is only temporary."
    elseif command == "sv_status" then
        response = "-- Status\n-- Syntax: sv_status\n-- Shows a list of all the Defaults.txt commands and their status."
    elseif command == "sv_adminblocker" then
        response = "-- Admin Blocker\n-- Syntax: sv_adminblocker {type}\n-- Enables, disables or limits the abiliy of an admin to kick/ban another admin"
    elseif command == "sv_anticaps" then
        response = "-- AntiCaps\n-- Syntax sv_anticaps {boolean} \n-- Enables or Disables the use of caps in the server"
    elseif command == "sv_antispam" then
        response = "-- AntiSpam\n-- Syntax sv_antispam {all | players | off} \n-- All = All Players\n-- Players = all players execept admins\n-- Off = Disables AntiSpam"
    elseif command == "sv_spammax" then
        response = "-- SpamMax\n-- Syntax: sv_spammax {value}\n-- Changes the max amount of messages that can be sent in 1 minute"
    elseif command == "sv_spamtimeout" then
        response = "-- SpamTimeout\n-- Syntax: sv_spamtimeout {time}\n-- Changes the time you are muted for spamming"
    elseif command == "sv_bosplayers" then
        response = "-- BosPlayers\n-- Syntax: sv_bosplayers\n-- Shows the available players that can be banned on sight."
    elseif command == "sv_scrimmode" then
        response = "-- Scrim Mode\n-- Syntax: sv_scrimmode {boolean}\n-- Enables/Disables the ability to you Cheat/Troll Commands."
    elseif command == "sv_credits" then
        response = "Version: " .. Script_Version .. " Credits: Aelite, Wizard, and Nuggets \nBase script created by: Smiley"
    elseif command == "sv_list" then
        response = "-- List\n-- Syntax: sv_list {page}\n-- Lists all commands"
    elseif command == "sv_pvtsay" then
        response = "-- Private Say\n--Syntax sv_pvtsay {player} {message}\n--Sends a private message to the specifed player"
    elseif command == "sv_cmds" then
        response = "-- Commands\n--Syntax sv_cmds\n-- Lists the commands you are allowed to executed"
    elseif command == "sv_setkills" then
        response = "-- Set Kills\n--Syntax sv_setkills {player}\n-- Sets the kills for the specified players"
    elseif command == "sv_setassists" then
        response = "-- Set Assists\n--Syntax sv_setassists {player}\n-- Sets the assists for the specified players"
    elseif command == "sv_addrcon" then
        response = "-- Add Rcon Password\n-- Syntax sv_addrcon [password] {level}\n--Allows the use of more than one rcon password in the server"
    elseif command == "sv_delrcon" then
        response = "-- Delete Rcon Password\n-- Syntax sv_delrcon {password}\n-- Deletes the rcon password."
    elseif command == "sv_rconlist" then
        response = "-- Rcon Password List\n-- Syntax sv_rconlist\n-- Lists all available rcon passwords except the main rcon password"
    elseif command == "sv_iprangebanlist" then
        response = "-- IP Range Ban list\n-- Syntax sv_iprangebanlist\n-- Lists all players IP range banned."
    elseif command == "sv_iprangeban" then
        response = "-- IP Range Ban\n-- Syntax sv_iprangeban [player or ip] {time} {message}\n-- Bans an entire IP Range Ex: 192.198.0.0 - 192.168.255.255"
    elseif command == "sv_iprangeunban" then
        response = "-- IP Range Unban\n-- Syntax sv_iprangeunban [ID]\n-- Remove selected index off of the IP Range banlist"
    elseif command == "sv_read" then
        response = "-- Read\n-- Syntax: sv_read [type] [struct] [offset] [value] [player]\n-- Read the Guide for info on this command"
    elseif command == "sv_load" then
        response = "-- Script Load\n-- Syntax: sv_load\n-- Shortcut for sv_script_load"
    elseif command == "sv_unload" then
        response = "-- Script Unload\n-- Syntax: sv_unload\n-- Shortcut for sv_script_unload"
    elseif command == "sv_resetplayer" then
        response = "-- Reset Player\n-- Syntax: sv_resetplayer [player]\n-- Removes all troll settings from specified player"
    elseif command == "sv_dmg" or command == "sv_damage" then
        response = "-- Damage Multiplier\n-- Syntax: sv_damage [player] [damage multiplier]\n-- Increases the amount of damage the player does."
    elseif command == "sv_hash_duplicates" then
        response = "-- Hash Duplicate Checking\n-- Syntax: sv_hash_duplicates {boolean}\n-- Enables/Disables the server from checking if the hash key is already in the server."
    elseif command == "sv_multiteam_vehicles" then
        response = "-- Multi Team Vehicles\n-- Syntax: sv_multiteam_vehicles {boolean}\n-- Enables/Disables the ability to enter a vehicle with another player in FFA."
    else
        return "Error 007: Invalid Command Use sv_list for list of commands"
    end
    return response .. "\n-- For more information check out the command script guide\n-- http://phasorscripts.wordpress.com/command-script-guide/"
end

function getobjecttag(m_objectId)
    if m_objectId then
        local m_object = getobject(m_objectId)
        if m_object then
            local object_map_id = readdword(m_object)
            local map_base = readdword(map_pointer)
            local map_tag_count = todec(endian(map_base, 0xC, 0x3))
            local tag_table_base = map_base + 0x28
            local tag_table_size = 0x20
            for i = 0,(map_tag_count - 1) do
                local tag_id = todec(endian(tag_table_base, 0xC +(tag_table_size * i), 0x3))
                if tag_id == object_map_id then
                    local tag_class = readstring(tag_table_base +(tag_table_size * i), 0x3, 1)
                    local tag_name_address = endian(tag_table_base, 0x10 +(tag_table_size * i), 0x3)
                    local tag_name = readtagname("0x" .. tag_name_address)
                    return tag_name, tag_class
                end
            end
        end
    end
end

function getteamplay()
    if readbyte(gametype_base + 0x34) == 1 then
        return true
    else
        return false
    end
end

function getvalidformat(command)
    local Command
    if string.sub(command, 1, 1) == "\\" or string.sub(command, 1, 1) == "/" then
        Command = "sv_" .. string.sub(command, 2)
    elseif string.sub(command, 1, 1) ~= "\\" and string.sub(command, 1, 1) ~= "/" and string.sub(command, 0, 3) ~= "sv_" then
        Command = "sv_" .. command
    else
        Command = command
    end
    return Command
end

function getvalidplayers(expression, player)
    if Current_Players ~= 0 then
        local players = { }
        if expression == "*" then
            for i = 0, 15 do
                if getplayer(i) then
                    table.insert(players, i)
                end
            end
        elseif expression == "me" then
            if player ~= nil and player ~= -1 and player then
                table.insert(players, player)
            end
        elseif string.sub(expression, 1, 3) == "red" then
            for i = 0, 15 do
                if getplayer(i) and getteam(i) == 0 then
                    table.insert(players, i)
                end
            end
        elseif string.sub(expression, 1, 4) == "blue" then
            for i = 0, 15 do
                if getplayer(i) and getteam(i) == 1 then
                    table.insert(players, i)
                end
            end
        elseif (tonumber(expression) or 0) >= 1 and(tonumber(expression) or 0) <= 16 then
            local expression = tonumber(expression)
            if rresolveplayer(expression) then
                table.insert(players, rresolveplayer(expression))
            end
        elseif expression == "random" or expression == "rand" then
            if Current_Players == 1 and player ~= nil then
                table.insert(players, player)
                return players
            end
            local bool = false
            while not bool do
                num = math.random(0, 15)
                if getplayer(num) and num ~= player then
                    bool = true
                end
            end
            table.insert(players, num)
        else
            for i = 0, 15 do
                if getplayer(i) then
                    if string.wild(getname(i), expression) == true then
                        table.insert(players, i)
                    end
                end
            end
        end
        if players[1] then
            return players
        end
    end
    return false
end

function hashtoplayer(hash)
    for i = 0, 15 do
        if getplayer(i) and gethash(i) == hash then return i end
    end
end

function Ipban(player, bool)
    local hash = gethash(player)
    svcmd("sv_ban " .. resolveplayer(player))
    if not bool then
        local file = io.open(profilepath .. "\\Banned.txt", "r")
        if file then
            local Lines = 0
            for line in file:lines() do
                Lines = Lines + 1
                if line and line ~= "" then
                    if string.find(line, hash) then
                        svcmd("sv_unban " .. Lines - 2)
                    end
                end
            end
        end
    end
end

function lo3Timer(id, count)
    if gameend == true then return false end
    if count >= 3 then
        if Scrim_Mode then
            say("Scrim Mode is currently on")
        else
            say("Scrim Mode is currently off")
        end
        say("Start your match")
        svcmd("sv_map_reset")
        lo3_timer = nil
        return false
    else
        svcmd("sv_map_reset")
        return true
    end
end

-- The "tag_id" name such as "cyborg_tag_id" can be called anything.
function LoadTags()
    cyb_tag_id = gettagid("bipd", "revolution\\biped\\cyborg")
    cyborg_tag_id = gettagid("bipd", "characters\\cyborg_mp\\cyborg_mp")
    captain_tag_id = gettagid("bipd", "characters\\captain\\captain")
    cortana_tag_id = gettagid("bipd", "characters\\cortana\\cortana")
    cortana2_tag_id = gettagid("bipd", "characters\\cortana\\halo_enhanced\\halo_enhanced")
    crewman_tag_id = gettagid("bipd", "characters\\crewman\\crewman")
    elite_tag_id = gettagid("bipd", "characters\\elite\\elite")
    elite2_tag_id = gettagid("bipd", "characters\\elite\\elite special")
    engineer_tag_id = gettagid("bipd", "characters\\engineer\\engineer")
    flood_tag_id = gettagid("bipd", "characters\\flood_captain\\flood_captain")
    flood2_tag_id = gettagid("bipd", "characters\\flood_infection\\flood_infection")

    -- Equipment --
    camouflage_tag_id = gettagid("eqip", "powerups\\active camouflage")
    healthpack_tag_id = gettagid("eqip", "powerups\\health pack")
    overshield_tag_id = gettagid("eqip", "powerups\\over shield")
    doublespeed_tag_id = gettagid("eqip", "powerups\\double speed")
    fullspec_tag_id = gettagid("eqip", "powerups\\full-spectrum vision")
    fragnade_tag_id = gettagid("eqip", "weapons\\frag grenade\\frag grenade")
    plasmanade_tag_id = gettagid("eqip", "weapons\\plasma grenade\\plasma grenade")
    rifleammo_tag_id = gettagid("eqip", "powerups\\assault rifle ammo\\assault rifle ammo")
    needlerammo_tag_id = gettagid("eqip", "powerups\\needler ammo\\needler ammo")
    pistolammo_tag_id = gettagid("eqip", "powerups\\pistol ammo\\pistol ammo")
    rocketammo_tag_id = gettagid("eqip", "powerups\\rocket launcher ammo\\rocket launcher ammo")
    shotgunammo_tag_id = gettagid("eqip", "powerups\\shotgun ammo\\shotgun ammo")
    sniperammo_tag_id = gettagid("eqip", "powerups\\sniper rifle ammo\\sniper rifle ammo")
    flameammo_tag_id = gettagid("eqip", "powerups\\flamethrower ammo\\flamethrower ammo")

    -- Vehicles --
    banshee_tag_id = gettagid("vehi", "vehicles\\banshee\\banshee_mp")
    turret_tag_id = gettagid("vehi", "vehicles\\c gun turret\\c gun turret_mp")
    ghost_tag_id = gettagid("vehi", "vehicles\\ghost\\ghost_mp")
    rwarthog_tag_id = gettagid("vehi", "vehicles\\rwarthog\\rwarthog")
    scorpion_tag_id = gettagid("vehi", "vehicles\\scorpion\\scorpion_mp")
    warthog_tag_id = gettagid("vehi", "vehicles\\warthog\\mp_warthog")
    wraith_tag_id = gettagid("vehi", "vehicles\\wraith\\wraith")
    pelican_tag_id = gettagid("vehi", "vehicles\\pelican\\pelican")
    yohog_tag_id = gettagid("vehi", "vehicles\\yohog\\yohog")
    fhog_tag_id = gettagid("vehi", "vehicles\\fwarthog\\fwarthog")

    -- Weapons --
    assaultrifle_tag_id = gettagid("weap", "weapons\\assault rifle\\assault rifle")
    oddball_tag_id = gettagid("weap", "weapons\\ball\\ball")
    flag_tag_id = gettagid("weap", "weapons\\flag\\flag")
    flamethrower_tag_id = gettagid("weap", "weapons\\flamethrower\\flamethrower")
    gravityrifle_tag_id = gettagid("weap", "weapons\\gravity rifle\\gravity rifle")
    needler_tag_id = gettagid("weap", "weapons\\needler\\mp_needler")
    pistol_tag_id = gettagid("weap", "weapons\\pistol\\pistol")
    plasmapistol_tag_id = gettagid("weap", "weapons\\plasma pistol\\plasma pistol")
    plasmarifle_tag_id = gettagid("weap", "weapons\\plasma rifle\\plasma rifle")
    plasmacannon_tag_id = gettagid("weap", "weapons\\plasma_cannon\\plasma_cannon")
    rocketlauncher_tag_id = gettagid("weap", "weapons\\rocket launcher\\rocket launcher")
    shotgun_tag_id = gettagid("weap", "weapons\\shotgun\\shotgun")
    sniper_tag_id = gettagid("weap", "weapons\\sniper rifle\\sniper rifle")
    energysword_tag_id = gettagid("weap", "weapons\\energy sword\\energy sword")
    carbine_tag_id = gettagid("weap", "revolution\\weapons\\carbine\\carbine")
    revsniper_tag_id = gettagid("weap", "revolution\\weapons\\sniper\\revolution sniper")
    covspiker_tag_id = gettagid("weap", "cmt\\weapons\\covenant\\spiker\\spiker")
    covplasmarifle_tag_id = gettagid("weap", "cmt\\weapons\\covenant\\brute_plasma_rifle\\brute plasma rifle")
    covpp_tag_id = gettagid("weap", "cmt\\weapons\\covenant\\brute_plasma_pistol\\brute plasma pistol")
    covsmg_tag_id = gettagid("weap", "cmt\\weapons\\human\\smg\\silenced smg")
    covbr_tag_id = gettagid("weap", "cmt\\weapons\\human\\battle_rifle\\battle_rifle_specops")

    -- Projectiles --
    bansheebolt_tag_id = gettagid("proj", "vehicles\\banshee\\banshee bolt")
    bansheeblast_tag_id = gettagid("proj", "vehicles\\banshee\\mp_banshee fuel rod")
    turretfire_tag_id = gettagid("proj", "vehicles\\c gun turret\\mp gun turret")
    ghostbolt_tag_id = gettagid("proj", "vehicles\\ghost\\ghost bolt")
    tankshot_tag_id = gettagid("proj", "vehicles\\scorpion\\bullet")
    tankblast_tag_id = gettagid("proj", "vehicles\\scorpion\\tank shell")
    warthogshot_tag_id = gettagid("proj", "vehicles\\warthog\\bullet")
    rifleshot_tag_id = gettagid("proj", "weapons\\assault rifle\\bullet")
    flame_tag_id = gettagid("proj", "weapons\\flamethrower\\flame")
    needlerfire_tag_id = gettagid("proj", "weapons\\needler\\mp_needle")
    pistolshot_tag_id = gettagid("proj", "weapons\\pistol\\bullet")
    plasmapistolbolt_tag_id = gettagid("proj", "weapons\\plasma pistol\\bolt")
    plasmariflebolt_tag_id = gettagid("proj", "weapons\\plasma rifle\\bolt")
    plasmarifleblast_tag_id = gettagid("proj", "weapons\\plasma rifle\\charged bolt")
    plasmacannonshot_tag_id = gettagid("proj", "weapons\\plasma_cannon\\plasma_cannon")
    rocket_tag_id = gettagid("proj", "weapons\\rocket launcher\\rocket")
    shotgunshot_tag_id = gettagid("proj", "weapons\\shotgun\\pellet")
    snipershot_tag_id = gettagid("proj", "weapons\\sniper rifle\\sniper bullet")

    -- Globals --
    global_distanceId = gettagid("jpt!", "globals\\distance")
    global_fallingId = gettagid("jpt!", "globals\\falling")

    objects[1] = { "cyborg", "bipd", cyborg_tag_id }
    objects[2] = { "camo", "eqip", camouflage_tag_id }
    objects[3] = { "health", "eqip", healthpack_tag_id }
    objects[4] = { "overshield", "eqip", overshield_tag_id }
    objects[5] = { "fnade", "eqip", fragnade_tag_id }
    objects[6] = { "pnade", "eqip", plasmanade_tag_id }
    objects[7] = { "shee", "vehi", banshee_tag_id }
    objects[8] = { "turret", "vehi", turret_tag_id }
    objects[9] = { "ghost", "vehi", ghost_tag_id }
    objects[10] = { "rhog", "vehi", rwarthog_tag_id }
    objects[11] = { "tank", "vehi", scorpion_tag_id }
    objects[12] = { "hog", "vehi", warthog_tag_id }
    objects[13] = { "rifle", "weap", assaultrifle_tag_id }
    objects[14] = { "ball", "weap", oddball_tag_id }
    objects[15] = { "flag", "weap", flag_tag_id }
    objects[16] = { "flamethrower", "weap", flamethrower_tag_id }
    objects[17] = { "needler", "weap", needler_tag_id }
    objects[18] = { "pistol", "weap", pistol_tag_id }
    objects[19] = { "ppistol", "weap", plasmapistol_tag_id }
    objects[20] = { "prifle", "weap", plasmarifle_tag_id }
    objects[21] = { "frg", "weap", plasmacannon_tag_id }
    objects[22] = { "rocket", "weap", rocketlauncher_tag_id }
    objects[23] = { "shotgun", "weap", shotgun_tag_id }
    objects[24] = { "sniper", "weap", sniper_tag_id }
    objects[25] = { "sheebolt", "proj", bansheebolt_tag_id }
    objects[26] = { "sheerod", "proj", bansheeblast_tag_id }
    objects[27] = { "turretbolt", "proj", turretfire_tag_id }
    objects[28] = { "ghostbolt", "proj", ghostbolt_tag_id }
    objects[29] = { "tankshot", "proj", tankshot_tag_id }
    objects[30] = { "tankshell", "proj", tankblast_tag_id }
    objects[31] = { "hogshot", "proj", warthogshot_tag_id }
    objects[32] = { "rifleshot", "proj", rifleshot_tag_id }
    objects[33] = { "flame", "proj", flame_tag_id }
    objects[34] = { "needlershot", "proj", needlerfire_tag_id }
    objects[35] = { "pistolshot", "proj", pistolshot_tag_id }
    objects[36] = { "ppistolbolt", "proj", plasmapistolbolt_tag_id }
    objects[37] = { "priflebolt", "proj", plasmariflebolt_tag_id }
    objects[38] = { "priflecbolt", "proj", plasmarifleblast_tag_id }
    objects[39] = { "rocketproj", "proj", rocket_tag_id }
    objects[40] = { "shottyshot", "proj", shotgunshot_tag_id }
    objects[41] = { "snipershot", "proj", snipershot_tag_id }
    objects[42] = { "fuelrodshot", "proj", plasmacannonshot_tag_id }
    objects[43] = { "falldamage", "jpt", global_fallingId }
    objects[44] = { "distance", "jpt", global_distanceId }
    objects[45] = { "cyb", "bipd", cyb_tag_id }
    objects[46] = { "carbine", "weap", carbine_tag_id }
    objects[47] = { "revsniper", "weap", revsniper_tag_id }
    objects[48] = { "covspiker", "weap", covspiker_tag_id }
    objects[49] = { "covpr", "weap", covplasmarifle_tag_id }
    objects[50] = { "covpp", "weap", covpp_tag_id }
    objects[51] = { "covbr", "weap", covbr_tag_id }
    objects[52] = { "covsmg", "weap", covsmg_tag_id }
    objects[53] = { "yohog", "vehi", yohog_tag_id }
    objects[54] = { "fhog", "vehi", fhog_tag_id }
end

function MainTimer(id, count)
    if count % 10 == 0 then
        for i = 0, 15 do
            if getplayer(i) then
                local ip = getip(i)
                if Ghost_Table[ip] == true then
                    applycamo(i, 1)
                elseif Ghost_Table[ip] and Ghost_Table[ip] > 0 then
                    applycamo(i, Ghost_Table[ip])
                    Ghost_Table[ip] = Ghost_Table[ip] -1
                elseif Ghost_Table[ip] then
                    if Ghost_Table[ip] <= 0 then
                        Ghost_Table[ip] = nil
                    end
                end
            end

        end
    end
    for i = 0, 15 do
        local m_player = getplayer(i)
        if m_player then
            local m_playerObjId = getplayerobjectid(i)
            if m_playerObjId then m_object = getobject(m_playerObjId) end
            if m_object then
                local id = resolveplayer(i)
                local x_aim = readfloat(m_object + 0x230)
                local y_aim = readfloat(m_object + 0x234)
                local z_aim = readfloat(m_object + 0x238)
                local z = readfloat(m_player + 0x100)
                local obj_forward = readfloat(m_object + 0x278)
                local obj_left = readfloat(m_object + 0x27C)
                if afk[id][1] == true then
                    afk[id][1] = x_aim
                    afk[id][2] = y_aim
                    afk[id][3] = z_aim
                    writebit(m_object + 0x10, 7, 1)
                elseif afk[id][1] then
                    if x_aim ~= afk[id][1] or y_aim ~= afk[id][2] or z_aim ~= afk[id][3] or obj_forward ~= 0 or obj_left ~= 0 then
                        writebit(m_object + 0x10, 7, 0)
                        privateSay(i, "You are no longer afk")
                        afk[id] = { }
                    else
                        writefloat(m_player + 0x100, z - 1000)
                    end
                elseif hidden[id] then
                    writefloat(m_player + 0x100, z - 1000)
                end
            end
        end
    end
    return true
    -- end
end

function multiteamtimer(id, count, player)
    local m_player = getplayer(player)
    if m_player and multiteam_vehicles then
        writebyte(m_player + 0x20, 0)
    end
    return false
end

function nadeTimer(id, count)
    for c = 0, 15 do
        if getplayer(c) then
            local m_objectId = getplayerobjectid(c)
            if m_objectId then
                local m_object = getobject(m_objectId)
                if m_object then
                    writebyte(m_object + 0x31E, 3)
                    writebyte(m_object + 0x31F, 3)
                end
            end
        end
    end
    if infammo then
        return true
    elseif infammo then
        return true
    end
end

function Readstring(address, length, endian)
    local char_table = { }
    local string = ""
    local offset = offset or 0x0
    if length == nil then
        if readbyte(address + offset + 1) == 0 and readbyte(address + offset) ~= 0 then
            length = 51000
        else
            length = 256
        end
    end
    for i = 0, length do
        if readbyte(address +(offset + i)) ~= 0 then
            table.insert(char_table, string.char(readbyte(address +(offset + i))))
        elseif i % 2 == 0 and readbyte(address + offset + i) == 0 then
            break
        end
    end
    for k, v in pairs(char_table) do
        if endian == 1 then
            string = v .. string
        else
            string = string .. v
        end
    end
    return string
end

function readtagname(address)
    local char_table = { }
    local i = 0
    local string = ""
    while readbyte(address + i) ~= 0 do
        table.insert(char_table, string.char(readbyte(address + i)))
        i = i + 1
    end
    for k, v in pairs(char_table) do
        string = string .. v
    end
    return string
end

function reloadadmins(id, count)
    local file = io.open(string.format("%s\\Admin.txt", profilepath), "r")
    if file then
        for line in file:lines() do
            local words = tokenizestring(line, ",")
            local count = #words
            if not Admin_Table[words[2]] then Admin_Table[words[2]] = { } end
            Admin_Table[words[2]].name = words[1]
            Admin_Table[words[2]].level = words[3]
            if count == 4 and tonumber(words[3]) then
                if not IpAdmins[words[4]] then IpAdmins[words[4]] = { } end
                IpAdmins[words[4]].name = words[1]
                IpAdmins[words[4]].level = words[3]
            end
        end
        file:close()
    end
    file = io.open(profilepath .. "\\IP Admins.txt", "r")
    if file then
        for line in file:lines() do
            local words = tokenizestring(line, ",")
            local count = #words
            if not IpAdmins[words[2]] then IpAdmins[words[2]] = { } end
            IpAdmins[words[2]].name = words[1]
            IpAdmins[words[2]].level = words[3]
        end
        file:close()
    end
    return false
end

function resetweapons(player)
    if getplayer(player) then
        local m_objectId = getplayerobjectid(player)
        if m_objectId then
            local m_object = getobject(m_objectId)
            if m_object then
                if getobject(readdword(m_object + 0x118)) then return end
                local x = readfloat(m_object + 0x5C)
                local y = readfloat(m_object + 0x60)
                local z = readfloat(m_object + 0x64)
                assignweapon(player, createobject(pistol_tag_id, 0, 60, false, x + 1.0, y, z + 2.0))
                assignweapon(player, createobject(assaultrifle_tag_id, 0, 60, false, x + 1.0, y, z + 2.0))
            end
        end
    end
end

function round(val, decimal)
    if (decimal) then
        return math.floor((val * 10 ^ decimal) + 0.5) /(10 ^ decimal)
    else
        return math.floor(val + 0.5)
    end
end

function rtvTimer(id, count)
    if gameend == true then return false end
    if count == 1 then
        RTV_Initiated = RTV_Timout
        RTV_TABLE = { }
        say("The current RTV has expired")
        return false
    else
        return true
    end
end

function pack(...)
    local arg = { ...}
    return arg
end

function portalgunTimer(id, count, arg)
    local m_object = arg[1]
    if count == 100 then
        return false
    end
    if m_object then
        local obj_x_velocity = readfloat(m_object + 0x68)
        if obj_x_velocity == 0 then
            local x = readfloat(m_object + 0x5C)
            local y = readfloat(m_object + 0x60)
            local z = readfloat(m_object + 0x64)
            local m_playerobjId = getplayerobjectid(arg[2])
            if m_playerobjId then
                movobjectcoords(m_playerobjId, x, y, z)
            end
            return false
        else
            return true
        end
    end
    return true
end
-----------------------------------------------------------------------------------------------------------
function say(message, script_prefix)
    if GAME == "PC" then
        phasor_say((script_prefix or default_script_prefix) .. " " .. message, false)
    else
        phasor_say(message, false)
    end
end
-----------------------------------------------------------------------------------------------------------
function privatesay(player, message, script_prefix)
    if GAME == "PC" then
        phasor_privatesay(player,(script_prefix or default_script_prefix) .. " " .. message, false)
    else
        phasor_privatesay(player, message, false)
    end
end
-----------------------------------------------------------------------------------------------------------
function Say(message, time, exception)
    time = time or 3
    for i = 0, 15 do
        if getplayer(i) and exception ~= i then
            privateSay(i, message, time)
        end
    end
end
-----------------------------------------------------------------------------------------------------------
function privateSay(player, message, time)
    local time = time or 3
    if message then
        sendconsoletext(player, message, time)
    end
end
-----------------------------------------------------------------------------------------------------------
function sendresponse(message, command, player, log)
    if message then
        if message == "" then
            return
        elseif type(message) == "table" then
            message = message[1]
        end
        player = tonumber(player)
        if command then
            if string.sub(command, 1, 1) == "/" then
                local arguments = { message, command, player }
                registertimer(0, "DelayMessage", arguments)
            elseif string.sub(command, 1, 1) == "\\" then
                local arguments = { message, command, player }
                registertimer(0, "DelayMessage", arguments)
            elseif tonumber(player) and player ~= nil and player ~= -1 and player >= 0 and player < 16 then
                sendconsoletext(player, message)
            end
            hprintf(message)
            if log ~= false and player ~= nil and player ~= -1 and player then
                cmdlog("Response to " .. getname(player) .. ": " .. message)
            end
        else
            hprintf("Internal Error Occurred Check the Command Script Errors log")
            cmderrors("Error Occurred at SendResponse: Information Available: " .. message)
        end
    end
end
-----------------------------------------------------------------------------------------------------------
function setscore(player, score)
    if tonumber(score) then
        if gametype == 1 then
            local m_player = getplayer(player)
            if score >= 0x7FFF then
                writeword(m_player + 0xC8, 0x7FFF)
            elseif score <= -0x7FFF then
                writeword(m_player + 0xC8, -0x7FFF)
            else
                writeword(m_player + 0xC8, score)
            end
        elseif gametype == 2 then
            if score >= 0x7FFFFFFF then
                writeword(slayer_globals + 0x40 + player * 4, 0x7FFFFFFF)
            elseif score <= -0x7FFFFFFF then
                writeword(slayer_globals + 0x40 + player * 4, -0x7FFFFFFF)
            else
                writeword(slayer_globals + 0x40 + player * 4, score)
            end
        elseif gametype == 3 then
            local oddball_game = readbyte(gametype_base + 0x8C)
            if oddball_game == 0 or oddball_game == 1 then
                if score * 30 >= 0x7FFFFFFF then
                    writeword(oddball_globals + 0x84 + player * 4, 0x7FFFFFFF)
                elseif score * 30 <= -0x7FFFFFFF then
                    writeword(oddball_globals + 0x84 + player * 4, -1 * 0x7FFFFFFF)
                else
                    writeword(oddball_globals + 0x84 + player * 4, score * 30)
                end
            else
                if score > 0x7FFFFC17 then
                    writeword(oddball_globals + 0x84 + player * 4, 0x7FFFFC17)
                elseif score <= -0x7FFFFC17 then
                    writeword(oddball_globals + 0x84 + player * 4, -0x7FFFFC17)
                else
                    writeword(oddball_globals + 0x84 + player * 4, score)
                end
            end
        elseif gametype == 4 then
            local m_player = getplayer(player)
            if score * 30 >= 0x7FFF then
                writeword(m_player + 0xC4, 0x7FFF)
            elseif score * 30 <= -0x7FFF then
                writeword(m_player + 0xC4, -0x7FFF)
            else
                writeword(m_player + 0xC4, score * 30)
            end
        elseif gametype == 5 then
            local m_player = getplayer(player)
            if score >= 0x7FFF then
                writeword(m_player + 0xC6, 0x7FFF)
            elseif score <= -0x7FFF then
                writeword(m_player + 0xC6, -0x7FFF)
            else
                writeword(m_player + 0xC6, score)
            end
        end
    end
end

function string.findchar(str, char)
    local chars = string.split(str, "")
    local indexes = { }
    for k, v in ipairs(chars) do
        if v == char then
            table.insert(indexes, k)
        end
    end
    return table.unpack(indexes)
end

function string.split(str, ...)

    local args = { ...}

    for k, v in ipairs(args) do
        if v == "" then
            local subs = { }
            for i = 1, string.len(str) do
                table.insert(subs, string.sub(str, i, i))
            end

            return subs
        end
    end

    local subs = { }
    local sub = ""
    for i = 1, string.len(str) do
        local bool
        local char = string.sub(str, i, i)
        for k, v in ipairs(args) do
            local delim = string.sub(str, i -(string.len(v) -1), i)
            if v == delim then
                bool = true
                sub = string.sub(sub, 1, string.len(sub) -(string.len(v) -1))
                if sub ~= "" then
                    table.insert(subs, sub)
                end
                sub = ""
                break
            end
        end

        if not bool then
            sub = sub .. char
        end

        if i == string.len(str) then
            table.insert(subs, sub)
        end
    end

    return subs
end

function string.wild(match, wild, case_sensative)
    if not case_sensative then
        match, wild = string.lower(match), string.lower(wild)
    end
    if string.sub(wild, 1, 1) == "?" then wild = string.gsub(wild, "?", string.sub(match, 1, 1), 1) end
    if string.sub(wild, string.len(wild), string.len(wild)) == "?" then wild = string.gsub(wild, "?", string.sub(match, string.len(match), string.len(match)), 1) end
    if not string.find(wild, "*") and not string.find(wild, "?") and wild ~= match then return false end
    if string.sub(wild, 1, 1) ~= string.sub(match, 1, 1) and string.sub(wild, 1, 1) ~= "*" then return false end
    if string.sub(wild, string.len(wild), string.len(wild)) ~= string.sub(match, string.len(match), string.len(match)) and string.sub(wild, string.len(wild), string.len(wild)) ~= "*" then return false end
    local substrings = string.split(wild, "*")
    local begin = 1
    for k, v in ipairs(substrings) do
        local sublength = string.len(v)
        local temp_begin = begin
        local temp_end = begin + sublength - 1
        local matchsub = string.sub(match, begin, temp_end)
        local bool
        repeat
            local wild = v
            local indexes = pack(string.findchar(wild, "?"))
            if #indexes > 0 then
                for _, i in ipairs(indexes) do
                    wild = string.gsub(wild, "?", string.sub(matchsub, i, i), 1)
                end
            end
            if matchsub == wild then
                bool = true
                break
            end
            matchsub = string.sub(match, temp_begin, temp_end)
            temp_begin = temp_begin + 1
            temp_end = temp_end + 1
        until temp_end >= string.len(match)
        if not bool then
            return false
        end
        begin = sublength + 1
    end
    return true
end

function SelectPlayer(team)
    local t = { }
    for i = 0, 15 do
        if getplayer(i) and getteam(i) == team then
            table.insert(t, i)
        end
    end
    if #t > 0 then
        return t[getrandomnumber(1, #t + 1)]
    end
    return nil
end

function settimelimit(value)
    if tonumber(value) then
        writedword(timelimit_address, tonumber(value))
        local time_passed = readdword(readdword(gametime_base) + 0xC)
        writedword(gametype_base + 0x78, 30 * 60 * value + time_passed)
    end
end

function Timer(id, count)
    if SPAM_MAX == nil then SPAM_MAX = 7 end
    if SPAM_TIMEOUT == nil then SPAM_TIMEOUT = 60 end
    for i = 0, 15 do
        if getplayer(i) then
            local ip = getip(i)
            if Spam_Table[ip] == nil then
                Spam_Table[ip] = 0
            end
            if Spam_Table[ip] < tonumber(SPAM_MAX) then
                if Spam_Table[ip] > 0 then
                    Spam_Table[ip] = Spam_Table[ip] -0.25
                end
            else
                say(getname(i) .. " has been muted for " .. SPAM_TIMEOUT .. " seconds for spamming...", false)
                hprintf(getname(i) .. " has been muted for " .. SPAM_TIMEOUT .. " seconds for spamming...")
                Spam_Table[ip] = -1
            end
            if Spam_Table[ip] == -1 then
                if SpamTimeOut_Table[ip] == nil then
                    SpamTimeOut_Table[ip] = tonumber(SPAM_TIMEOUT)
                else
                    SpamTimeOut_Table[ip] = SpamTimeOut_Table[ip] -1
                end
                if SpamTimeOut_Table[ip] == 0 then
                    say(getname(i) .. " has been un-muted!", false)
                    hprintf(getname(i) .. " has been un-muted!")
                    SpamTimeOut_Table[ip] = nil
                    Spam_Table[ip] = 0
                end
            end
        end
    end
    for k, v in pairs(IP_BanList) do
        if IP_BanList[k] ~= { } then
            for key, value in ipairs(IP_BanList[k]) do
                if tonumber(IP_BanList[k][key].time) then
                    IP_BanList[k][key].time = tonumber(IP_BanList[k][key].time)
                else
                    IP_BanList[k][key].time = -1
                end
                if IP_BanList[k][key].time > 0 then
                    IP_BanList[k][key].time = IP_BanList[k][key].time - 1
                    if IP_BanList[k][key].time == 0 then
                        table.remove(IP_BanList[k], key)
                    end
                end
            end
        end
    end
    for k, v in pairs(Mute_Banlist) do
        if Mute_Banlist[k] ~= { } then
            for key, value in ipairs(Mute_Banlist[k]) do
                if tonumber(Mute_Banlist[k][key].time) then
                    Mute_Banlist[k][key].time = tonumber(Mute_Banlist[k][key].time)
                else
                    Mute_Banlist[k][key].time = -1
                end
                if Mute_Banlist[k][key].time > 0 then
                    Mute_Banlist[k][key].time = Mute_Banlist[k][key].time - 1
                    if Mute_Banlist[k][key].time == 0 then
                        table.remove(Mute_Banlist[k], key)
                    end
                end
            end
        end
    end

    for k, v in pairs(IpRange_BanList) do
        if IpRange_BanList[k] ~= { } then
            for key, value in ipairs(IpRange_BanList[k]) do
                if tonumber(IpRange_BanList[k][key].time) then
                    IpRange_BanList[k][key].time = tonumber(IpRange_BanList[k][key].time)
                else
                    IpRange_BanList[k][key].time = -1
                end
                if IpRange_BanList[k][key].time > 0 then
                    IpRange_BanList[k][key].time = IpRange_BanList[k][key].time - 1
                    if IpRange_BanList[k][key].time == 0 then
                        table.remove(IpRange_BanList[k], key)
                    end
                end
            end
        end
    end
    return true
end

function Spawn(message, objname, objtype, mapId, player, type)
    vehid = 0
    local m = tokenizestring(message, " ")
    local count = #m
    if count == 2 then
        local m_playerObjId = getplayerobjectid(player)
        if m_playerObjId then
            local m_object = getobject(m_playerObjId)
            local m_vehicleId = readdword(m_object + 0x11C)
            if m_object then
                if isinvehicle(player) and m_vehicleId then
                    x, y, z = getobjectcoords(m_vehicleId)
                else
                    x, y, z = getobjectcoords(m_playerObjId)
                    local camera_x = readfloat(m_object + 0x230)
                    local camera_y = readfloat(m_object + 0x234)
                    x = x + camera_x * 2
                    y = y + camera_y * 2
                    z = z + 2
                end
                vehid = createobject(mapId, 0, 60, false, x + 1.0, y, z + 1.3)
                if type == "give" then
                    assignweapon(player, vehid)
                    sendresponse(objname .. " was given to " .. getname(player), message, player)
                elseif type == "spawn" then
                    sendresponse(objname .. " spawned at " .. getname(player) .. "'s location", message, player)
                elseif type == "enter" then
                    Vehicle_Drone_Table[player] = Vehicle_Drone_Table[player] or { }
                    table.insert(Vehicle_Drone_Table[player], vehid)
                    entervehicle(player, vehid, 0)
                    sendresponse(tostring(getname(player)) .. " was forced to enter a " .. tostring(objname), message, player)
                end
            else
                sendresponse("Sorry! - You cannot spawn objects while dead!", message, player)
            end
        else
            sendresponse("Sorry! - You cannot spawn objects while dead!", message, player)
        end
    elseif count >= 3 and count <= 6 then
        local players = getvalidplayers(m[3], player)
        if players then
            for i = 1, #players do
                if players[i] == nil then break end
                if getplayer(players[i]) then
                    local m_playerObjId = getplayerobjectid(players[i])
                    if m_playerObjId then
                        local m_object = getobject(m_playerObjId)
                        local m_vehicleId = readdword(m_object + 0x11C)
                        if m_object then
                            if isinvehicle(players[i]) and m_vehicleId and getobject(m_vehicleId) then
                                x, y, z = getobjectcoords(m_vehicleId)
                            else
                                x, y, z = getobjectcoords(m_playerObjId)
                                local camera_x = readfloat(m_object + 0x230)
                                local camera_y = readfloat(m_object + 0x234)
                                x = x + camera_x * 2
                                y = y + camera_y * 2
                                z = z + 2
                            end
                            if count == 3 then
                                vehid = createobject(mapId, 0, 60, false, x, y, z)
                                if objtype == "weap" and type == "give" then
                                    assignweapon(players[i], vehid)
                                    sendresponse("A " .. objname .. " was given to " .. getname(players[i]), message, player)
                                    sendresponse(getname(players[i]) .. " was given a " .. objname .. ".", "//", players[i])
                                elseif type == "spawn" then
                                    sendresponse("A " .. objname .. " was spawned at " .. getname(players[i]) .. "'s location!", message, player)
                                elseif type == "enter" then
                                    Vehicle_Drone_Table[players[i]] = Vehicle_Drone_Table[players[i]] or { }
                                    table.insert(Vehicle_Drone_Table[players[i]], vehid)
                                    entervehicle(players[i], vehid, 0)
                                    sendresponse(getname(players[i]) .. " was forced to enter a " .. objname, message, player)
                                end
                            elseif count == 4 then
                                if m[4] ~= 0 then
                                    for i = 1, m[4] do
                                        createobject(mapId, 0, 0, false, x, y, z)
                                    end
                                    sendresponse(m[4] .. " " .. objname .. "s spawned at " .. getname(players[i]) .. "'s location!", message, player)
                                    privatesay(players[i], objname .. " was spawned above you!")
                                else
                                    sendresponse("You didn't spawn anything!")
                                end
                            elseif count == 5 then
                                if m[4] ~= 0 then
                                    for i = 1, m[4] do
                                        createobject(mapId, 0, m[5], false, x, y, z)
                                    end
                                    sendresponse(m[4] .. " " .. objname .. "s spawned at " .. getname(players[i]) .. "'s location!", message, player)
                                    privatesay(players[i], objname .. " was spawned above you!")
                                else
                                    sendresponse("You didn't spawn anything!")
                                end
                            elseif count == 6 then
                                if m[4] ~= 0 then
                                    for i = 1, m[4] do
                                        createobject(mapId, 0, m[5], m[6], x, y, z)
                                    end
                                    sendresponse(m[4] .. " " .. objname .. "s spawned at " .. getname(players[i]) .. "'s location!", message, player)
                                    privatesay(players[i], objname .. " was spawned above you!")
                                else
                                    sendresponse("You didn't spawn anything!", message, player)
                                end
                            end
                        elseif type ~= "give" then
                            sendresponse("Unable to spawn next to " .. getname(players[i]) .. ". - The Player isn't alive!", message, player)
                        elseif type == "give" then
                            sendresponse("Unable to give " .. getname(players[i]) .. " a " .. objname .. ". - The Player isn't alive!", message, player)
                        end
                    end
                else
                    sendresponse("Player is nil.", message, player)
                end
            end

        else
            sendresponse("Error 005: Invalid Player!", message, player)
        end
    end
    return vehid
end

function spawngunTimer(id, count, arguments)
    local player = arguments[2]
    local m_object = arguments[1]
    if m_object then
        local x = readfloat(m_object + 0x5C)
        local y = readfloat(m_object + 0x60)
        local z = readfloat(m_object + 0x64)
        local odj = createobject(objspawnid[getip(player)], 0, 10, false, x, y, z + 0.6)
    end
    return false
end

function Stickman(id, count)
    if count == 1 then
        hprintf("    _._    ")
        hprintf("   / O \\   ")
        hprintf("   \\| |/   ")
        hprintf("O--+=-=+--O")
    elseif count == 2 then
        svcmd("cls")
        hprintf("   ,-O-,   ")
        hprintf("O--=---=--O")
        hprintf("    2-2    ")
        hprintf("    - -    ")
    elseif count == 3 then
        svcmd("cls")
        hprintf("   ,_O_,   ")
        hprintf("O--(---)--O")
        hprintf("    >'>    ")
        hprintf("    - -    ")
    elseif count == 4 then
        svcmd("cls")
        hprintf("   ._O_.   ")
        hprintf("O--<-+->--O")
        hprintf("     X     ")
        hprintf("    / \\    ")
        hprintf("   -   -   ")
    elseif count == 5 then
        svcmd("cls")
        hprintf("O--=-O-=--O")
        hprintf("    '-'    ")
        hprintf("     v     ")
        hprintf("    / )    ")
        hprintf("   ~  z    ")
    elseif count == 6 then
        svcmd("cls")
        hprintf("O--,---,--O")
        hprintf("   \\ O /   ")
        hprintf("    - -    ")
        hprintf("     -     ")
        hprintf("    // \\    ")
        hprintf("   =   =   ")
    elseif count == 7 then
        svcmd("cls")
        hprintf("O--=-O-=--O")
        hprintf("    '-'    ")
        hprintf("     v     ")
        hprintf("    / )    ")
        hprintf("   ~  z    ")
    elseif count == 8 then
        svcmd("cls")
        hprintf("   ._O_.   ")
        hprintf("O--<-+->--O")
        hprintf("     X     ")
        hprintf("    / \\    ")
        hprintf("   -   -   ")
    elseif count == 9 then
        svcmd("cls")
        hprintf("   ,_O_,   ")
        hprintf("O--(---)--O")
        hprintf("    >'>    ")
        hprintf("    - -    ")
    elseif count == 10 then
        svcmd("cls")
        hprintf("   ,-O-,   ")
        hprintf("O--=---=--O")
        hprintf("    2-2    ")
        hprintf("    - -    ")
    elseif count == 11 then
        svcmd("cls")
        hprintf("    _._    ")
        hprintf("   / O \\   ")
        hprintf("   \\| |//   ")
        hprintf("O--+=-=+--O")
    elseif count >= 12 then
        svcmd("cls")
        return false
    end
    return true
end

function todec(number)
    return tonumber(number, 16)
end

function timetoword(time)
    if time == -1 or time == "-1" then
        return -1
    elseif tonumber(time) then
        local returntime = ""
        local seconds = tonumber(time)
        local days = math.floor(seconds / 86400)
        seconds = seconds - days * 86400
        local hours = math.floor(seconds / 3600)
        seconds = seconds - hours * 3600
        local minutes = math.floor(seconds / 60)
        seconds = seconds - minutes * 60
        if seconds ~= 0 then
            returntime = seconds .. "s"
        end
        if minutes ~= 0 then
            if returntime == "" then
                returntime = minutes .. "m"
            else
                returntime = minutes .. "m " .. returntime
            end
        end
        if hours ~= 0 then
            if returntime == "" then
                returntime = hours .. "h"
            else
                returntime = hours .. "h " .. returntime
            end
        end
        if days ~= 0 then
            if returntime == "" then
                returntime = days .. "d"
            else
                returntime = days .. "d " .. returntime
            end
        end
        if returntime == "" then
            returntime = "0s"
        end
        return returntime
    else
        return -1
    end
end

function votekick(name, player)
    VoteKick_Table = { }
    votekick_allowed = true
    if not votekicktimeouttimer then
        votekicktimeouttimer = registertimer(60000, "votekicktimeoutTimer")
    end
    say("Kicking " .. name .. "")
    if votekick_action == "ban" then
        svcmd("sv_ban " .. player + 1 .. " 5m")
    else
        svcmd("sv_kick " .. player + 1)
    end
end

function votekicktimeoutTimer(id, count)
    VoteKickTimeout_Table = false
    say("Vote-Kick is now available!")
    return false
end

function wordtotime(time)
    if time then
        if tonumber(time) then
            return tonumber(time)
        else
            local timeban = 0
            local num = ""
            for i = 1, string.len(time) do
                local char = string.sub(time, i, i)
                if tonumber(char) then
                    num = num .. char
                else
                    local holder = 0
                    if char == "s" then
                        holder = tonumber(num)
                    elseif char == "m" then
                        holder = tonumber(num) * 60
                    elseif char == "h" then
                        holder = tonumber(num) * 60 * 60
                    elseif char == "d" then
                        holder = tonumber(num) * 60 * 60 * 24
                    else
                        holder = 0
                    end
                    if holder and timeban then
                        timeban = timeban + holder
                    else
                        if timeban then
                            timeban = timeban + 1
                        end
                    end
                    num = ""
                end
            end
            if timeban > 0 then
                return tonumber(timeban)
            end
        end
    else
        return -1
    end
end

function writewordsigned(address, word)
    value = tonumber(word)
    if value == nil then value = tonumber(word, 16) end
    if value and value > 0x7FFF then
        local max = 0xFFFF
        local difference = max - value
        value = -1 - difference
    end
    writeword(address, value)
end

function WriteChangeLog()
    local file = io.open("changelog_" .. Script_Version .. ".txt", "w")
    file:write("Document Name: Commands, v7.5\n")
    file:write("Credits to the original creator(s):\n")
    file:write("		AelitePrime, Wizard, and Nuggets.\n")
    file:write("		Base script created 'Smiley'.\n")
    file:write("1) Original Release: v4.2 by AelitePrime: Aug 3, 2013\n")
    file:write("2) Updated Version: v7.5 by Chalwk: 2014 - 2015\n")
    file:write("--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------\n")
    file:write("--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------\n")
    file:write("\n")
    file:write("CHANGE LOG: By Chalwk:\n")
    file:write("Added Script Prefix \n")
    file:write("\n")
    file:write("\n")
    file:write("\n")
    file:write("\n")
    file:write("\n")
    file:write("\n")
    file:write("\n")
    file:write("\n")
    file:write("\n")
    file:write("\n")
    file:write("\n")
    file:write("\n")
    file:write("\n")
    file:write("\n")
    file:write("\n")
    file:write("\n")
    file:write("\n")
    file:write("\n")
    file:write("\n")
    file:write("--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------\n")
    file:write("--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------\n")
    file:write("-- Added Time Limit Addresses. sv_time_cur is now compatible with Halo CE\n")
    file:write("-- Added the sendconsoletext overload\n")
    file:write("-- Added 'sv_hash_duplicates' command which enables/disables the checking of duplicate keys in the server.\n")
    file:write("-- Added 'sv_multiteam_vehicles' Enables/Disables the ability to enter a vehicle with another player in FFA.\n")
    file:write("\n")
    file:write("-- Modified all tables that used the hash for identication, and changed it to IP\n")
    file:write("\n")
    file:write("-- Fixed minor bug with votekick\n")
    file:write("-- Fixed issue with sv_superban\n")
    file:write("-- Fixed AntiCaps command. WARNING: If you use a chatfilter script. Load that script before this one.\n")
    file:write("-- Fixed issue with team play detection\n")
    file:write("-- Fixed minor bugs.\n")
    file:write("\n")
    file:write("--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------\n")
    file:write("Commands Version 4.1(Released July 23rd, 2013)\n")
    file:write("-- Update Reason: Bug fixes\n")
    file:write("--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------\n")
    file:write("\n")
    file:write("-- Fixed minor bugs\n")
    file:write("\n")
    file:write("--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------\n")
    file:write("Commands Version 4.0(Released July 21st, 2013)\n")
    file:write("-- Update Reason: make it compatible with new Phasor\n")
    file:write("--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------\n")
    file:write("\n")
    file:write("-- Added 'sv_addrcon' This gives you the ability to have more than one rcon.\n")
    file:write("-- Added 'sv_delrcon' Removes rcons from the rcon list.\n")
    file:write("-- Added 'sv_rconlist' Displays all available rcons\n")
    file:write("-- Added 'sv_iprangeban' Bans entire IP Range\n")
    file:write("-- Added 'sv_iprangeunban' Removes an IP from the banlist\n")
    file:write("-- Added 'sv_iprangebanlist' Shows all IP's banned\n")
    file:write("-- Added 'sv_read' command.\n")
    file:write("-- Added 'sv_load' shortcut for sv_script_load.\n")
    file:write("-- Added 'sv_unload' shortcut for sv_script_unload.\n")
    file:write("-- Added 'sv_resetplayer' and '/resetplayer' removes all troll command settings.\n")
    file:write("-- Added 'sv_damage' Increases player damage.\n")
    file:write("-- Added reason to sv_textban\n")
    file:write("-- Added Command_Balance function since sv_team_balance is not a command anymore for the moment.\n")
    file:write("\n")
    file:write("-- Modified Reason is said to the public\n")
    file:write("-- Modified Adminblocker the admin is notified if a command is being executed on them.\n")
    file:write("-- Modified AntiSpam changed from boolean to a type: all, players, off\n")
    file:write("-- Modified 'sv_commands' -> 'sv_cmds'\n")
    file:write("-- Modified 'sv_ipban' now accepts IP's'\n")
    file:write("-- Modified AFK detection. Works better\n")
    file:write("-- Modified NameBan. Banned names are changed to 'player' on join.\n")
    file:write("-- Modified Tbag Detection: Detects victim location. You must be near the victims death to be able to tbag him/her.\n")
    file:write("\n")
    file:write("-- Fixed most bugs with the new phasor\n")
    file:write("-- Fixed 'sv_scrimmode' \n")
    file:write("-- Fixed @ bug\n")
    file:write("-- Fixed AccessMerging bug when -1 was given to any other level other than 0\n")
    file:write("-- Fixed minor Bos Bug\n")
    file:write("-- Fixed setscore bug\n")
    file:write("\n")
    file:write("-- Removed sv_pinglist command\n")
    file:write("-- Removed sv_hash_check, sv_version, and sv_version_check. Phasor has them built in.\n")
    file:write("-- Removed Portal Blocking\n")
    file:write("-- Removed /setname until further notice\n")
    file:write("\n")
    file:write("--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------\n")
    file:write("Commands Version 3.0.1 (Released February 28th, 2013)\n")
    file:write("-- Update Reason: Mainly Bug Fixes\n")
    file:write("--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------\n")
    file:write("\n")
    file:write("-- Added sv_scrimmode\n")
    file:write("\n")
    file:write("-- Modified ipadminadd now accepts IP's\n")
    file:write("-- Modified 'sv_admin_add: Combined sv_admin_add and sv_admin_addh\n")
    file:write("\n")
    file:write("-- Fixed /e bug\n")
    file:write("-- Fixed SPAM_MAX and SPAM_TIMEOUT bugs\n")
    file:write("-- Fixed textban bugs\n")
    file:write("-- Fixed superban bugs\n")
    file:write("-- Fixed ipban bug\n")
    file:write("\n")
    file:write("--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------\n")
    file:write("Commands Version 3.0.0 (released February 11th, 2013)\n")
    file:write("-- Update Reason: Bug Fixes and New Features\n")
    file:write("--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------\n")
    file:write("\n")
    file:write("-- Added safe guards for the admin system.\n")
    file:write("-- Added Ping List command. Displays the Players ID, Name and Ping level.\n")
    file:write("-- Added System for no Hash and/or IP admins\n")
    file:write("-- Added a sv_login command so if you are using the System for no Hash and/or IP Admins people with rcon are able to use chat commands\n")
    file:write("-- Added a sv_status command. It will show the current status of Defaults.txt commands.\n")
    file:write("-- Added info shown to the sv_info command\n")
    file:write("-- Added 'sv_chatcommands' to enable or disable admin chat commands\n")
    file:write("-- Added 'sv_adminblocker' enables,disables or limits the abiliy of an admin to kick/ban another admin\n")
    file:write("-- Added 'sv_anticaps'  Enables or Disables the use of caps in the server\n")
    file:write("-- Added 'sv_antispam' Enables or Disables the AntiSpam system of the script\n")
    file:write("-- Added 'sv_spammax' Changes the max amount of messages that can be sent in 1 minute\n")
    file:write("-- Added 'sv_spamtimeout' Changes the time you are muted for spamming\n")
    file:write("-- Added a time amount that a player can be textbanned 'sv_textban [player] {time}'. if no time is set then the default is -1 which is forever.\n")
    file:write("-- Added a way to use any command without the 'sv_' Ex: 'sv_admin_add' can be written as 'admin_add' \n")
    file:write("-- Added a time amount that a player can be ipbanned 'sv_ipban [player] {time} {message}'. if no time is set then the default is -1 which is forever.\n")
    file:write("-- Added 'sv_bosplayers' to see the available players that can be banned on sight.\n")
    file:write("\n")
    file:write("-- Modified how Defaults.txt works. If a command is not specified in the Defaults.txt file it is set to default by the script so no errors occur during game.\n")
    file:write("-- Modified Tbag function\n")
    file:write("-- Modified ban, you are now able to send reason(s) for the ban which will be written a file.\n")
    file:write("-- Modified kick, you are now able to send reason(s) for the kick which will be written a file.\n")
    file:write("-- Modified Ipban, you are now able to send reason(s) for the ipban which will be written a file.\n")
    file:write("-- Modified Superban, you are now able to send reason(s) for the superban which will be written a file.\n")
    file:write("-- Modified Votekick. You can only votekick again after 1 minute has passed since last votekick.\n")
    file:write("-- Modified ChangeLevel. The coding for this command has been improved.\n")
    file:write("-- Modified GetHelp\n")
    file:write("\n")
    file:write("-- Fixed Ipban bug\n")
    file:write("-- Fixed the '/e' command.\n")
    file:write("-- Fixed the 'sv_unmute' command.\n")
    file:write("\n")
    file:write("-- Removed sv_command_type and all content related to it\n")
    file:write("-- Removed redundant code.\n")
    file:write("-- Renamed 'sv_sa_message' to 'sv_serveradmin_message'\n")
    file:write("-- Renamed 'sv_fj_message' to 'sv_firstjoin_message'\n")
    file:write("-- Renamed 'sv_wb_message' to 'sv_welcomeback_message'\n")
    file:write("\n")
    file:write("--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------\n")
    file:write("Commands Version 2.4.3 (released September 23rd,2012\n")
    file:write("-- Update Reason: Fixed issues with ServerChat Function.\n")
    file:write("--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------\n")
    file:write("\n")
    file:write("-- Fixed-- Fixed OnServerChat Function error caused Chat Commands to fail.\n")
    file:write("\n")
    file:write("--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------\n")
    file:write("Commands Version 2.4.2 (released August 29th,2012\n")
    file:write("-- Update Reason: Fixed issues from version 2.4.1 and new commands.\n")
    file:write("--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------\n")
    file:write("\n")
    file:write("-- Added a change admin level command. You can now change the level of an IP and/or Hash admin  level. 'sv_change_level'\n")
    file:write("-- Added a Command Type command. You can now change between the way Wizard setup his chat commands, and my way. 'sv_command_type'\n")
    file:write("-- Added a Command Type command to the default.txt\n")
    file:write("\n")
    file:write("-- Re-Added Private say command\n")
    file:write("-- Re-Added '/e' command.\n")
    file:write("-- Re-Added Nuke Command.\n")
    file:write("-- Re-Added SetName Command.\n")
    file:write("\n")
    file:write("-- Modified Tbag function\n")
    file:write("\n")
    file:write("-- Fixed 'sv_info' command error\n")
    file:write("-- Fixed OnServerChat, now you wont get 'You are not allowed to use this command' every time you type.\n")
    file:write("\n")
    file:write("--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------\n")
    file:write("Commands Version 2.4.1 (released August 22nd,2012\n")
    file:write("-- Update Reason: Fixed issues from version 2.4\n")
    file:write("--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------\n")
    file:write("\n")
    file:write("-- Fixed 'sv_players_more' issue.\n")
    file:write("-- Fixed 'sv_players' issue.\n")
    file:write("-- Fixed Chat Command issue. If you were admin, then you could do any In-Chat in the script. Check Manual for info on how to add new commands.\n")
    file:write("-- Fixed Command issue. If you were admin, then you could do any In-Console in the script. Check Manual for info on how to add new commands.\n")
    file:write("\n")
    file:write("-- Removed Restriction of Portal Blocking. Warning: Modded Maps with portals might cause the server to crash. Hope to fix soon.\n")
    file:write("\n")
    file:write("--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------\n")
    file:write("Commands Version 2.4 (released August 19th,2012\n")
    file:write("-- Update Reason: New Features, Fix minor bugs, Remove non-working commands(will be re-add later), and Organize the Script\n")
    file:write("--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------\n")
    file:write("\n")
    file:write("-- Added Admin Add Hash. You can now add people via hash. So you are able to add people without them being in the server. 'sv_admin_addh'. This is mostly used if you have 5 or more people you want to add at the same time. Another Script is needed to succesfully use this command.\n")
    file:write("-- Added a Portal Blocking Command. If someone is blocking a portal they will be killed. 'sv_pbdet'\n")
    file:write("-- Added a Private Messaging boolean for the @ in chat. 'sv_pvtmessage'\n")
    file:write("-- Added Private Messaging to the default.txt\n")
    file:write("-- Added a Tbagging function.\n")
    file:write("-- Added a Tbagging Boolean Command. 'sv_tbagdet'\n")
    file:write("-- Added Tbagging Command to the default.txt\n")
    file:write("-- Added Killing spree Notifications\n")
    file:write("-- Added a Killing spree Notification command 'sv_killspree'\n")
    file:write("-- Added Killing spree Notification to the default.txt\n")
    file:write("-- Added a 'Welcome back' message in OnPlayerJoin. It will only say it if you are not an IP/Hash Admin\n")
    file:write("-- Added a Welcome back message command. 'sv_welcomeback_message'\n")
    file:write("-- Added Welcome Back Message to the default.txt\n")
    file:write("-- Added a 'This is the players first time joining the server' message in OnPlayerJoin\n")
    file:write("-- Added a Command for Server Admin Message. 'sv_sa_message'\n")
    file:write("-- Added Server Admin message to the default.txt\n")
    file:write("-- Added a Command for First Joining Message 'sv_firstjoin_message'\n")
    file:write("-- Added First Joining Message to the default.txt\n")
    file:write("-- Added a Command for Unique Counting. 'sv_uniques_enabled'\n")
    file:write("-- Added Unique Counting to the default.txt\n")
    file:write("-- Added a 'sv_players_more' Command. This does the same function as 'sv_players' but it gives you more information on each player.\n")
    file:write("-- Added IP to the info Command.\n")
    file:write("\n")
    file:write("-- Fixed RTV Enabled Command \n")
    file:write("-- Fixed VoteKick Enabled Command \n")
    file:write("-- Fixed info command. \n")
    file:write("-- Fixed time current command. \n")
    file:write("-- Fixed Set Teleport Shortcut. 'sv_st' \n")
    file:write("-- Fixed Teleport Delete Shortcut. 'sv_t del'\n")
    file:write("\n")
    file:write("-- Modified 'sv_players' command. Now it only gives you Player ID, Player Name, and Player Team.\n")
    file:write("-- Modified 'sv_count' command. Now disables if 'sv_uniques_enabled' is disabled.\n")
    file:write("-- Modified Chat Commands: all commands can now be used in chat. Note: Some shortcuts have been transfered but not all.\n")
    file:write("-- Modified GetHelp Commnad\n")
    file:write("-- Modified List Command\n")
    file:write("\n")
    file:write("-- Removed 'sv_unban' command from the script. Caused the OnSeverCommand function to crash.\n")
    file:write("-- Removed Private say command\n")
    file:write("-- Removed '/e' command.\n")
    file:write("-- Removed Nuke Command.\n")
    file:write("-- Removed SetName Command.\n")
    file:write("\n")
    file:write("-- Access level crash fixes and a few other features\n")
    file:write("-- Organized all of the Functions\n")
    file:write("-- Commented all Main Functions. This will only show on the Commented version of the script\n")
    file:write("\n")
    file:write("--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------\n")
    file:write("Commands Version 2.3 (released June 13th 2012\n")
    file:write("Mainly fixed up the admin system\n")
    file:write("--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------\n")
    file:write("\n")
    file:write("-- Added a /crash [player] and a sv_crash [player] command. Do not use it when the game is ending... you've been warned...\n")
    file:write("-- Added a /scorelimit and a sv_scorelimit command\n")
    file:write("-- Added a /a del command.\n")
    file:write("-- Added sv_ipadminadd to the rcon\n")
    file:write("-- Added a patch that will allow new gametypes to be added without restarting the server\n")
    file:write("-- Added textbanning. It's like the mute command except it's a permanent\n")
    file:write("\n")
    file:write("-- Modified the AdminList command. Shows a lot more now.\n")
    file:write("\n")
    file:write("-- Fixed rcon commands so that the responses show up with the /e command\n")
    file:write("-- Fixed the ipban command (whoops)\n")
    file:write("-- Fixed a very small problem with the setcolor command.\n")
    file:write("-- Fixed up the timelimit command :)\n")
    file:write("-- Fixed IpAdmins. They can now use the rcon.\n")
    file:write("\n")
    file:write("-- This script no longer uses Phasor admins, if it sees that you are, it will delete all of them and add them to mine, so if you see Admin.txt\n")
    file:write("turned into Admins.txt, don't worry, it's supposed to do that.\n")
    file:write("-- This script enables CE devmode commands (cheat_deathless_player, cheat_medusa, etc)\n")
    file:write("-- IP admins no longer get removed when you unload the commands script\n")
    file:write("\n")
    file:write("--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------\n")
    file:write("Commands Version 2.201 (released on June 5th 2012)\n")
    file:write("This is mainly just a bug fix version\n")
    file:write("--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------\n")
    file:write("\n")
    file:write("-- Added a /setscore and sv_setscore command.\n")
    file:write("-- Added New functionality to /hax and /unhax\n")
    file:write("\n")
    file:write("-- Modified setkills, setassists, and setdeaths to work a little cleaner\n")
    file:write("\n")
    file:write("-- Fixed /commands to show all of the commands.\n")
    file:write("-- Fixed a weird problem with the /enter command (when you ejected it would crash your game)\n")
    file:write("-- Fixed /a list (i forgot to check for the /, i was only checking for \\a list, so /a list wouldn't work)\n")
    file:write("-- Fixed falldamage (and also made it so longer falls don't kill you)\n")
    file:write("-- Fixed /hide, when you leave and another person rejoins with your player number, it will no longer hide them (thank you mitch... lol)\n")
    file:write("-- Fixed a bug when loading this script first, it wouldn't let other scripts control the weapons being assigned on spawn (can't believe i didn't see it earlier, ty nuggets + others)\n")
    file:write("\n")
    file:write("-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------\n")
    file:write("Commands Version 2.2 (Released on June 1st 2012)\n")
    file:write("-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------\n")
    file:write("\n")
    file:write("-- Added unique player tracking. It will keep track of the number of unique players who joined the server\n")
    file:write("-- Added '/count' Get the number of unique players\n")
    file:write("-- Added /balance, it executes sv_teams_balance in console\n")
    file:write("-- Added sv_privatesay. Looks like i forgot the sv_command for that\n")
    file:write("-- Added private chat. Use @(player expression) to message someone\n")
    file:write("-- Added /setcolor. Only works in FFA gametypes.\n")
    file:write("-- Added namebanning to superban.\n")
    file:write("-- Added a \\nameban command.\n")
    file:write("-- Added ipadmin deleting\n")
    file:write("\n")
    file:write("--Modifed 'sv_map' made it so that the sv_map and /m loads the commands script by default\n")
    file:write("-- Modified the AdminList function to be a lot more useful\n")
    file:write("\n")
    file:write("-- Fixed Bugs\n")
    file:write("-- Fixed votekick.\n")
    file:write("-- Fixed /privatesay. It would only let you message one word before\n")
    file:write("-- Fixed ACCESS levels for the script. It kind of worked, but not really.\n")
    file:write("-- Fixed an issue with /timelimit and sv_time_cur\n")
    file:write("-- Fixed deathless glitch\n")
    file:write("\n")
    file:write("-- Removed some of the spam when the script loads (it was an easy way to accomplish what i wanted at the time)\n")
    file:write("\n")
    file:write("-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------\n")
    file:write("Commands Version 2.001\n")
    file:write("-- Fixed /ipadminadd \n")
    file:write("-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------\n")
    file:write("Commands Version 2.0(Released April 22nd, 2012)\n")
    file:write("This is pretty much a rewrite of the entire script. So many new features were added. So many that I don't even want to make this changelog. Anyway, I'm forcing myself to make it. So here it is:\n")
    file:write("-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------\n")
    file:write("\n")
    file:write("-- Added hash check manipulation. You can now disable or enable hash checking (meaning that cracked versions can join your server if its disabled, but that also means everyone is unbannable if they spoof their key (which most people don't know how to do).\n")
    file:write("-- Added sv_revoke and /revoke. The syntax is /revoke [player]. This will take away someone's admin who is currently in the server.\n")
    file:write("-- Added /os, this will give you an Overshield (syntax is /os [player])\n")
    file:write("-- Added a command to view all admins on the server, syntax is: /a list\n")
    file:write("-- Added a command to view the current admins in the server. Syntax is: /viewadmins\n")
    file:write("-- Added a command to view the server specs (processor speed, model name, manufacturer). Syntax is /specs, or sv_specs in console\n")
    file:write("-- Added another player expression. Now you are able to use 'random' as a player name So like '/k random' would kick a random person\n")
    file:write("-- Added version changing. You can change to any version of Halo. Syntax is: /version {version} or sv_version {version} in console.\n")
    file:write("-- Added version check removal. You can enable or disable version checking. Having this disabled means that any person on any version can join your server (please note that your server will only appear on the server you specify in the version command)\n")
    file:write("-- Added a Defaults.txt. This text file gets called on server startup.\n")
    file:write("-- Added a sv_commands and a /commands. This will show all the commands that exist for this script.\n")
    file:write("-- Added a /hide and a /unhide command, these will make you totally hidden from everyone else in the server. It also removes you from the scoreboard, however, it only works with players that join after you execute it. People in the server at the time that you use it will still see you on the scoreboard.\n")
    file:write("-- Added a parameter to '/spd'. Syntax is /spd [player] {speed}. Doing /spd [player] will show you their current speed.\n")
    file:write("-- Added another parameter to '/t'. Syntax is '/t list', this will show you the list of teleports for the map.\n")
    file:write("-- Added infinite nades to sv_infinite_ammo\n")
    file:write("-- Added a '/banlist' command to chat. This will show you the banlist.\n")
    file:write("-- Added an '/alias' command to chat. This will show aliases of the player you pick. Kinda glitchy, oxide's fault, not mine.\n")
    file:write("-- Added sv_rtv_needed [decimal 0 to 1]\n")
    file:write("-- Added sv_votekick_needed [decimal 0 to 1]\n")
    file:write("-- Added sv_rtv_enabled [true or false, 1 or 0]\n")
    file:write("-- Added sv_votekick_enabled [true or false, 1 or 0]\n")
    file:write("-- Added ipbanning. Syntax is sv_ipban, sv_ipbanlist, sv_ipunban, and for chat: /ipban, /ipbanlist, /ipunban.\n")
    file:write("-- Added 'sv_launch' and '/launch'. Syntax is 'sv_launch [player]' or '/launch [player]'\n")
    file:write("-- Added a control command. Syntax is 'sv_control [victim] [controller]' or '/c [victim] [controller]' in chat.\n")
    file:write("-- Added a privatesay command. Syntax is 'sv_privatesay [player] [message]' or '/privatesay [player] [message]' in chat\n")
    file:write("-- Added temp.txt managing, basically so values that you set the previous map won't be erased when the next map loads (like when you do sv_respawn_time 5, and it goes back to default everytime you reload the script)\n")
    file:write("-- Added ipadminadding. You can add admins via IP now. Syntax is sv_ipadminadd (player) (nickname) (level) or /ipadminadd (player) (nickname) (level) in chat.\n")
    file:write("-- Added: Now includes logging. This will log directly to commands.log in the log folder\n")
    file:write("-- Added: If you do not have an ACCESS file, this script will make one for you.\n")
    file:write("-- Added '/e' command.\n")
    file:write("\n")
    file:write("-- Modified /timelimit and sv_timelimit. It will change the ingame timelimit (time remaining) as well as the timelimit for every game after that. This still breaks with sv_reloadscripts.\n")
    file:write("-- Modified sv_afk was changed to 'sv_setafk'. Thought it was a better name for the command.\n")
    file:write("\n")
    file:write("-- Fixed /setname, it will change your name, but for others to see it it requires a rejoin.\n")
    file:write("-- Fixed the admin system, before you had to do sv_reloadscripts after you added someone, that's been fixed.\n")
    file:write("-- Fixed Access.ini not syncing with chat commands, meaning if you have sv_kick in your ACCESS level, you can now use /k in the chat.\n")
    file:write("-- Fixed a bug with /ammo, this now works correctly. Syntax is: /ammo [player] [type (1 or 2)] [ammo] or sv_setammo in console.\n")
    file:write("-- Fixed smiley's BOS commands, thanks to bvigil for telling me what it was supposed to do.\n")
    file:write("-- Fixed a bug with /tp and sv_teleport_pl, which were crashing when the other player was dead.\n")
    file:write("-- Fixed /setplasmas, thank you sanity for the notice...\n")
    file:write("-- Fixed a reported bug with /noweapons... I was never able to reproduce it, so I must have indirectly fixed it.\n")
    file:write("-- Fixed /info which would crash when you used a player expression that was not a number.\n")
    file:write("-- Fixed a couple of bugs with rtv and votekick (whoops)\n")
    file:write("-- Fixed a bug with 'sv_mute' and '/mute'. You can no longer mute admins.\n")
    file:write("-- Fixed /st. This will set a teleport location to wherever you are standing. Syntax is: /st [teleport name]\n")
    file:write("-- Fixed the spawngun. Syntax is /setmode (player) spawngun (object)\n")
    file:write("-- Fixed Smiley's BoS (Ban On Sight) system. I had to rewrite 80% of it to work with the new Phasor. It now also bans the person's IP.\n")
    file:write("\n")
    file:write("-- Sorry this took so long, it took a while to rewrite the whole script. Technically it's been done for a while, i was just waiting for Oxide to release phasor 059. But that won't happen until after june, and there's no way i'm keeping you all waiting. Hope you enjoy it.\n")
    file:write("\n")
    file:write("-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------\n")
    file:write("Commands Version 1.0\n")
    file:write("First Official Release (january or something)\n")
    file:write("-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------\n")
    file:write("\n")
    file:write("-- Script Created")
    file:write("\n")
    file:close()
end

function WriteLog(filename, value)
    local file = io.open(filename, "a")
    if file then
        local timestamp = os.date("%Y/%m/%d %H:%M:%S")
        local line = string.format("%s\t%s\n", timestamp, tostring(value))
        file:write(line)
        file:close()
    end
end

-- Start of SendConsoleText Script.

console = { }
console.__index = console
registertimer(100, "ConsoleTimer")
phasor_sendconsoletext = sendconsoletext

function sendconsoletext(player, message, time, order, align, func)
    console[player] = console[player] or { }
    local temp = { }
    temp.player = player
    temp.id = nextid(player, order)
    temp.message = message or ""
    temp.time = time or 8
    temp.remain = temp.time
    temp.align = align or "left"
    if type(func) == "function" then
        temp.func = func
    elseif type(func) == "string" then
        temp.func = _G[func]
    end
    console[player][temp.id] = temp
    setmetatable(console[player][temp.id], console)
    return console[player][temp.id]
end

function nextid(player, order)
    if not order then
        local x = 0
        for k, v in pairs(console[player]) do
            if k > x + 1 then
                return x + 1
            end

            x = x + 1
        end
        return x + 1
    else
        local original = order
        while console[player][order] do
            order = order + 0.001
            if order == original + 0.999 then break end
        end
        return order
    end
end

function getmessage(player, order)
    if console[player] then
        if order then
            return console[player][order]
        end
    end
end

function getmessages(player)
    return console[player]
end

function getmessageblock(player, order)
    local temp = { }
    for k, v in pairs(console[player]) do
        if k >= order and k < order + 1 then
            table.insert(temp, console[player][k])
        end
    end
    return temp
end

function console:getmessage()
    return self.message
end

function console:append(message, reset)
    if console[self.player] then
        if console[self.player][self.id] then
            if getplayer(self.player) then
                if reset then
                    if reset == true then
                        console[self.player][self.id].remain = console[self.player][self.id].time
                    elseif tonumber(reset) then
                        console[self.player][self.id].time = tonumber(reset)
                        console[self.player][self.id].remain = tonumber(reset)
                    end
                end
                console[self.player][self.id].message = message or ""
                return true
            end
        end
    end
end

function console:shift(order)
    local temp = console[self.player][self.id]
    console[self.player][self.id] = console[self.player][order]
    console[self.player][order] = temp
end

function console:pause(time)
    console[self.player][self.id].pausetime = time or 5
end

function console:delete()
    console[self.player][self.id] = nil
end

function ConsoleTimer(id, count)
    for i, _ in opairs(console) do
        if tonumber(i) then
            if getplayer(i) then
                for k, v in opairs(console[i]) do
                    if console[i][k].pausetime then
                        console[i][k].pausetime = console[i][k].pausetime - 0.1
                        if console[i][k].pausetime <= 0 then
                            console[i][k].pausetime = nil
                        end
                    else
                        if console[i][k].func then
                            if not console[i][k].func(i) then
                                console[i][k] = nil
                            end
                        end
                        if console[i][k] then
                            console[i][k].remain = console[i][k].remain - 0.1
                            if console[i][k].remain <= 0 then
                                console[i][k] = nil
                            end
                        end
                    end
                end
                if table.len(console[i]) > 0 then
                    local paused = 0
                    for k, v in pairs(console[i]) do
                        if console[i][k].pausetime then
                            paused = paused + 1
                        end
                    end
                    if paused < table.len(console[i]) then
                        local str = ""
                        for i = 0, 30 do
                            str = str .. " \n"
                        end
                        phasor_sendconsoletext(i, str)
                        for k, v in opairs(console[i]) do
                            if not console[i][k].pausetime then
                                if console[i][k].align == "right" or console[i][k].align == "center" then
                                    phasor_sendconsoletext(i, consolecenter(string.sub(console[i][k].message, 1, 78)))
                                else
                                    phasor_sendconsoletext(i, string.sub(console[i][k].message, 1, 78))
                                end
                            end
                        end
                    end
                end
            else
                console[i] = nil
            end
        end
    end
    return true
end

function consolecenter(text)
    if text then
        local len = string.len(text)
        for i = len + 1, 78 do
            text = " " .. text
        end
        return text
    end
end

function opairs(t)
    local keys = { }
    for k, v in pairs(t) do
        table.insert(keys, k)
    end
    table.sort(keys,
    function(a, b)
        if type(a) == "number" and type(b) == "number" then
            return a < b
        end
        an = string.lower(tostring(a))
        bn = string.lower(tostring(b))
        if an ~= bn then
            return an < bn
        else
            return tostring(a) < tostring(b)
        end
    end )
    local count = 1
    return function()
        if table.unpack(keys) then
            local key = keys[count]
            local value = t[key]
            count = count + 1
            return key, value
        end
    end
end

function table.len(t)
    local count = 0
    for k, v in pairs(t) do
        count = count + 1
    end
    return count
end

-- End of SendConsoleText Script.
function gethttpsize(u)
    local r, c, h = http.request { method = "HEAD", url = u }
    if c == 200 then
        return tonumber(h["content-length"])
    end
end

function getbyhttp(u, file)
    local save = ltn12.sink.file(file or io.stdout)
    -- Only Print Feedback if OutPut is not stdout
    if file then save = ltn12.sink.chain(stats(gethttpsize(u)), save) end
    local r, c, h, s = http.request { url = u, sink = save }
    if c ~= 200 then io.stderr:write(s or c, "\n") end
end