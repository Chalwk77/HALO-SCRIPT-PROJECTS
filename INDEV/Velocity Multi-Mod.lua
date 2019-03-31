--[[
--=====================================================================================================--
Script Name: Velocity Multi-Mod, for SAPP (PC & CE)

[!] INDEV (not ready for download)

Copyright (c) 2019, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE

* Written by Jericho Crosby (Chalwk)
--=====================================================================================================--
]]--

api_version = "1.12.0.0"
local settings = { }
-- Configuration [STARTS] ---------------------------------------
local function GameSettings()
    settings = {
        mod = {
            ["Admin Chat"] = {
                enabled = true,
                base_command = "achat",
                permission_level = 1,
                prefix = "[ADMIN CHAT]",
                restore = true,
                environment = "rcon",
                message_format = { "%prefix% %sender_name% [%index%] %message%" }
            },
            ["Alias System"] = {
                enabled = true,
                dir = "sapp\\alias.lua",
                base_command = "alias",
                permission_level = 1,
                use_timer = true,
                duration = 10,
                alignment = "l",
            },
            ["Console Logo"] = {
                enabled = true
            },
            ["Message Board"] = {
                enabled = true,
                duration = 2,
                alignment = "l",
                messages = {
                "Welcome to %server_name%, %player_name%", 
                "Message Board created by Chalwk (Jericho Crosby)",
                "https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS"
                }
            },
            ["Player List"] = {
                enabled = true,
                permission_level = 1,
                alignment = "l",
                command_aliases = {
                    "pl",
                    "players",
                    "playerlist",
                    "playerslist"
                }
            },
        },
        global = { 
            script_version = 1.00,
            beepOnJoin = true,
            check_for_updates = false,
            -- Do not Touch...
            player_data = {
                "Player: %name%",
                "CD Hash: %hash%",
                "IP Address: %ip_address%",
                "Index ID: %index_id%",
                "Privilege Level: %level%",
            -------------------------------
            },
        }
    }
end
-- Configuration [ENDS] -----------------------------------------

-- Tables used Globally
local velocity, player_info = { }, { }
local players = {
    ["Alias System"] = { },
    ["Message Board"] = { },
    ["Admin Chat"] = { },
}

-- String Library, Math Library, Table Library
local sub, gsub, find, lower, format, match, gmatch = string.sub, string.gsub, string.find, string.lower, string.format, string.match, string.gmatch
local floor = math.floor
local concat = table.concat

-- Global Booleans
local game_over

local function getServerName()
    local network_struct = read_dword(sig_scan("F3ABA1????????BA????????C740??????????E8????????668B0D") + 3)
    local sv_name = read_widestring(network_struct + 0x8, 0x42)
    return sv_name
end

-- Checks if the MOD being called is enabled in settings.
local function modEnabled(script, e)
    if (settings.mod[script].enabled) then
        return true
    elseif (e) and (e ~= -1 and e >= 1 and e < 16) then
        rprint(executor, "Command Failed. " .. script .. " is disabled")
    else
        cprint("Command Failed. " .. script .. " is disabled", 4+8)
    end
end

-- Returns the require permission level of the respective mod.
local function getPermLevel(script)
    return tonumber(settings.mod[script].permission_level)
end

local function getPlayerInfo(Player, ID)
    if player_present(Player) then
        if player_info[Player] ~= nil or player_info[Player] ~= {} then
            for key, _ in ipairs(player_info[Player]) do
                return player_info[Player][key][ID]
            end
        else
            return error('getPlayerInfo() -> Unable to get Player IP')
        end
    end
end

local function isConsole(e)
    if (e) then
        if (e ~= -1 and e >= 1 and e < 16) then
            return false
        else 
            return true
        end
    end
end

-- #Alias System ---------------------------------------------
local max_columns, max_results = 5, 100
local startIndex, endIndex = 1, max_columns
local spaces = 2
local alias, alias_results, shared = { }, { }, { }
local initialStartIndex, known_pirated_hashes
local function PreLoad()
    initialStartIndex = tonumber(startIndex)
    known_pirated_hashes = { }
    known_pirated_hashes = {
        "388e89e69b4cc08b3441f25959f74103",
        "81f9c914b3402c2702a12dc1405247ee",
        "c939c09426f69c4843ff75ae704bf426",
        "13dbf72b3c21c5235c47e405dd6e092d",
        "29a29f3659a221351ed3d6f8355b2200",
        "d72b3f33bfb7266a8d0f13b37c62fddb",
        "76b9b8db9ae6b6cacdd59770a18fc1d5",
        "55d368354b5021e7dd5d3d1525a4ab82",
        "d41d8cd98f00b204e9800998ecf8427e",
        "c702226e783ea7e091c0bb44c2d0ec64",
        "f443106bd82fd6f3c22ba2df7c5e4094",
        "10440b462f6cbc3160c6280c2734f184",
    }
end
--------------------------------------------------------------
-- #Message Board
local messageBoard = { }
local m_board = { }
local function set(Player, ip)
    m_board[ip] = { }
    local tab = settings.mod["Message Board"].messages
    for i = 1, #tab do
        if (tab[i]) then
            table.insert(m_board[ip], tab[i])
        end
    end
    for _, v in pairs(m_board[ip]) do
        for j = 1, #m_board[ip] do
            m_board[ip][j] = gsub(gsub(m_board[ip][j], "%%server_name%%", getServerName()), "%%player_name%%", get_var(Player, "$name"))
        end
    end
end

function messageBoard:show(Player, ip)
    set(Player, ip)
    players["Message Board"][ip] = {
        timer = 0,
        show = true
    }
end

function messageBoard:hide(PlayerIndex, ip)
    players["Message Board"][ip] = nil
    m_board[ip] = nil
    cls(PlayerIndex)
end
--------------------------------------------------------------
-- #Admin Chat
local adminchat, achat_status = {}, { }
local achat_data = {}
function adminchat:reset(ip)
    players["Admin Chat"][ip] = {
        adminchat = false,
        boolean = false,
    }
end
--------------------------------------------------------------

function OnScriptLoad()
    GameSettings()
    servername = getServerName()
    
    if (settings.global.check_for_updates) then
        getCurrentVersion(true)
    else
        cprint("[BGS] Current Version: " .. settings.global.script_version, 2 + 8)
    end
    register_callback(cb['EVENT_TICK'], "OnTick")

    register_callback(cb['EVENT_CHAT'], "OnPlayerChat")
    register_callback(cb['EVENT_COMMAND'], "OnServerCommand")

    register_callback(cb['EVENT_PREJOIN'], "OnPlayerPrejoin")
    register_callback(cb['EVENT_JOIN'], "OnPlayerJoin")
    register_callback(cb['EVENT_LEAVE'], "OnPlayerLeave")

    register_callback(cb['EVENT_GAME_START'], "OnNewGame")
    register_callback(cb['EVENT_GAME_END'], "OnGameEnd")
    
    if halo_type == "PC" then
        ce = 0x0
    else
        ce = 0x40
    end
    
    if modEnabled("Alias System") then
        local dir = settings.mod["Alias System"].dir
        checkFile(dir)
        resetAliasParams()
        PreLoad()
    end
    
    for i = 1, 16 do
        if player_present(i) then 
            local ip = get_var(i, "$ip")
            local level = tonumber(get_var(i, "$lvl"))
            -- #Message Board
            if modEnabled("Message Board") then
                if (players[ip]["Message Board"] ~= nil) then
                    messageBoard:hide(i, ip)
                end
            end
            -- #Admin Chat
            if modEnabled("Admin Chat") then
                if not (game_over) and tonumber(level) >= getPermLevel("Admin Chat") then
                    players[ip]["Admin Chat"].adminchat = false
                    players[ip]["Admin Chat"].boolean = false
                end
            end
        end
    end

    -- #Console Logo
    if (settings.mod["Console Logo"].enabled) then
        --noinspection GlobalCreationOutsideO
        function consoleLogo()
            -- Logo: ascii: 'kban'
            cprint("================================================================================", 2 + 8)
            cprint(os.date("%A, %d %B %Y - %X"), 6)
            cprint("")
            cprint("     '||'  '||'     |     '||'       ..|''||           ..|'''.| '||''''|  ", 4 + 8)
            cprint("      ||    ||     |||     ||       .|'    ||        .|'     '   ||  .    ", 4 + 8)
            cprint("      ||''''||    |  ||    ||       ||      ||       ||          ||''|    ", 4 + 8)
            cprint("      ||    ||   .''''|.   ||       '|.     ||       '|.      .  ||       ", 4 + 8)
            cprint("     .||.  .||. .|.  .||. .||.....|  ''|...|'         ''|....'  .||.....| ", 4 + 8)
            cprint("               ->-<->-<->-<->-<->-<->-<->-<->-<->-<->-<->-<->-<->-")
            cprint("                     " .. servername, 0+8)
            cprint("               ->-<->-<->-<->-<->-<->-<->-<->-<->-<->-<->-<->-<->-")
            cprint("")
            cprint("================================================================================", 2 + 8)
        end
        timer(50, "consoleLogo")
    end
end

function OnScriptUnload()
    for i = 1, 16 do
        if player_present(i) then 
            local ip = get_var(i, "$ip")
            local level = tonumber(get_var(i, "$lvl"))
            -- #Admin Chat
            if modEnabled("Admin Chat") then
                if not (game_over) and tonumber(level) >= getPermLevel("Admin Chat") then
                    players[ip]["Admin Chat"].adminchat = false
                    players[ip]["Admin Chat"].boolean = false
                end
            end
        end
    end
end

function OnNewGame()
    PreLoad()
    resetAliasParams()
    for i = 1, 16 do
        if player_present(i) then
            local ip = get_var(i, "$ip")
            local level = tonumber(get_var(i, "$lvl"))
            
            -- #Message Board
            if modEnabled("Message Board") then
                if (players[ip]["Message Board"] ~= nil) then
                    messageBoard:hide(i, ip)
                end
            end
                
            -- #Admin Chat
            if modEnabled("Admin Chat") then
                if not (game_over) and tonumber(level) >= getPermLevel("Admin Chat") then
                    players[ip]["Admin Chat"].adminchat = false
                    players[ip]["Admin Chat"].boolean = false
                end
            end
        end
    end
end

function OnGameEnd()
    resetAliasParams()
    for i = 1, 16 do
        if player_present(i) then 
            local ip = get_var(i, "$ip")
            
            -- #Message Board
            if modEnabled("Message Board") then
                if (players[ip]["Message Board"] ~= nil) then
                    messageBoard:hide(i, ip)
                end
            end
            
            -- #Admin Chat
            if modEnabled("Admin Chat") then
                local mod = players[ip]["Admin Chat"]
                local restore = settings.mod["Admin Chat"].restore
                if tonumber(level) >= getPermLevel("Admin Chat") then
                    if (restore) then
                        local bool
                        if (mod.adminchat) then
                            bool = "true"
                        else
                            bool = "false"
                        end
                        achat_status[ip] = bool
                        achat_data[achat_status] = achat_data[achat_status] or {}
                        table.insert(achat_data[achat_status], tostring(achat_status[ip]))
                    else
                        mod.adminchat = false
                        mod.boolean = false
                    end
                end
            end
        end
    end
end

function OnTick()
    for i = 1, 16 do
        if player_present(i) then
            local ip = get_var(i, "$ip")
            -- #Alias System
            if modEnabled("Alias System") then
                if (players["Alias System"][ip] and players["Alias System"][ip].trigger) then
                    players["Alias System"][ip].timer = players["Alias System"][ip].timer + 0.030
                    alias:show(i, ip, players["Alias System"][ip].total)
                    if players["Alias System"][ip].timer >= floor(settings.mod["Alias System"].duration) then
                        alias:reset(get_var(i, "$ip"))
                    end
                end
            end
            -- #Message Board
            if modEnabled("Message Board") then 
                if players["Message Board"][ip] and (players["Message Board"][ip].show) then
                    players["Message Board"][ip].timer = players["Message Board"][ip].timer + 0.030
                    cls(i)
                    rprint(i, "|" .. settings.mod["Message Board"].alignment .. " " .. m_board[ip][1])
                    if players["Message Board"][ip].timer >= math.floor(settings.mod["Message Board"].duration) then
                        messageBoard:hide(i, ip)
                    end
                end
            end
        end
    end
end

function OnPlayerPrejoin(PlayerIndex)
    if (settings.global.beepOnJoin == true) then
        os.execute("echo \7")
    end
    player_info[PlayerIndex] = {}
    cprint("________________________________________________________________________________", 2 + 8)
    cprint("Player attempting to connect to the server...", 5 + 8)
    -- #CONSOLE OUTPUT
    local ns = read_dword(sig_scan("F3ABA1????????BA????????C740??????????E8????????668B0D") + 3)
    local cns = ns + 0x1AA + ce + to_real_index(PlayerIndex) * 0x20
    local name, hash = read_widestring(cns, 12), get_var(PlayerIndex, "$hash")
    local ip, id, level = get_var(PlayerIndex, "$ip"), get_var(PlayerIndex, "$n"), tonumber(get_var(PlayerIndex, "$lvl"))

    -- Matching and replacing in case the OP decides to reorder the player_data table
    local a, b, c, d, e
    local tab = settings.global.player_data
    for i = 1, #tab do
        if tab[i]:match("%%name%%") then
            a = gsub(tab[i], "%%name%%", name)
        elseif tab[i]:match("%%hash%%") then
            b = gsub(tab[i], "%%hash%%", hash)
        elseif tab[i]:match("%%index_id%%") then
            d = gsub(tab[i], "%%index_id%%", id)
        elseif tab[i]:match("%%ip_address%%") then
            c = gsub(tab[i], "%%ip_address%%", ip)
        elseif tab[i]:match("%%level%%") then
            e = gsub(tab[i], "%%level%%", level)
        end
    end
    table.insert(player_info[PlayerIndex], { ["name"] = a, ["hash"] = b, ["ip"] = c, ["id"] = d, ["level"] = e })

    cprint(getPlayerInfo(PlayerIndex, "name"), 2 + 8)
    cprint(getPlayerInfo(PlayerIndex, "hash"), 2 + 8)
    cprint(getPlayerInfo(PlayerIndex, "ip"), 2 + 8)
    cprint(getPlayerInfo(PlayerIndex, "id"), 2 + 8)
    cprint(getPlayerInfo(PlayerIndex, "level"), 2 + 8)
end

function OnPlayerJoin(PlayerIndex)
    local name = get_var(PlayerIndex, "$name")
    local hash = get_var(PlayerIndex, "$hash")
    local id = get_var(PlayerIndex, "$n")
    local ip = get_var(PlayerIndex, "$ip")
    local level = getPlayerInfo(PlayerIndex, "level"):match("%d+")
    
    -- #CONSOLE OUTPUT
    if (player_info[PlayerIndex] ~= nil or player_info[PlayerIndex] ~= {}) then
        cprint("Join Time: " .. os.date("%A %d %B %Y - %X"), 2 + 8)
        cprint("Status: " .. name .. " connected successfully.", 5 + 8)
        cprint("________________________________________________________________________________", 2 + 8)
    end
    
    -- #Alias System
    if modEnabled("Alias System") then
        alias:add(name, hash)
        if (tonumber(level) >= getPermLevel("Alias System")) then
            alias:reset(ip)
            shared[PlayerIndex] = { }
        end
    end
    
    -- #Message Board
    if modEnabled("Message Board") then
        messageBoard:show(PlayerIndex, ip)
    end
    
    -- #Admin Chat
     if modEnabled("Admin Chat") then
        adminchat:reset(ip)
        local mod = players[ip]["Admin Chat"]
        local restore = settings.mod["Admin Chat"].restore
        if (tonumber(level) >= getPermLevel("Admin Chat")) then
            if (restore) then
                local args = stringSplit(tostring(achat_status[ip]), "|")
                if (args[2] ~= nil) then
                    if (args[2] == "true") then
                        rprint(PlayerIndex, "[reminder] Your admin chat is on!")
                        mod.adminchat = true
                        mod.boolean = true
                    else
                        mod.adminchat = false
                        mod.boolean = false
                    end
                end
            else
                mod.adminchat = false
                mod.boolean = false
            end
        end
    end
end

function OnPlayerLeave(PlayerIndex)
    local name = get_var(PlayerIndex, "$name")
    local hash = get_var(PlayerIndex, "$hash")
    local id = get_var(PlayerIndex, "$n")
    local ip = getPlayerInfo(PlayerIndex, "ip"):match("(%d+.%d+.%d+.%d+:%d+)")
    local level = getPlayerInfo(PlayerIndex, "level"):match("%d+")
    
    -- #CONSOLE OUTPUT
    cprint("________________________________________________________________________________", 4 + 8)
    if (player_info[PlayerIndex] ~= nil or player_info[PlayerIndex] ~= {}) then
        cprint(getPlayerInfo(PlayerIndex, "name"), 4 + 8)
        cprint(getPlayerInfo(PlayerIndex, "hash"), 4 + 8)
        cprint(getPlayerInfo(PlayerIndex, "ip"), 4 + 8)
        cprint(getPlayerInfo(PlayerIndex, "id"), 4 + 8)
        cprint(getPlayerInfo(PlayerIndex, "level"), 4 + 8)
        player_info[PlayerIndex] = nil
    end
    cprint("________________________________________________________________________________", 4 + 8)
    
    -- #Alias System
    if modEnabled("Alias System") then
        if (tonumber(level) >= getPermLevel("Alias System")) then
            alias:reset(ip)
            shared[PlayerIndex] = false
        end
    end
    
    -- #Message Board
    if modEnabled("Message Board") then
        messageBoard:hide(PlayerIndex, ip)
    end
    
    -- #Admin Chat
    if modEnabled("Admin Chat") then
        local restore = settings.mod["Admin Chat"].restore
        local mod = players[ip]["Admin Chat"]
        if tonumber(level) >= getPermLevel("Admin Chat") then
            if (restore) then
                local bool
                if (mod.adminchat) then
                    bool = "true"
                else
                    bool = "false"
                end
                achat_status[ip] = bool
                achat_data[achat_status] = achat_data[achat_status] or {}
                table.insert(achat_data[achat_status], tostring(achat_status[ip]))
            else
                mod.adminchat = false
                mod.boolean = false
            end
        end
    end
end

-- Used in OnServerCommand()
local function checkAccess(e, c, script)
    local access
    if (e ~= -1 and e >= 1 and e < 16) then
        if (tonumber(get_var(e, "$lvl")) >= getPermLevel(script)) then
            access = true
        else
            rprint(e, "Command failed. Insufficient Permission.")
            access = false
        end
    elseif (c) then
        access = true
    elseif not (c) then 
        cprint('This command cannot be executed from console', 4+8)
        access = false
    end
    return access
end

-- Used in OnServerCommand()
local function isOnline(t, e)
    if (t) then
        if (t > 0 and t < 17) then
            if player_present(t) then
                return true
            else
                rprint(e, "Command failed. Player not online.")
                return false
            end
        else
            rprint(e, "Invalid player id. Please enter a number between 1-16")
        end
    end
end

function OnPlayerChat(PlayerIndex, Message, type)
    local pl = tonumber(PlayerIndex)
    local level = tonumber(get_var(pl, "$lvl"))
    local name = get_var(PlayerIndex, "$name")
    local ip = get_var(pl, "ip")
    local response
    
    -- Used throughout OnPlayerChat()
    local message = stringSplit(Message)
    if (#message == 0) then
        return nil
    end
    
    -- #Chat IDs & Admin Chat
    local keyword
    
    if modEnabled("Chat IDs") or modEnabled("Admin Chat") then
        local ignore = settings.mod["Chat IDs"].ignore_list
        if (table.match(ignore, message[1])) then
            keyword = true
        else
            keyword = false
        end
    end
    
    -- #Admin Chat
    if modEnabled("Admin Chat", PlayerIndex) then
        local mod = players[ip]["Admin Chat"]
        local environment = settings.mod["Admin Chat"].environment
        local function AdminChat(Message)
            for i = 1, 16 do
                if player_present(i) and (level >= getPermLevel("Admin Chat")) then
                    if (environment == "rcon") then
                        rprint(i, "|l" .. Message)
                    elseif (environment == "chat") then
                        execute_command("msg_prefix \"\"")
                        say(i, Message)
                        execute_command("msg_prefix \" *  * SERVER *  * \"")
                    end
                end
            end
        end
        if (mod.adminchat) then
            if (level >= getPermLevel("Admin Chat")) then
                for c = 0, #message do
                    if message[c] then
                        if not (keyword) or (keyword == nil) then
                            if sub(message[1], 1, 1) == "/" or sub(message[1], 1, 1) == "\\" then
                                response = true
                            else
                                local strFormat = settings.mod["Admin Chat"].message_format[1]
                                local prefix = settings.mod["Admin Chat"].prefix
                                local Format = (gsub(gsub(gsub(gsub(strFormat,"%%prefix%%", prefix), "%%sender_name%%", name), "%%index%%", pl), "%%message%%", Message))
                                AdminChat(Format)
                                response = false
                            end
                        end
                        break
                    end
                end
            end
        end
    end
    return response
end

function OnServerCommand(PlayerIndex, Command)
    local command, args = cmdsplit(Command)
    local executor = tonumber(PlayerIndex)

    local TargetID, target_all_players, is_error
    local ip = get_var(executor, "$ip")
    local total = 0

    local pl
    local function validate_params()
        local function getplayers(arg, executor)
            local players = { }
            if arg == "me" then
                TargetID = executor
                table.insert(players, executor)
            elseif arg:match("%d+") then
                TargetID = tonumber(args[1])
                table.insert(players, arg)
            elseif arg == "*" or (arg == "all") then
                for i = 1, 16 do
                    if player_present(i) then
                        target_all_players = true
                        table.insert(players, i)
                    end
                end
            else
                rprint(executor, "Invalid player id")
                is_error = true
                return false
            end
            if players[1] then
                return players
            end
            players = nil
            return false
        end
        pl = getplayers(args[1], executor)
    end
    
    if (command == settings.mod["Alias System"].base_command) then
        if (checkAccess(executor, false, "Alias System")) then
            if modEnabled("Alias System", executor) then
                alias:reset(ip)
                if (args[1] ~= nil) then
                    is_error = false
                    validate_params()
                    if not (target_all_players) then
                        if not (is_error) and isOnline(TargetID, executor) then
                            aliasCmdRoutine(executor, TargetID, ip, settings.mod["Alias System"].use_timer)
                        end
                    else
                        rprint(executor, "Unable to check aliases from all players.")
                    end
                else
                    local base_command = settings.mod["Alias System"].base_command
                    rprint(executor, "Invalid syntax. Usage: /" .. base_command .. " [id | me ]")
                end
            end
        end
        return false
    end
    -- #Player List
    if modEnabled("Player List", executor) then
        local cmd_list = settings.mod["Player List"].command_aliases
        for _, v in pairs(cmd_list) do
            local cmds = stringSplit(v, ",")
            for i = 1, #cmds do
                if (command == cmds[i]) then
                    if (args[1] == nil) then
                        if (checkAccess(executor, true, "Player List")) then
                            velocity:listplayers(executor)
                        end
                    else
                        rprint(executor, "Invalid Syntax. Usage: /" .. command)
                    end
                    return false
                end
            end
        end
    end
    -- #Admin Chat
    if (command == settings.mod["Admin Chat"].base_command) then
        if (checkAccess(executor, false, "Admin Chat")) then
            if modEnabled("Alias System", executor) then
                if not isConsole(executor) then
                    if (checkAccess(executor, false, "Admin Chat")) then
                        local mod = players[ip]["Admin Chat"]
                        local param = args[1]
                        if (param == "on") or (param == "1") or (param == "true") then
                            if (mod.boolean ~= true) then
                                mod.adminchat = true
                                mod.boolean = true
                                rprint(PlayerIndex, "Admin Chat enabled.")
                                return false
                            else
                                rprint(PlayerIndex, "Admin Chat is already enabled.")
                                return false
                            end
                        elseif (param == "off") or (param == "0") or (param == "false") then
                            if (mod.boolean ~= false) then
                                mod.adminchat = false
                                mod.boolean = false
                                rprint(PlayerIndex, "Admin Chat disabled.")
                                return false
                            else
                                rprint(PlayerIndex, "Admin Chat is already disabled.")
                                return false
                            end
                        else
                            local base_command = settings.mod["Admin Chat"].base_command
                            rprint(PlayerIndex, "Invalid Syntax: Type /" .. base_command .. " on|off")
                            return false
                        end
                    else
                        rprint(PlayerIndex, "Insufficient Permission")
                        return false
                    end
                else
                    cprint("The Server cannot execute this command!", 4 + 8)
                end
            end
        end
        return false
    end
end

function velocity:listplayers(e)
    local header, cheader, ffa
    local count = 0
    local bool = true
    local alignment = settings.mod["Player List"].alignment
    if (getTeamPlay()) then
        header = "|" .. alignment .. " [ ID.    -    Name.    -    Team.    -    IP. ]"
        cheader = "ID.        Name.        Team.        IP."
    else
        ffa = true
        header = "|" .. alignment .. " [ ID.    -    Name.    -    IP. ]"
        cheader = "ID.        Name.        IP"
    end
    local str
    for i = 1, 16 do
        if player_present(i) then
            if (bool) then
                bool = false
                if not (isConsole(e)) then
                    rprint(e, header)
                else
                    cprint(cheader, 7+8)
                end
            end
            count = count + 1
            local id, name, team, ip = get_var(i, "$n"), get_var(i, "$name"), get_var(i, "$team"), get_var(i, "$ip")
            if not (ffa) then
                str = id .. ".         " .. name .. "   |   " .. team .. "   |   " .. ip
            else
                str = id .. ".         " .. name .. "   |   " .. ip
            end
            if not (isConsole(e)) then
                rprint(e, "|" .. alignment .. "     " .. str)
            else
                cprint(str, 5+8)
            end
        end
    end
    if (count == 0) and (isConsole(e)) then
        cprint("------------------------------------", 5+8)
        cprint("There are no players online", 4+8)
        cprint("------------------------------------", 5+8)
    end
end

-- #Alias System
function aliasCmdRoutine(executor, target, ip, use_timer)
    local aliases, content
    alias_results = { }
  
    players["Alias System"][ip].tHash = get_var(target, "$hash")
    players["Alias System"][ip].tName = get_var(target, "$name")
    
    local directory = settings.mod["Alias System"].dir
    local lines = lines_from(directory)
    for _, v in pairs(lines) do
        if (v:match(players["Alias System"][ip].tHash)) then
            aliases = v:match(":(.+)")
            content = stringSplit(aliases, ",")
            alias_results[#alias_results + 1] = content
        end
    end

    players["Alias System"][ip].eid = tonumber(get_var(executor, "$n"))
    players["Alias System"][ip].shared = false
    players["Alias System"][ip].check_pirated_hash = true

    for i = 1, max_results do
        if (alias_results[1][i]) then
            players["Alias System"][ip].total = players["Alias System"][ip].total + 1
        end
    end
    
    local total = players["Alias System"][ip].total
    if (use_timer) then
        players["Alias System"][ip].trigger = true
        players["Alias System"][ip].bool = true
    else
        alias:show(executor, ip, total)
    end
end

-- #Alias System
function alias:reset(ip)
    players["Alias System"][ip] = {
        eid = 0,
        timer = 0,
        total = 0,
        bool = false,
        trigger = false,
        shared = false,
        check_pirated_hash = false,
    }
end

-- #Alias System
function resetAliasParams()
    for i = 1, 16 do
        if player_present(i) then
            if (tonumber(get_var(i, "$lvl")) >= settings.mod["Alias System"].permission_level) then
                alias:reset(get_var(i, "$ip"))
            end
        end
    end
end

-- #Alias System
local function spacing(n, sep)
    sep = sep or ""
    local String, Seperator = "", ","
    for i = 1, n do
        if i == floor(n / 2) then
            String = String .. sep
        end
        String = String .. " "
    end
    return Seperator .. String
end

-- #Alias System
local function FormatTable(table, rowlen, space, delimiter)
    local longest = 0
    for _, v in ipairs(table) do
        local len = string.len(v)
        if len > longest then
            longest = len
        end
        end
    local rows = {}
    local row = 1
    local count = 1
    for k, v in ipairs(table) do
        if count % rowlen == 0 or k == #table then
            rows[row] = (rows[row] or "") .. v
        else
            rows[row] = (rows[row] or "") .. v .. spacing(longest - string.len(v) + space, delimiter)
        end
        if count % rowlen == 0 then
            row = row + 1
        end
        count = count + 1
    end
    return concat(rows)
end

-- #Alias System
function alias:align(player, table, target, total, pirated, name, alignment)
    cls(player)
    local function formatResults()
        local placeholder, row = { }

        for i = tonumber(startIndex), tonumber(endIndex) do
            if (table[1][i]) then
                placeholder[#placeholder + 1] = table[1][i]
                row = FormatTable(placeholder, max_columns, spaces)
            end
        end

        if (row ~= nil) then
            rprint(player, "|" .. alignment .. " " .. row)
        end

        for a in pairs(placeholder) do
            placeholder[a] = nil
        end
        
        startIndex = (endIndex + 1)
        endIndex = (endIndex + (max_columns))
    end

    while (endIndex < max_results + max_columns) do
        formatResults()
    end

    if (startIndex >= max_results) then
        startIndex = initialStartIndex
        endIndex = max_columns
    end
    rprint(player, " ")
    rprint(player, "|" .. alignment .. " " .. 'Showing (' .. total .. ' aliases) for: "' .. target .. '"')
    if (pirated) then
        rprint(player, "|" .. alignment .. " " .. name .. ' is using a pirated copy of Halo.')
    end
end

-- #Alias System
function alias:show(executor, ip, total)
    local target = players["Alias System"][ip].tHash
    local name = players["Alias System"][ip].tName
    local check_pirated_hash = players["Alias System"][ip].check_pirated_hash
    if (check_pirated_hash) then
        players["Alias System"][ip].check_pirated_hash = false
        for i = 1, #known_pirated_hashes do
            if (target == known_pirated_hashes[i]) then
                players["Alias System"][ip].shared = true
            end
        end
    end
    local alignment = settings.mod["Alias System"].alignment
    alias:align(executor, alias_results, target, total, players["Alias System"][ip].shared, name, alignment)
end

-- #Alias System
function alias:add(name, hash)
   
    local function containsExact(w,s)
        return select(2,s:gsub('^' .. w .. '%W+','')) +
             select(2,s:gsub('%W+' .. w .. '$','')) +
             select(2,s:gsub('^' .. w .. '$','')) +
             select(2,s:gsub('%W+' .. w .. '%W+','')) > 0
    end
   
    local found, proceed
    local dir = settings.mod["Alias System"].dir
    local lines = lines_from(dir)
    for _, v in pairs(lines) do
    
        if containsExact(hash, v) and containsExact(name, v) then
            proceed = true
        end
        
        if containsExact(hash, v) and not containsExact(name, v) then
            found = true

            local alias = v .. ", " .. name

            local fRead = io.open(dir, "r")
            local content = fRead:read("*all")
            fRead:close()

            content = gsub(content, v, alias)

            local fWrite = io.open(dir, "w")
            fWrite:write(content)
            fWrite:close()
        end
    end
    if not (found) and not (proceed) then
        local file = assert(io.open(dir, "a+"))
        file:write(hash .. ":" .. name .. "\n")
        file:close()
    end
end


-----------------------------------------------------------------------------------------------
-- FUNCTIONS USED THROUGHOUT

function lines_from(file)
    local lines = {}
    for line in io.lines(file) do
        lines[#lines + 1] = line
    end
    return lines
end

function checkFile(directory)
    local file = io.open(directory, "rb")
    if file then
        file:close()
        return true
    else
        local file = io.open(directory, "a+")
        if file then
            file:close()
            return true
        end
    end
end

function cls(PlayerIndex)
    if (PlayerIndex) then
        for _ = 1, 25 do
            rprint(PlayerIndex, " ")
        end
    end
end

function getTeamPlay()
    if (get_var(0, "$ffa") == "0") then
        return true
    end
end

function stringSplit(inp, sep)
    if (sep == nil) then
        sep = "%s"
    end
    local t, i = {}, 1
    for str in gmatch(inp, "([^" .. sep .. "]+)") do
        t[i] = str
        i = i + 1
    end
    return t
end

function table.match(table, value)
    for k, v in pairs(table) do
        if v == value then
            return k
        end
    end
end

function cmdsplit(str)
    local subs = {}
    local sub = ""
    local ignore_quote, inquote, endquote
    for i = 1, string.len(str) do
        local bool
        local char = string.sub(str, i, i)
        if char == " " then
            if (inquote and endquote) or (not inquote and not endquote) then
                bool = true
            end
        elseif char == "\\" then
            ignore_quote = true
        elseif char == "\"" then
            if not ignore_quote then
                if not inquote then
                    inquote = true
                else
                    endquote = true
                end
            end
        end

        if char ~= "\\" then
            ignore_quote = false
        end

        if bool then
            if inquote and endquote then
                sub = string.sub(sub, 2, string.len(sub) - 1)
            end

            if sub ~= "" then
                table.insert(subs, sub)
            end
            sub = ""
            inquote = false
            endquote = false
        else
            sub = sub .. char
        end

        if i == string.len(str) then
            if string.sub(sub, 1, 1) == "\"" and string.sub(sub, string.len(sub), string.len(sub)) == "\"" then
                sub = string.sub(sub, 2, string.len(sub) - 1)
            end
            table.insert(subs, sub)
        end
    end

    local cmd = subs[1]
    local args = subs
    table.remove(args, 1)

    return cmd, args
end

function read_widestring(address, length)
    local count = 0
    local byte_table = {}
    for i = 1, length do
        if read_byte(address + count) ~= 0 then
            byte_table[i] = string.char(read_byte(address + count))
        end
        count = count + 2
    end
    return concat(byte_table)
end

function getCurrentVersion(bool)
    local http_client
    local ffi = require("ffi")
    ffi.cdef [[
        typedef void http_response;
        http_response *http_get(const char *url, bool async);
        void http_destroy_response(http_response *);
        void http_wait_async(const http_response *);
        bool http_response_is_null(const http_response *);
        bool http_response_received(const http_response *);
        const char *http_read_response(const http_response *);
        uint32_t http_response_length(const http_response *);
    ]]
    http_client = ffi.load("lua_http_client")

    local function GetPage(URL)
        local response = http_client.http_get(URL, false)
        local returning = nil
        if http_client.http_response_is_null(response) ~= true then
            local response_text_ptr = http_client.http_read_response(response)
            returning = ffi.string(response_text_ptr)
        end
        http_client.http_destroy_response(response)
        return returning
    end

    local url = 'https://raw.githubusercontent.com/Chalwk77/HALO-SCRIPT-PROJECTS/master/INDEV/Velocity%20Multi-Mod.lua'
    local version = GetPage(url):match("script_version = (%d+.%d+)")

    if (bool == true) then
        if (tonumber(version) ~= settings.global.script_version) then
            cprint("============================================================================", 5 + 8)
            cprint("[BGS] Version " .. tostring(version) .. " is available for download.")
            cprint("Current version: v" .. settings.global.script_version, 5 + 8)
            cprint("============================================================================", 5 + 8)
        else
            cprint("[BGS] Version " .. settings.global.script_version, 2 + 8)
        end
    end
    return tonumber(version)
end

function report()
    cprint("--------------------------------------------------------", 5 + 8)
    cprint("Please report this error on github:", 7 + 8)
    cprint("https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/issues", 7 + 8)
    cprint("Script Version: " .. settings.global.script_version, 7 + 8)
    cprint("--------------------------------------------------------", 5 + 8)
end

function OnError()
    cprint(debug.traceback(), 4 + 8)
    timer(50, "report")
end
