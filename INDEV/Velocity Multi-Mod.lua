--[[
--=====================================================================================================--
Script Name: Velocity Multi-Mod (v 1.07), for SAPP (PC & CE)

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
            ["Chat IDs"] = {
                enabled = true,
                global_format = { "%sender_name% [%index%]: %message%" },
                team_format = { "[%sender_name%] [%index%]: %message%" },
                use_admin_prefixes = false,
                trial_moderator = {
                    "[T-MOD] %sender_name% [%index%]: %message%",
                    "[T-MOD] [%sender_name%] [%index%]: %message%"
                },
                moderator = {
                    "[MOD] %sender_name% [%index%]: %message%",
                    "[MOD] [%sender_name%] [%index%]: %message%"
                },
                admin = {
                    "[ADMIN] %sender_name% [%index%]: %message%",
                    "[ADMIN] [%sender_name%] [%index%]: %message%"
                },
                senior_admin = {
                    "[S-ADMIN] %sender_name% [%index%]: %message%",
                    "[S-ADMIN] [%sender_name%] [%index%]: %message%"
                },
                ignore_list = {
                    "skip",
                }
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
            script_version = 1.07,
            beepOnJoin = true,
            check_for_updates = false,
            
            -- Mute Handler
            handlemutes = true,
            mute_dir = "sapp\\mutes.txt",
            default_mute_time = 525600,
            can_mute_admins = false,
            
            server_prefix = "**SERVER** ",
            
            plugin_commands = {
                bgs = {"velocity", -1},
                enable = {"enable", 1},
                disable = {"disable", 1},
                list = {"plugins", 1},
                mute = {"mute", 1},
                unmute = {"unmute", 1},
                mutelist = {"mutelist", 1},
                clearchat = {"clear", 1},
                garbage_collection ={"clean", 1},
            },
            
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

-- Mute Handler
local mute_duration = {}
local time_diff = {}
local muted = {}
local mute_timer = {}
local init_mute_timer = {}

local function getServerName()
    local network_struct = read_dword(sig_scan("F3ABA1????????BA????????C740??????????E8????????668B0D") + 3)
    local sv_name = read_widestring(network_struct + 0x8, 0x42)
    return sv_name
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

-- Checks if the MOD being called is enabled in settings.
local function modEnabled(script, e)
    if (settings.mod[script].enabled) then
        return true
    elseif (e) then
        respond(e, "Command Failed. " .. script .. " is disabled", "rcon", 4+8)
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

-- #Alias System ---------------------------------------------
local max_columns, max_results = 5, 100
local startIndex, endIndex = 1, max_columns
local spaces = 2
local alias, alias_results = { }, { } 
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
    printEnabled()
    if (settings.global.check_for_updates) then
        getCurrentVersion(true)
    else
        cprint("[VELOCITY] Current Version: " .. settings.global.script_version, 2 + 8)
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
        checkFile(settings.mod["Alias System"].dir)
        resetAliasParams()
        PreLoad()
    end
    
    if (settings.global.handlemutes) then
        checkFile(settings.global.mute_dir)
    end
    
    for i = 1, 16 do
        if player_present(i) then 
            local ip = get_var(i, "$ip")
            local level = tonumber(get_var(i, "$lvl"))
            -- #Message Board
            if modEnabled("Message Board") then
                if (players["Message Board"][ip] ~= nil) then
                    messageBoard:hide(i, ip)
                end
            end
            -- #Admin Chat
            if modEnabled("Admin Chat") then
                if not (game_over) and tonumber(level) >= getPermLevel("Admin Chat") then
                    players["Admin Chat"][ip].adminchat = false
                    players["Admin Chat"][ip].boolean = false
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
            cprint("                     " .. getServerName(), 0+8)
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
                    players["Admin Chat"][ip].adminchat = false
                    players["Admin Chat"][ip].boolean = false
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
                if (players["Message Board"][ip] ~= nil) then
                    messageBoard:hide(i, ip)
                end
            end
                
            -- #Admin Chat
            if modEnabled("Admin Chat") then
                if not (game_over) and tonumber(level) >= getPermLevel("Admin Chat") then
                    players["Admin Chat"][ip].adminchat = false
                    players["Admin Chat"][ip].boolean = false
                end
            end
        end
    end
end

function OnGameEnd()
    -- Prevents displaying chat ids when the game is over.
    -- Otherwise map voting breaks.
    game_over = true
    
    resetAliasParams()
    for i = 1, 16 do
        if player_present(i) then 
            local ip = get_var(i, "$ip")
            
            -- #Message Board
            if modEnabled("Message Board") then
                if (players["Message Board"][ip] ~= nil) then
                    messageBoard:hide(i, ip)
                end
            end
            
            -- #Admin Chat
            if modEnabled("Admin Chat") then
                local mod = players["Admin Chat"][ip]
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
            
            -- SAPP | Mute Handler
            if (settings.global.handlemutes == true) then
                if (muted[tonumber(i)] == true) then
                    local name, hash = get_var(i, "$name"), get_var(i, "$hash")
                    local ip = getPlayerInfo(i, "ip"):match("(%d+.%d+.%d+.%d+:%d+)")
                    local file_name = settings.global.mute_dir
                    local file = io.open(file_name, "r")
                    file:close()
                    local lines = lines_from(file_name)
                    for k, v in pairs(lines) do
                        if k ~= nil then
                            if v:match(ip) and v:match(hash) then
                                local updated_entry = ip .. ", " .. hash .. ", " .. name .. ", ;" .. time_diff[tonumber(i)]
                                local f1 = io.open(file_name, "r")
                                local content = f1:read("*all")
                                f1:close()
                                content = gsub(content, v, updated_entry)
                                local f2 = io.open(file_name, "w")
                                f2:write(content)
                                f2:close()
                            end
                        end
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
            
            -- SAPP | Mute Handler
            if (settings.global.handlemutes) then
                if (init_mute_timer[tonumber(i)]) then

                    local hash = get_var(i, "$hash")
                    local ip = getPlayerInfo(i, "ip"):match("(%d+.%d+.%d+.%d+:%d+)")
                    local entry = ip .. ", " .. hash

                    mute_timer[entry].timer = mute_timer[entry].timer + 0.030

                    local minutes = secondsToTime(mute_timer[entry].timer, 4)
                    local mute_time = (mute_duration[tonumber(i)]) - floor(minutes)
                    time_diff[tonumber(i)] = mute_time

                    if (mute_time <= 0) then
                        time_diff[tonumber(i)] = 0
                        muted[tonumber(i)] = false
                        init_mute_timer[tonumber(i)] = false
                        removeEntry(ip, hash, i)
                        rprint(i, "Your mute time has expired.")
                    end
                end
            end
            
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
                    respond(i, "|" .. settings.mod["Message Board"].alignment .. " " .. m_board[ip][1], "rcon")
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
    
    -- SAPP | Mute Handler
    if not (settings.global.handlemutes) then
        muted[tonumber(PlayerIndex)] = false or nil
    else
    
        local entry = ip .. ", " .. hash
        mute_timer[entry] = {}
        mute_timer[entry].timer = 0
        
        local file_name = settings.global.mute_dir
        local stringToMatch = ip .. ", " .. hash
        local lines = lines_from(file_name)
        for _, v in pairs(lines) do
            if v:match(stringToMatch) then
                local timeFound = match(v, (";(.+)"))
                local words = stringSplit(timeFound, ", ")
                mute_duration[tonumber(PlayerIndex)] = tonumber(words[1])
                muted[tonumber(PlayerIndex)] = true
                if (mute_duration[tonumber(PlayerIndex)] == settings.global.default_mute_time) then
                    rprint(PlayerIndex, "You are muted permanently.")
                else
                    init_mute_timer[tonumber(PlayerIndex)] = true
                    rprint(PlayerIndex, "You were muted! Time remaining: " .. mute_duration[tonumber(PlayerIndex)] .. " minute(s)")
                end
            else
                mute_duration[tonumber(PlayerIndex)] = 0
                muted[tonumber(PlayerIndex)] = false
                init_mute_timer[tonumber(PlayerIndex)] = false
            end
        end
    end
    
    -- #Alias System
    if modEnabled("Alias System") then
        alias:add(name, hash)
        if (tonumber(level) >= getPermLevel("Alias System")) then
            alias:reset(ip)
        end
    end
    
    -- #Message Board
    if modEnabled("Message Board") then
        messageBoard:show(PlayerIndex, ip)
    end
    
    -- #Admin Chat
     if modEnabled("Admin Chat") then
        local restore = settings.mod["Admin Chat"].restore
        if (tonumber(level) >= getPermLevel("Admin Chat")) then
            adminchat:reset(ip)
            local mod = players["Admin Chat"][ip]
            if (restore) then
                local args = stringSplit(tostring(achat_status[ip]), "|")
                if (args[2] ~= nil) then
                    if (args[2] == "true") then
                        respond(PlayerIndex, "[reminder] Your admin chat is on!", "rcon")
                        mod.adminchat = true
                        mod.boolean = true
                    else
                        mod.adminchat = false
                        mod.boolean = false
                    end
                end
            else
                players["Admin Chat"][ip].adminchat = false
                players["Admin Chat"][ip].boolean = false
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
    
    -- SAPP | Mute Handler
    if (settings.global.handlemutes) then
        if (muted[tonumber(PlayerIndex)] == true) then
            muted[tonumber(PlayerIndex)] = false
            local file_name = settings.global.mute_dir
            local file = io.open(file_name, "r")
            file:close()
            local lines = lines_from(file_name)
            for k, v in pairs(lines) do
                if k ~= nil then
                    if v:match(ip) and v:match(hash) then
                        local updated_entry = ip .. ", " .. hash .. ", " .. name .. ", ;" .. time_diff[tonumber(PlayerIndex)]
                        local f1 = io.open(file_name, "r")
                        local content = f1:read("*all")
                        f1:close()
                        content = gsub(content, v, updated_entry)
                        local f2 = io.open(file_name, "w")
                        f2:write(content)
                        f2:close()
                    end
                end
            end
        end
    end
    
    -- #Alias System
    if modEnabled("Alias System") then
        if (tonumber(level) >= getPermLevel("Alias System")) then
            alias:reset(ip)
        end
    end
    
    -- #Message Board
    if modEnabled("Message Board") then
        messageBoard:hide(PlayerIndex, ip)
    end
    
    -- #Admin Chat
    if modEnabled("Admin Chat") then
        local restore = settings.mod["Admin Chat"].restore
        local mod = players["Admin Chat"][ip]
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

function OnPlayerChat(PlayerIndex, Message, type)
    local id = tonumber(PlayerIndex)
    local level = tonumber(get_var(id, "$lvl"))
    local name = get_var(PlayerIndex, "$name")
    local ip = get_var(id, "$ip")
    local response
    
    -- SAPP | Mute Handler
    if (settings.global.handlemutes) then
        if (muted[tonumber(PlayerIndex)] == true) then
            if (mute_duration[tonumber(PlayerIndex)] == settings.global.default_mute_time) then
                rprint(PlayerIndex, "You are muted permanently.")
            else
                rprint(PlayerIndex, "You are muted! Time remaining: " .. mute_duration[tonumber(PlayerIndex)] .. " minute(s)")
            end
            return false
        end
    end
    
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
        local mod = players["Admin Chat"][ip]
        local environment = settings.mod["Admin Chat"].environment
        local function AdminChat(Message)
            for i = 1, 16 do
                if player_present(i) and (level >= getPermLevel("Admin Chat")) then
                    if (environment == "rcon") then
                        respond(i, "|l" .. Message, "rcon")
                    elseif (environment == "chat") then
                        execute_command("msg_prefix \"\"")
                        respond(i, Message, "chat")
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
                                local Format = (gsub(gsub(gsub(gsub(strFormat,"%%prefix%%", prefix), "%%sender_name%%", name), "%%index%%", id), "%%message%%", Message))
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
    -- #Chat IDs
    if modEnabled("Chat IDs", PlayerIndex) then
        if not (game_over) and not (muted[tonumber(PlayerIndex)]) then

            -- GLOBAL FORMAT
            local GlobalDefault = settings.mod["Chat IDs"].global_format[1]
            local Global_TModFormat = settings.mod["Chat IDs"].trial_moderator[1]
            local Global_ModFormat = settings.mod["Chat IDs"].moderator[1]
            local Global_AdminFormat = settings.mod["Chat IDs"].admin[1]
            local Global_SAdminFormat = settings.mod["Chat IDs"].senior_admin[1]

            --TEAM FORMAT
            local TeamDefault = settings.mod["Chat IDs"].team_format[1]
            local Team_TModFormat = settings.mod["Chat IDs"].trial_moderator[2]
            local Team_ModFormat = settings.mod["Chat IDs"].moderator[2]
            local Team_AdminFormat = settings.mod["Chat IDs"].admin[2]
            local Team_SAdminFormat = settings.mod["Chat IDs"].senior_admin[2]
            
            -- Permission Levels
            local tmod_perm = settings.mod["Chat IDs"].trial_moderator.lvl
            local mod_perm = settings.mod["Chat IDs"].moderator.lvl
            local admin_perm = settings.mod["Chat IDs"].admin.lvl
            local sadmin_perm = settings.mod["Chat IDs"].senior_admin.lvl

            if not (keyword) or (keyword == nil) then
                local function ChatHandler(PlayerIndex, Message)
                    local function SendToTeam(Message, PlayerIndex, Global, Tmod, Mod, Admin, sAdmin)
                        for i = 1, 16 do
                            if player_present(i) and (get_var(i, "$team") == get_var(PlayerIndex, "$team")) then
                                local formattedString = ""
                                execute_command("msg_prefix \"\"")
                                if (Global == true) then
                                    formattedString = (gsub(gsub(gsub(TeamDefault, "%%sender_name%%", name), "%%index%%", id), "%%message%%", Message))
                                elseif (Tmod == true) then
                                    formattedString = (gsub(gsub(gsub(Team_TModFormat, "%%sender_name%%", name), "%%index%%", id), "%%message%%", Message))
                                elseif (Mod == true) then
                                    formattedString = (gsub(gsub(gsub(Team_ModFormat, "%%sender_name%%", name), "%%index%%", id), "%%message%%", Message))
                                elseif (Admin == true) then
                                    formattedString = (gsub(gsub(gsub(Team_AdminFormat, "%%sender_name%%", name), "%%index%%", id), "%%message%%", Message))
                                elseif (sAdmin == true) then
                                    formattedString = (gsub(gsub(gsub(Team_SAdminFormat, "%%sender_name%%", name), "%%index%%", id), "%%message%%", Message))
                                end
                                say(i, formattedString)
                                execute_command("msg_prefix \" " .. settings.global.server_prefix .. "\"")
                                response = false
                            end
                        end
                    end

                    local function SendToAll(Message, Global, Tmod, Mod, Admin, sAdmin)
                        local formattedString = ""
                        execute_command("msg_prefix \"\"")
                        if (Global == true) then
                            formattedString = (gsub(gsub(gsub(GlobalDefault, "%%sender_name%%", name), "%%index%%", id), "%%message%%", Message))
                        elseif (Tmod == true) then
                            formattedString = (gsub(gsub(gsub(Global_TModFormat, "%%sender_name%%", name), "%%index%%", id), "%%message%%", Message))
                        elseif (Mod == true) then
                            formattedString = (gsub(gsub(gsub(Global_ModFormat, "%%sender_name%%", name), "%%index%%", id), "%%message%%", Message))
                        elseif (Admin == true) then
                            formattedString = (gsub(gsub(gsub(Global_AdminFormat, "%%sender_name%%", name), "%%index%%", id), "%%message%%", Message))
                        elseif (sAdmin == true) then
                            formattedString = (gsub(gsub(gsub(Global_SAdminFormat, "%%sender_name%%", name), "%%index%%", id), "%%message%%", Message))
                        end
                        say_all(formattedString)
                        execute_command("msg_prefix \" " .. settings.global.server_prefix .. "\"")
                        response = false
                    end

                    for b = 0, #message do
                        if message[b] then
                            if not (sub(message[1], 1, 1) == "/" or sub(message[1], 1, 1) == "\\") then
                                if (getTeamPlay()) then
                                    if (type == 0 or type == 2) then
                                        if (settings.mod["Chat IDs"].use_admin_prefixes == true) then
                                            if (level == tmod_perm) then
                                                SendToAll(Message, nil, true, nil, nil, nil)
                                            elseif (level == mod_perm) then
                                                SendToAll(Message, nil, nil, true, nil, nil)
                                            elseif (level == admin_perm) then
                                                SendToAll(Message, nil, nil, nil, true, nil)
                                            elseif (level == sadmin_perm) then
                                                SendToAll(Message, nil, nil, nil, nil, true)
                                            else
                                                SendToAll(Message, true, nil, nil, nil, nil)
                                            end
                                        else
                                            SendToAll(Message, true, nil, nil, nil, nil)
                                        end
                                    elseif (type == 1) then
                                        if (settings.mod["Chat IDs"].use_admin_prefixes == true) then
                                            if (level == tmod_perm) then
                                                SendToTeam(Message, PlayerIndex, nil, true, nil, nil, nil)
                                            elseif (level == mod_perm) then
                                                SendToTeam(Message, PlayerIndex, nil, nil, true, nil, nil)
                                            elseif (level == admin_perm) then
                                                SendToTeam(Message, PlayerIndex, nil, nil, nil, true, nil)
                                            elseif (level == sadmin_perm) then
                                                SendToTeam(Message, PlayerIndex, nil, nil, nil, nil, true)
                                            else
                                                SendToTeam(Message, PlayerIndex, true, nil, nil, nil, nil)
                                            end
                                        else
                                            SendToTeam(Message, PlayerIndex, true, nil, nil, nil, nil)
                                        end
                                    end
                                else
                                    if (settings.mod["Chat IDs"].use_admin_prefixes == true) then
                                        if (level == tmod_perm) then
                                            SendToAll(Message, nil, true, nil, nil, nil)
                                        elseif (level == mod_perm) then
                                            SendToAll(Message, nil, nil, true, nil, nil)
                                        elseif (level == admin_perm) then
                                            SendToAll(Message, nil, nil, nil, true, nil)
                                        elseif (level == sadmin_perm) then
                                            SendToAll(Message, nil, nil, nil, nil, true)
                                        else
                                            SendToAll(Message, true, nil, nil, nil, nil)
                                        end
                                    else
                                        SendToAll(Message, true, nil, nil, nil, nil)
                                    end
                                end
                            else
                                response = true
                            end
                            break
                        end
                    end
                end
                if modEnabled("Admin Chat") then
                    if (players["Admin Chat"][ip].adminchat ~= true) then
                        ChatHandler(PlayerIndex, Message)
                    end
                else
                    ChatHandler(PlayerIndex, Message)
                end
            end
        end
    end
    return response
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
                respond(e, "Command failed. Player not online.", "rcon", 4+8)
                return false
            end
        else
            respond(e, "Invalid player id. Please enter a number between 1-16", "rcon", 4+8)
        end
    end
end

local function cmdself(t, e)
    if (t) then
        if tonumber(t) == tonumber(e) then
            rprint(e, "You cannot execute this command on yourself.")
            return true
        end
    end
end

function OnServerCommand(PlayerIndex, Command)
    local command, args = cmdsplit(Command)
    local executor = tonumber(PlayerIndex)
    local level = tonumber(get_var(executor, "$lvl"))

    local TargetID, target_all_players, is_error
    local ip, name, hash = get_var(executor, "$ip"), get_var(executor, "$name"), get_var(executor, "$hash")
    local pl
    
    local pCMD = settings.global.plugin_commands
    
    local function hasAccess(e, lvl_req)
        local allow_access
        if isConsole(e) then
            return true
        elseif (level >= lvl_req) then
            return true
        else
            return false
        end
    end
    
    local params = { }
    local function validate_params(parameter)
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
                respond(executor, "Invalid player id. Usage: [number: 1-16] | */all | me", "rcon", 4+8)
                is_error = true
                return false
            end
            if players[1] then
                return players
            end
            players = nil
            return false
        end
        local pl = getplayers(args[1], executor)
        if pl then
            for i = 1, #pl do
                if pl[i] == nil then
                    break
                end
                
                params.eid = executor
                params.eip = ip
                params.en = name
                params.eh = hash
                
                params.tid = tonumber(pl[i])
                params.tip = get_var(pl[i], "$ip")
                params.tn = get_var(pl[i], "$name")
                params.th = get_var(pl[i], "$hash")
                
                -- SAPP | Mute Handler
                if (parameter == "mute") then
                    local default_time = settings.global.default_mute_time
                    if (settings.global.can_mute_admins) then
                        proceed = true
                    elseif tonumber(get_var(pl[i], "$lvl")) >= 1 then
                        proceed = false
                        respond(executor, "You cannot mute admins.", "rcon", 4+8)
                    else
                        proceed = true
                    end
                    mute_duration[params.tid] = 0
                    if (args[2] == nil) then
                        time_diff[params.tid] = tonumber(default_time)
                        mute_duration[params.tid] = tonumber(default_time)
                        params.time = mute_duration[params.tid]
                        valid = true
                    elseif match(args[2], "%d+") then
                        time_diff[params.tid] = tonumber(args[2])
                        mute_duration[params.tid] = tonumber(args[2])
                        params.time = mute_duration[params.tid]
                        init_mute_timer[params.tid] = true
                        valid = true
                    else
                        valid = false
                        respond(executor, "Invalid syntax. Usage: /" .. pCMD.mute[1] .. " [id] <time dif>", "rcon", 4+8)
                    end
                    params.proceed, params.valid = proceed, valid
                    if (target_all_players) then
                        velocity:mute(params)
                    end
                -- #Alias System
                elseif (parameter == "alias") then
                    alias:reset(ip)
                    local bool
                    if isConsole(executor) then
                        ip = "000.000.000.000"
                        bool = false
                    else
                        bool = settings.mod["Alias System"].use_timer
                    end
                    params.timer = bool
                    if (target_all_players) then
                        velocity:aliasCmdRoutine(params)
                    end
                -- #Admin Chat
                elseif (parameter == "achat") then
                    if (args[2] ~= nil) then params.option = args[2] end
                    if (target_all_players) then
                        velocity:determineAchat(params)
                    end
                end
            end
        end
    end
    
    -- #Player List
    local cmd_list = settings.mod["Player List"].command_aliases
    for i = 1, #cmd_list do
        if (command == cmd_list[i]) then
            if modEnabled("Player List", executor) then
                if (args[1] == nil) then
                    if (checkAccess(executor, true, "Player List")) then
                        velocity:listplayers(executor)
                    end
                else
                    respond(executor, "Invalid Syntax. Usage: /" .. command, "rcon", 4+8)
                end
            end
            return false
        end
    end
    
    -- #Alias System
    if (command == settings.mod["Alias System"].base_command) then
        if modEnabled("Alias System", executor) then
            if (checkAccess(executor, true, "Alias System")) then
                if (args[1] ~= nil) then
                    validate_params("alias")
                    if not (target_all_players) then
                        if not (is_error) and isOnline(TargetID, executor) then
                            velocity:aliasCmdRoutine(params)
                        end
                    else
                        respond(executor, "Unable to check aliases from all players.", "rcon", 4+8)
                    end
                else
                    local base_command = settings.mod["Alias System"].base_command
                    respond(executor, "Invalid syntax. Usage: /" .. base_command .. " [id | me ]", "rcon", 4+8)
                end
            end
        end
        return false
        -- #Admin Chat
    elseif (command == settings.mod["Admin Chat"].base_command) then
        if modEnabled("Admin Chat", executor) then
            if (checkAccess(executor, true, "Admin Chat")) then
                if (args[1] ~= nil) then
                    validate_params("achat")
                    if not (target_all_players) then
                        if not (is_error) and isOnline(TargetID, executor) then
                            velocity:determineAchat(params)
                        end
                    end
                else
                    local base_command = settings.mod["Admin Chat"].base_command
                    respond(executor, "Invalid Syntax: Type /" .. base_command .. " [id] on|off.", "rcon", 4+8)
                    return false
                end
            end
        end
        return false
    -- #Velocity Version command
    elseif (command == pCMD.bgs[1]) then
        if hasAccess(executor, pCMD.bgs[2]) then
            if (settings.global.check_for_updates) then
                if (getCurrentVersion(false) ~= settings.global.script_version) then
                    respond(executor, "============================================================================", "rcon", 7+8)
                    respond(executor, "[VELOCITY] Version " .. getCurrentVersion(false) .. " is available for download.", "rcon", 5+8)
                    respond(executor, "Current version: v" .. settings.global.script_version, "rcon", 5+8)
                    respond(executor, "============================================================================", "rcon", 7+8)
                else
                    respond(executor, "Velocity Version " .. settings.global.script_version, "rcon", 5+8)
                end
            else
                respond(executor, "Update Checking disabled. Current version: " .. settings.global.script_version, "rcon", 5+8)
            end
        else
            respond(executor, "Insufficient Permission", "rcon", 5+8)
        end
        return false
    elseif (command == pCMD.list[1]) then
        if hasAccess(executor, pCMD.list[2]) then
            local t = {}
            for k, _ in pairs(settings.mod) do
                t[#t + 1] = k
            end
            for k, v in pairs(t) do
                if v then
                    if (settings.mod[v].enabled) then
                        respond(executor, "[" .. k .. "] " .. v .. " is enabled", "rcon")
                    else
                        respond(executor, "[" .. k .. "] " .. v .. " is disabled", "rcon")
                    end
                end
            end
            for _ in pairs(t) do
                t[_] = nil
            end
        else
            respond(executor, "Insufficient Permission", "rcon")
        end
        return false
    elseif (command == pCMD.enable[1]) then
        if (args[1] ~= nil and args[1]:match("%d+")) then
            if hasAccess(executor, pCMD.enable[2]) then
                local id = args[1]
                local t = {}
                for k, _ in pairs(settings.mod) do
                    t[#t + 1] = k
                end
                for k, v in pairs(t) do
                    if v then
                        if (tonumber(id) == tonumber(k)) then
                            if not (settings.mod[v].enabled) then
                                settings.mod[v].enabled = true
                                respond(executor, "[" .. k .. "] " .. v .. " is enabled", "rcon", 2+8)
                            else
                                respond(executor, v .. " is already enabled!", "rcon", 3+8)
                            end
                        end
                    end
                end
                for _ in pairs(t) do
                    t[_] = nil
                end
            else
                respond(executor, "Insufficient Permission", "rcon", 4+8)
            end
        else
            respond(executor, "Invalid Syntax. Usage: /" .. pCMD.enable[1], "rcon", 4+8)
        end
        return false
    elseif (command == pCMD.disable[1]) then
        if (args[1] ~= nil and args[1]:match("%d+")) then
            if hasAccess(executor, pCMD.disable[2]) then
                local id = args[1]
                local t = {}
                for k, _ in pairs(settings.mod) do
                    t[#t + 1] = k
                end
                for k, v in pairs(t) do
                    if v then
                        if (tonumber(id) == tonumber(k)) then
                            if (settings.mod[v].enabled) then
                                settings.mod[v].enabled = false
                                respond(executor, "[" .. k .. "] " .. v .. " is disabled", "rcon", 4+8)
                            else
                                respond(executor, v .. " is already enabled!", "rcon", 3+8)
                            end
                        end
                    end
                end
                for _ in pairs(t) do
                    t[_] = nil
                end
            else
                respond(executor, "Insufficient Permission", "rcon", 4+8)
            end
        else
            respond(executor, "Invalid Syntax. Usage: /" .. pCMD.disable[1], "rcon", 4+8)
        end
        return false
    elseif (command == pCMD.mute[1]) then
        if (settings.global.handlemutes == true) then
            if hasAccess(executor, pCMD.mute[2]) then
                if (args[1] ~= nil) then
                    validate_params("mute")
                    if not (target_all_players) then
                        if not (is_error) and isOnline(TargetID, executor) then
                            if not cmdself(TargetID, executor) then
                                velocity:mute(params)
                            end
                        end
                    end
                else
                    respond(executor, "Invalid syntax. Usage: /" .. pCMD.mute[1] .. " [id] <time dif>")
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

function velocity:determineAchat(params)
    
    local params = params or {}
    local eid = params.eid or nil
    local eip = params.eip or nil
    local en = params.en or nil
    
    local tid = params.tid or nil
    local tip = params.tip or nil
    local tn = params.tn or nil
    
    if isConsole(eid) then
        en = "SERVER"
    end
    
    local option = params.option or nil
    local mod = players["Admin Chat"][tip]
    
    if option == nil then
        if type(mod.adminchat) == 'true' then
            status = "on"
        else
            status = "off"
        end
        respond(eid, tn .. "'s admin chat is " .. status)
    end
    
    local is_self
    if (eid == tid) then
        is_self = true
    end
    
    local level = get_var(tid, "$lvl")
    local base_command = settings.mod["Admin Chat"].base_command
    if tonumber(level) >= getPermLevel("Admin Chat") then
        local status, already_set, is_error
        if (option == "on") or (option == "1") or (option == "true") then
            status, already_set, is_error = "Enabled", true, false
            if (mod.boolean ~= true) then
                mod.adminchat = true
                mod.boolean = true
            end
        elseif (option == "off") or (option == "0") or (option == "false") then
            status, already_set, is_error = "Disabled", false, false
            if (mod.boolean ~= false) then
                mod.adminchat = false
                mod.boolean = false
            end
        else
            is_error = true
            respond(eid, "Invalid Syntax: Type /" .. base_command .. " [id] on|off.", "rcon", 4+8)
        end
        if not (is_error) and not (already_set) then
            if not (is_self) then
                respond(eid, "Admin Chat " .. status .. " for " .. tn, "rcon", 2+8)
                respond(tid, "Your Admin Chat was " .. status .. " by " .. en, "rcon")
            else
                respond(eid, "Admin Chat " .. status, "rcon")
            end
        elseif (already_set) then
            respond(eid, "[SERVER] -> " .. tn .. ", Admin Chat is already " .. status, "rcon")
        end
    else
        respond(eid, "Failed set " .. tn .. "'s admin chat to (" .. option .. ") [not an admin]", "rcon", 4+8)
    end
    return false
end

function velocity:mute(params)
    local params = params or {}
    local eid = params.eid or nil
    local tid = params.tid or nil
    local tip = params.tip or nil
    local tn = params.tn or nil
    local th = params.th or nil
    local proceed = params.proceed or nil
    local valid = params.valid or nil
    local time = params.time or nil
    
    if (proceed) and (valid) then
        muted[tid] = true
        local file_name = settings.global.mute_dir
        local file = io.open(file_name, "r")
        local content = file:read("*a")
        file:close()

        if not (match(content, tip) and match(content, tid) and match(content, th)) then
            if (tonumber(time) ~= settings.global.default_mute_time) then
                respond(eid, tn .. " has been muted for " .. time .. " minute(s)", "rcon", 4+8)
                rprint(tid, "You have been muted for " .. time .. " minute(s)")
            else
                rprint(eid, tn .. " has been muted permanently")
                rprint(tid, "You were muted permanently")
            end
            local new_entry = tip .. ", " .. th .. ", " .. tn .. ", ;" .. time
            local file = assert(io.open(file_name, "a+"))
            file:write(new_entry .. "\n")
            file:close()
        else
            rprint(eid, tn .. " is already muted!", "rcon", 4+8)
        end
    end
end

-- #Alias System
function velocity:aliasCmdRoutine(params)
    local params = params or {}
    local eid = params.eid or nil
    local tn = params.tn or nil
    local th = params.th or nil
    local use_timer = params.timer or nil
    
    local aliases, content
    local tab = players["Alias System"][ip]
    alias_results = { }
  
    tab.tHash = params.th
    tab.tName = params.tn
    
    local directory = settings.mod["Alias System"].dir
    local lines = lines_from(directory)
    for _, v in pairs(lines) do
        if (v:match(tab.tHash)) then
            aliases = v:match(":(.+)")
            content = stringSplit(aliases, ",")
            alias_results[#alias_results + 1] = content
        end
    end

    tab.eid = eid
    tab.shared = false
    tab.check_pirated_hash = true

    for i = 1, max_results do
        if (alias_results[1][i]) then
            tab.total = tab.total + 1
        end
    end
    
    local total = tab.total
    if (use_timer) then
        tab.trigger = true
        tab.bool = true
    else
        alias:show(eid, eip, total)
    end
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
            respond(player, "|" .. alignment .. " " .. row, "rcon")
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
    respond(player, " ", "rcon")
    respond(player, "|" .. alignment .. " " .. 'Showing (' .. total .. ' aliases) for: "' .. target .. '"', "rcon")
    if (pirated) then
        respond(player, "|" .. alignment .. " " .. name .. ' is using a pirated copy of Halo.', "rcon")
    end
end

-- #Alias System
function alias:show(executor, ip, total)
    local tab = players["Alias System"][ip]
    local target = tab.tHash
    local name = tab.tName
    local check_pirated_hash = tab.check_pirated_hash
    if (check_pirated_hash) then
        tab.check_pirated_hash = false
        for i = 1, #known_pirated_hashes do
            if (target == known_pirated_hashes[i]) then
                tab.shared = true
            end
        end
    end
    local alignment = settings.mod["Alias System"].alignment
    alias:align(executor, alias_results, target, total, tab.shared, name, alignment)
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
            respond(PlayerIndex, " ", "rcon")
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

function respond(executor, message, environment, color)
    if (executor) then
        color = color or 4+8
        if not (isConsole(executor)) then
            if (environment == "chat") then
                say(executor, message)
            elseif (environment == "rcon") then
                rprint(executor, message)
            end
        else
            cprint(message, color)
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

function secondsToTime(seconds, places)
    
    local years = floor(seconds / (60 * 60 * 24 * 365))
    seconds = seconds % (60 * 60 * 24 * 365)
    local weeks = floor(seconds / (60 * 60 * 24 * 7))
    seconds = seconds % (60 * 60 * 24 * 7)
    local days = floor(seconds / (60 * 60 * 24))
    seconds = seconds % (60 * 60 * 24)
    local hours = floor(seconds / (60 * 60))
    seconds = seconds % (60 * 60)
    local minutes = floor(seconds / 60)
    seconds = seconds % 60

    if places == 6 then
        return string.format("%02d:%02d:%02d:%02d:%02d:%02d", years, weeks, days, hours, minutes, seconds)
    elseif places == 5 then
        return string.format("%02d:%02d:%02d:%02d:%02d", weeks, days, hours, minutes, seconds)
    elseif not places or places == 4 then
        return days, hours, minutes, seconds
    elseif places == 3 then
        return string.format("%02d:%02d:%02d", hours, minutes, seconds)
    elseif places == 2 then
        return string.format("%02d:%02d", minutes, seconds)
    elseif places == 1 then
        return string.format("%02", seconds)
    end
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
            cprint("[VELOCITY] Version " .. tostring(version) .. " is available for download.")
            cprint("Current version: v" .. settings.global.script_version, 5 + 8)
            cprint("============================================================================", 5 + 8)
        else
            cprint("[VELOCITY] Version " .. settings.global.script_version, 2 + 8)
        end
    end
    return tonumber(version)
end

-- Prints enabled scripts | Called by OnScriptLoad()
function printEnabled()
    cprint("\n----- [ VELOCITY ] -----", 3 + 5)
    for k, _ in pairs(settings.mod) do
        if (settings.mod[k].enabled) then
            cprint(k .. " is enabled", 2 + 8)
        else
            cprint(k .. " is disabled", 4 + 8)
        end
    end
    cprint("----------------------------------\n", 3 + 5)
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
