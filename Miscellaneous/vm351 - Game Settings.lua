--[[    
------------------------------------
Script Name: vm315 - Game Settings, for SAPP (PC & CE)
    - Implementing API version: 1.10.0.0

Copyright © 2016 Jericho Crosby <jericho.crosby227@gmail.com>
All Rights Reserved.
You do not have permission to use this script.

* IGN: Chalwk
* Written by Jericho Crosby (Chalwk)
-----------------------------------
]]-- 
api_version = "1.11.0.0"
delay = 1000*7

function OnScriptLoad()
    logo = timer(50, "consoleLogo")
    register_callback(cb['EVENT_GAME_START'], "OnNewGame")
    register_callback(cb['EVENT_GAME_END'], "OnGameEnd")
    register_callback(cb['EVENT_PREJOIN'], "OnPlayerPrejoin")
    register_callback(cb['EVENT_JOIN'], "OnPlayerJoin")
    register_callback(cb['EVENT_LEAVE'], "OnPlayerLeave")
    register_callback(cb['EVENT_CHAT'], "OnPlayerChat")
    register_callback(cb['EVENT_COMMAND'],"OnServerCommand")
    if halo_type == "PC" then ce = 0x0 else ce = 0x40 end
    local network_struct = read_dword(sig_scan("F3ABA1????????BA????????C740??????????E8????????668B0D") + 3)
	if get_var(0, "$gt") ~= "n/a" then end		
end

function getobjetinteractionid(PlayerIndex)
	local m_player = get_player(PlayerIndex)
	if m_player ~= 0 then
		local ObjectId = read_dword(m_player + 0x24)
		return ObjectId
	end
	return nil
end

function OnScriptUnload()
    logo = nil
end

function OnNewGame()
    logo = nil
end

function OnGameEnd(PlayerIndex)
    logo = nil
    cprint("The game is ending...", 4+8)
    execute_command("msg_prefix \"\"")
    say_all("<>-<>-<>-<>-<>-<>-<>-<>-<>-<>-<>-<>")
    say_all("Well done everyone. Good Game!")
    say_all("<>-<>-<>-<>-<>-<>-<>-<>-<>-<>-<>-<>")
    execute_command("msg_prefix \"** SERVER ** \"")
end

function OnPlayerPrejoin(PlayerIndex)
    os.execute("echo \7")
    local network_struct = read_dword(sig_scan("F3ABA1????????BA????????C740??????????E8????????668B0D") + 3)
    local client_network_struct = network_struct + 0x1AA + ce + to_real_index(PlayerIndex) * 0x20
    local name = read_widestring(client_network_struct, 12)
    local hash = get_var(PlayerIndex, "$hash")
    local ip = get_var(PlayerIndex, "$ip")
    local id = get_var(PlayerIndex, "$n")
    cprint("---------------------------------------------------------------------------------------------------")
    cprint("              - - |   P L A Y E R   J O I N   | - -")
    cprint("     - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ")
    cprint("Player: " ..name, 2+8)
    cprint("CD Hash: " ..hash)
    cprint("IP Address: " ..ip)
    cprint("IndexID: " ..id)
end
function OnPlayerJoin(PlayerIndex)
    -- local name = get_var(PlayerIndex, "$name")
    -- if (tonumber(get_var(PlayerIndex,"$lvl"))) >= 0 then
        -- execute_command("msg_prefix \"\"")
        -- say_all("Server Admin: " .. name)
        -- execute_command("msg_prefix \"** SERVER ** \"")
    -- end
    local game_mode = get_var(0, "$mode")
    if (game_mode == "jc-c") then
        -- {JC}-7 Snipers Dream Team Mod
        timer(delay, "SDTM_WELCOME", PlayerIndex)
    else
        -- vm315 [PGA] Pro Gamers Arena
        timer(delay, "PGA_WELCOME", PlayerIndex)
    end
    local timestamp = os.date("%A %d %B %Y - %X")
    cprint("Join Time: " ..timestamp)
    cprint("Status: connected successfully.")
    cprint("---------------------------------------------------------------------------------------------------")
end

-- {JC}-7 Snipers Dream Team Mod
function SDTM_WELCOME(PlayerIndex)
    execute_command("msg_prefix \"\"")
    say(PlayerIndex, "Welcome to {ØZ}-4 Snipers Dream Team Mod")
    say(PlayerIndex, "A tribute to Skelito's original SDTM.")
    say(PlayerIndex, "Game On!")
    execute_command("msg_prefix \"** SERVER ** \"")
    --timer(1000*13, "Motto", PlayerIndex)
end

function Motto(PlayerIndex)
    rprint(PlayerIndex, "|cCompetition comes dealing with victory and loss.")
    rprint(PlayerIndex, "|cIn loss we need leadership and positive reflection to progress.")
    rprint(PlayerIndex, "|cIn victory we need to be humble and have compassion for those we have beaten.")
    rprint(PlayerIndex, "|cBrotherhood and unity in war - Game on!")
end
    
function nuke_announcement(PlayerIndex)
    execute_command("msg_prefix \"\"")
    say(PlayerIndex, "For every 15 consecutive kills, you will receive the NUKE LAUNCHER.")
    say(PlayerIndex, "Type /stats to see how many kills you need to receive it.")
    execute_command("msg_prefix \"** SERVER ** \"")
end

-- vm315 [PGA] Pro Gamers Arena
function PGA_WELCOME(PlayerIndex)
    execute_command("msg_prefix \"\"")
    say(PlayerIndex, "Welcome to [PGA] Pro Gamers Arena - Public Scrim Server")
    say(PlayerIndex, "An environment for the avid tactical gamer!")
    say(PlayerIndex, "Enjoy!")
    execute_command("msg_prefix \"** SERVER ** \"")
end

function InformationBoard(PlayerIndex)
    execute_command("msg_prefix \"\"")
    say(PlayerIndex, "For information and announcements, please type /notices")
    execute_command("msg_prefix \"** SERVER ** \"")
end

function InfoBoardHandler(PlayerIndex)
    execute_command("msg_prefix \"\"")
    say(PlayerIndex, "NOTICE - 1/3")
    say(PlayerIndex, "Type /history to learn about the legacy of this server.")
    execute_command("msg_prefix \"** SERVER ** \"")
    timer(delay, "StatsMessage", PlayerIndex)
end

function StatsMessage(PlayerIndex)
    execute_command("msg_prefix \"\"")
    say(PlayerIndex, "NOTICE - 2/3")
    say(PlayerIndex, "Hold Crouch(ctrl) + Action(e) at the same time to display your stats!")
    execute_command("msg_prefix \"** SERVER ** \"")
    timer(1000*7, "GameTracker", PlayerIndex)
end

function GameTracker(PlayerIndex)
    execute_command("msg_prefix \"\"")
    say(PlayerIndex, "NOTICE - 3/3")
    say(PlayerIndex, "Check our GameTracker page for scores & statistics monitoring:")
    say(PlayerIndex, "www.gametracker.com/server_info/66.55.137.220:2302")
    execute_command("msg_prefix \"** SERVER ** \"")
    timer(1000*7, "IfMissed", PlayerIndex)
end

function IfMissed(PlayerIndex)
    execute_command("msg_prefix \"\"")
    say(PlayerIndex, "If you missed these announcements, type /notices to view them again.")
    execute_command("msg_prefix \"** SERVER ** \"")
end

function OnPlayerLeave(PlayerIndex)
    local name = get_var(PlayerIndex, "$name")
    local hash = get_var(PlayerIndex, "$hash")
    local id = get_var(PlayerIndex, "$n")
    local ping = get_var(PlayerIndex, "$ping")
    local timestamp = os.date("%A %d %B %Y - %X")
    cprint("---------------------------------------------------------------------------------------------------")
    cprint(name.. " quit the game!", 4+8)
    cprint("CD Hash: " ..hash)
    cprint("IndexID: " ..id)
    cprint("Player Ping: " ..ping)
    cprint("Time: " ..timestamp)
    cprint("---------------------------------------------------------------------------------------------------")
    cprint("")
end

function consoleLogo()
    local network_struct = read_dword(sig_scan("F3ABA1????????BA????????C740??????????E8????????668B0D") + 3)
    servername = read_widestring(network_struct + 0x8, 0x42)
    local timestamp = os.date("%A, %d %B %Y - %X")
    -- Logo: ascii: 'kban'
    cprint("===================================================================================================", 2+8)
    cprint(timestamp, 6)
    cprint("")
    cprint("                  '||'                  ||     ..|'''.|                   .'|.   .", 4+8)
    cprint("                   ||    ....  ... ..  ...   .|'     '  ... ..   ....   .||.   .||.", 4+8)
    cprint("                   ||  .|...||  ||' ''  ||   ||          ||' '' '' .||   ||     ||", 4+8)
    cprint("                   ||  ||       ||      ||   '|.      .  ||     .|' ||   ||     ||", 4+8)
    cprint("               || .|'   '|...' .||.    .||.   ''|....'  .||.    '|..'|' .||.    '|.'", 4+8)
    cprint("                '''", 4+8)
    cprint("                      ->-<->-<->-<->-<->-<->-<->-<->-<->-<->-<->-<->-<->-")
    cprint("                                         Chalwk's Realm")
    cprint("                                  " .. servername)
    cprint("                      ->-<->-<->-<->-<->-<->-<->-<->-<->-<->-<->-<->-<->-")
    cprint("")
    cprint("===================================================================================================", 2+8)
end

function OnServerCommand(PlayerIndex, Command)
    Command = string.lower(Command)
    -- nothing to see
end

function OnPlayerChat(PlayerIndex, Message, type)
    local Message = string.lower(Message)
    if (Message == "/suicide") or (Message == "\\suicide") then
        execute_command("kill ", PlayerIndex)
        execute_command("msg_prefix \"\"")
        say_all("[R.I.P] " .. get_var(PlayerIndex, "$name") .. " committed suicide.")
        execute_command("msg_prefix \"** SERVER ** \"")
        return false
    end
    if (Message == "/st") or (Message == "\\st") then
            if (tonumber(get_var(PlayerIndex,"$lvl"))) >= 1 then
            execute_command("msg_prefix \"\"")
            execute_command("st ", PlayerIndex)
            say_all(get_var(PlayerIndex, "$name") .. " switched teams!")
            execute_command("msg_prefix \"** SERVER ** \"")
            return false
        end
    end
    if (Message == "/refill") or (Message == "\\refill") then
        if (tonumber(get_var(PlayerIndex,"$lvl"))) >= 1 then
            execute_command("msg_prefix \"\"")
            execute_command("ammo me 9999 1", PlayerIndex)
            execute_command("ammo me 9999 5", PlayerIndex)
            say(PlayerIndex, "Refilling your ammo, " .. get_var(PlayerIndex, "$name").."!")
            execute_command("msg_prefix \"** SERVER ** \"")
            return false
        end
    end
    if (Message == "/about") 
    or (Message == "/about ") 
    or (Message == "/info") 
    or (Message == "/info ")
    or (Message == "\\about") 
    or (Message == "\\about ") 
    or (Message == "\\info") 
    or (Message == "\\info ")
    or (Message == "@about") 
    or (Message == "@about ") 
    or (Message == "@info") 
    or (Message == "@info ") then
        say(PlayerIndex, "Sorry, that's private information!")
        return false
    end
    -- local game_mode = get_var(0, "$mode")
    -- if (game_mode == "jc-c") then
        -- if (Message == "/notices") then
            -- InfoBoardHandler(PlayerIndex)
            -- return false
        -- end
    -- end
end

function read_widestring(address, length)
    local count = 0
    local byte_table = {}
    for i = 1,length do
        if read_byte(address + count) ~= 0 then
            byte_table[i] = string.char(read_byte(address + count))
        end
        count = count + 2
    end
    return table.concat(byte_table)
end

function tokenizestring(inputstr, sep)
    if sep == nil then
        sep = "%s"
    end
    local t={} ; i=1
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
        t[i] = str
        i = i + 1
    end
    return t
end
