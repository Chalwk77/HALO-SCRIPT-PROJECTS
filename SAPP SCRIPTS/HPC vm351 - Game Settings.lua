--[[    
------------------------------------
Script Name: HPC vm351 - Game Settings

Copyright © 2016 Jericho Crosby <jericho.crosby227@gmail.com>

* IGN: Chalwk
* Written by Jericho Crosby
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
    -- register_callback(cb['EVENT_CAMP'],"OnPlayerCamp")
    if halo_type == "PC" then ce = 0x0 else ce = 0x40 end
    local network_struct = read_dword(sig_scan("F3ABA1????????BA????????C740??????????E8????????668B0D") + 3)
end

function OnScriptUnload()
    logo = nil
end

function OnPlayerCamp(PlayerIndex, CampKills)
    local CampKills = get_var(PlayerIndex, "$campkills")
    for i=1,16 do
        if(player_alive(i)) then
            if (CampKills == 2) then
            -- do something
            end
        end
    end
end

function OnNewGame()
    logo = nil
end

function OnGameEnd(PlayerIndex)
    logo = nil
    cprint("The game is ending...", 4+8)
    rprint(PlayerIndex, "Well done everyone. Good Game!")
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
    cprint("            - - |   P L A Y E R   A T T E M P T I N G   T O   J O I N   | - -")
    cprint("                 - - - - - - - - - - - - - - - - - - - - - - - - - - - -                    ")
    cprint("Player: " ..name, 2+8)
    cprint("CD Hash: " ..hash)
    cprint("IP Address: " ..ip)
    cprint("IndexID: " ..id)
end

function OnPlayerJoin(PlayerIndex)
    timer(delay, "WelcomeDelay", PlayerIndex)
    local timestamp = os.date("%A %d %B %Y - %X")
    cprint("Join Time: " ..timestamp)
    cprint("Status: connected successfully.")
    cprint("---------------------------------------------------------------------------------------------------")
    rprint(PlayerIndex, "|c-- CTF --")
    rprint(PlayerIndex, "|c5 Captures to Win")
end

function WelcomeDelay(PlayerIndex)
    execute_command("msg_prefix \"\"")
    say(PlayerIndex, "Welcome to {JC}-7 Snipers Dream Team Mod")
    say(PlayerIndex, "The original Premier & most Respected S.D.T.M server.")
    say(PlayerIndex, "Enjoy!")
    execute_command("msg_prefix \"** SERVER ** \"")
    timer(1000*10, "InformationBoard", PlayerIndex)
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
    if(Command == "history") then
        rprint(PlayerIndex, "{JC}-7 was formally known as {OZ}-4 Snipers Dream Team Mod.")
        rprint(PlayerIndex, "This server is proudly hosted and maintained by author and creator, Chalwk.")
        rprint(PlayerIndex, "Featuring:")
        rprint(PlayerIndex, " ")
        rprint(PlayerIndex, "| An arsenal of fantastic gameplay, original weapon mechanics & game settings.")
        rprint(PlayerIndex, "| Smart-Spawn-System, High-explosive sniper rounds w/splash Damage.")
        rprint(PlayerIndex, "| Modified pistols w/ability to fire blank (suppressed) bullets,")
        rprint(PlayerIndex, "and a clever coordination of strategically placed portals")
        rprint(PlayerIndex, "designed to give either team an advantage or disadvantage")
        rprint(PlayerIndex, "from various locations on the map + more!")
        rprint(PlayerIndex, "You can discover everything else in your own time.")
        rprint(PlayerIndex, " ")
        rprint(PlayerIndex, "Join us as we continue our journey through the depths that is")
        rprint(PlayerIndex, "the Premier & most Respected S.D.T.M server on Halo PC since 2009.")
        rprint(PlayerIndex, "A legacy that I would like to hold in high esteem an opportunity")
        rprint(PlayerIndex, "to say thank you to the community for supporting this server over the years.")
        rprint(PlayerIndex, "Now get out there and kill something! No Mercy.")
        rprint(PlayerIndex, "~ Chalwk.")
        return false
    else
        return true
    end
end

function OnPlayerChat(PlayerIndex, Message)
    local Message = string.lower(Message)
    if (Message == "/about") 
    or (Message == "/about ") 
    or (Message == "/info") 
    or (Message == "/info ")
    or (Message == "@about") 
    or (Message == "@about ") 
    or (Message == "@info") 
    or (Message == "@info ") then
        return false
    end
    if (Message == "/notices") then
        InfoBoardHandler(PlayerIndex)
        return false
    end
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