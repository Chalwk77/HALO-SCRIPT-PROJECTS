--[[
--=====================================================================================================--
Script Name: Notify Me, for SAPP (PC & CE)
Description: This script will beautify the server terminal during certain events:

            - script_load
            - script_unload
            - event_chat
            - event_command
            - event_game_start
            - event_game_end
            - event_prejoin
            - event_join
            - event_leave
            - event_die
            - event_snap
            - event_spawn
            - event_login
            - event_map_reset
            - event_team_switch

            * This script is highly customizable. You can enable/disable certain notifications and change the color of the text.

Copyright (c) 2024, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/blob/master/LICENSE
--=====================================================================================================--
]]--


api_version = '1.12.0.0'

local players = {}
local date = os.date
local char = string.char
local concat = table.concat
local ffa, falling, distance, first_blood

function OnScriptLoad()

    register_callback(cb['EVENT_CHAT'], 'OnChat')
    register_callback(cb['EVENT_COMMAND'], 'OnCommand')

    register_callback(cb['EVENT_DIE'], 'OnDeath')
    register_callback(cb['EVENT_DAMAGE_APPLICATION'], 'OnDeath')

    register_callback(cb['EVENT_JOIN'], 'OnJoin')
    register_callback(cb['EVENT_LEAVE'], 'OnQuit')
    register_callback(cb['EVENT_PREJOIN'], 'OnPreJoin')

    register_callback(cb['EVENT_GAME_END'], 'OnEnd')
    register_callback(cb['EVENT_GAME_START'], 'OnStart')

    register_callback(cb['EVENT_SNAP'], 'OnSnap')
    register_callback(cb['EVENT_SPAWN'], 'OnSpawn')
    register_callback(cb['EVENT_LOGIN'], 'OnLogin')
    register_callback(cb['EVENT_MAP_RESET'], "OnReset")
    register_callback(cb['EVENT_TEAM_SWITCH'], 'OnSwitch')

    OnStart()
    timer(50, "printLogo")
end

-- Notification configuration
local notificationConfig = {

    -- General settings:
    prefix = "", -- default empty
    defaultColor = 12,
    timeStampFormat = "%A %d %B %Y - %X",

    -- Console logo:
    logo = {
        enabled = true,
        text = {
            { "================================================================================", 10 },
            { "$timeStamp", 6 },
            { "", 0 },
            { "     '||'  '||'     |     '||'       ..|''||           ..|'''.| '||''''|  ", 12 },
            { "      ||    ||     |||     ||       .|'    ||        .|'     '   ||  .    ", 12 },
            { "      ||''''||    |  ||    ||       ||      ||       ||          ||''|    ", 12 },
            { "      ||    ||   .''''|.   ||       '|.     ||       '|.      .  ||       ", 12 },
            { "     .||.  .||. .|.  .||. .||.....|  ''|...|'         ''|....'  .||.....| ", 12 },
            { "               ->-<->-<->-<->-<->-<->-<->-<->-<->-<->-<->-<->-<->-", 7 },
            { "                             $serverName", 10 },
            { "               ->-<->-<->-<->-<->-<->-<->-<->-<->-<->-<->-<->-<->-", 7 },
            { "", 0 },
            { "================================================================================", 10 }
        }
    },

    -- Event-specific settings
    events = {
        ["OnStart"] = {
            enabled = true,
            message = "A new game has started on $map - $mode",
            color = 10
        },
        ["OnEnd"] = {
            enabled = true,
            message = "The game has ended.",
            color = 4
        },
        ["OnPreJoin"] = {
            enabled = true,
            message = "________________________________________________________________________________\nPlayer attempting to connect to the server...\nPlayer: $playerName\nCD Hash: $cdHash\nIP Address: $ipAddress\nIndex ID: $indexID\nPrivilege Level: $privilegeLevel",
            color = 10 -- Green
        },
        ["OnJoin"] = {
            enabled = true,
            message = "Status: $playerName connected successfully.\nJoin Time: $joinTime\n________________________________________________________________________________",
            color = 10 -- Green
        },
        -- OnQuit:
        ["OnQuit"] = {
            enabled = true,
            message = "________________________________________________________________________________\nPlayer: $playerName\nCD Hash: $cdHash\nIP Address: $ipAddress\nIndex ID: $indexID\nPrivilege Level: $privilegeLevel\nPing: $ping\n________________________________________________________________________________",
            color = 12
        },
        ["OnSpawn"] = {
            enabled = true,
            message = "$playerName spawned",
            color = 14
        },
        -- OnSwitch:
        ["OnSwitch"] = {
            enabled = true,
            message = "$playerName switched teams. New team: [$team]",
            color = 14
        },
        -- OnWarp:
        ["OnWarp"] = {
            enabled = true,
            message = "$playerName is warping",
            color = 14
        },
        ["OnReset"] = {
            enabled = true,
            message = "The map has been reset.",
            color = 14
        },
        ["OnLogin"] = {
            enabled = true,
            message = "$playerName logged in",
            color = 14
        },
        ["OnSnap"] = {
            enabled = true,
            message = "$playerName snapped",
            color = 14
        },
        ["OnCommand"] = {
            enabled = true,
            message = "[$type] $name ($id): $cmd",
            color = 14
        },
        ["OnChat"] = {
            enabled = true,
            message = "[$type] $name ($id): $msg",
            color = 14
        },
        ["OnDeath"] = {
            [1] = { -- first blood
                enabled = true,
                message = "$killerName drew first blood",
                color = 10
            },
            [2] = { -- killed from the grave
                enabled = true,
                message = "$victimName was killed from the grave by $killerName",
                color = 10
            },
            [3] = { -- vehicle kill
                enabled = true,
                message = "$victimName was run over by $killerName",
                color = 10
            },
            [4] = { -- pvp
                enabled = true,
                message = "$victimName was killed by $killerName",
                color = 10
            },
            [5] = { -- guardians
                enabled = true,
                message = "$victimName was killed by the guardians",
                color = 10
            },
            [6] = { -- suicide
                enabled = true,
                message = "$victimName committed suicide",
                color = 10
            },
            [7] = { -- betrayal
                enabled = true,
                message = "$victimName was betrayed by $killerName",
                color = 10
            },
            [8] = { -- squashed by a vehicle
                enabled = true,
                message = "$victimName was squashed by a vehicle",
                color = 10
            },
            [9] = { -- fall damage
                enabled = true,
                message = "$victimName fell and broke their leg",
                color = 10
            },
            [10] = { -- killed by the server
                enabled = true,
                message = "$victimName was killed by the server",
                color = 10
            },
            [11] = { -- unknown
                enabled = true,
                message = "$victimName died",
                color = 10
            },
        }
    }
}

local function parseMessageTemplate(messageTemplate, args)
    local message = messageTemplate

    for placeholder, value in pairs(args) do
        message = message:gsub(placeholder, value)
    end

    return message
end

local function notify(eventName, args)

    if notificationConfig.events[eventName] then

        local eventConfig = notificationConfig.events[eventName]
        local messageTemplate

        if eventName == "OnDeath" then
            local deathEvent = notificationConfig.events["OnDeath"][args.eventType]
            if deathEvent and deathEvent.enabled then
                eventConfig = deathEvent
                messageTemplate = eventConfig.message
                goto next
            end
        end

        messageTemplate = eventConfig.message

        :: next ::

        if type(messageTemplate) == "string" and #messageTemplate > 0 then
            local message
            if args then
                message = parseMessageTemplate(messageTemplate, args)
            else
                message = messageTemplate
            end

            local notification = notificationConfig.prefix .. message
            local color = eventConfig.color or notificationConfig.defaultColor
            cprint(notification, color)
        end
    end
end

local function getTag(Type, Name)
    local Tag = lookup_tag(Type, Name)
    return Tag ~= 0 and read_dword(Tag + 0xC) or nil
end

local function readWideString(Address, Length)
    local count = 0
    local byte_table = {}
    for i = 1, Length do
        if (read_byte(Address + count) ~= 0) then
            byte_table[i] = char(read_byte(Address + count))
        end
        count = count + 2
    end
    return concat(byte_table)
end

local function getServerName()
    local network_struct = read_dword(sig_scan("F3ABA1????????BA????????C740??????????E8????????668B0D") + 3)
    return readWideString(network_struct + 0x8, 0x42)
end

function printLogo()
    local logo = notificationConfig.logo
    if logo.enabled then
        local logoLines = logo.text
        for _, line in ipairs(logoLines) do
            local message = line[1]
            if message then
                message = message:gsub("$timeStamp", date(notificationConfig.timeStampFormat))
                message = message:gsub("$serverName", getServerName())
                cprint(message, line[2])
            end
        end
    end
end

function OnStart()

    if (get_var(0, "$gt") ~= "n/a") then

        players = { }
        first_blood = true

        ffa = (get_var(0, '$ffa') == '1')

        falling = getTag('jpt!', 'globals\\falling')
        distance = getTag('jpt!', 'globals\\distance')

        local map = get_var(0, "$map")
        local mode = get_var(0, "$mode")

        notify("OnStart", {
            ["$map"] = map,
            ["$mode"] = mode
        })

        for i = 1, 16 do
            if player_present(i) then
                OnJoin(i)
            end
        end
    end
end

function OnEnd()
    notify("OnEnd")
end

function OnPreJoin(id)

    local level = tonumber(get_var(id, '$lvl'))
    players[id] = {
        level = level,
        id = id,
        meta = 0,
        switched = false,
        ip = get_var(id, '$ip'),
        name = get_var(id, '$name'),
        team = get_var(id, '$team'),
        hash = get_var(id, '$hash')
    }

    local player = players[id]
    notify("OnPreJoin", {
        ["$playerName"] = player.name,
        ["$ipAddress"] = player.ip,
        ["$cdHash"] = player.hash,
        ["$indexID"] = player.id,
        ["$privilegeLevel"] = level,
        ["$joinTime"] = date(notificationConfig.timeStampFormat)
    })
end

function OnJoin(id)
    local player = players[id]
    if player then
        local timestamp = date(notificationConfig.timeStampFormat)
        notify("OnJoin", {
            ["$playerName"] = player.name,
            ["$joinTime"] = timestamp
        })
    end
end

function OnSpawn(id)
    local player = players[id]
    if player then
        players[id].meta = 0
        players[id].switched = nil
        notify("OnSpawn", {
            ["$playerName"] = player.name
        })
    end
end

function OnQuit(id)
    local player = players[id]
    if (player) then
        notify("OnQuit", {
            ["$playerName"] = player.name,
            ["$ipAddress"] = player.ip,
            ["$cdHash"] = player.hash,
            ["$indexID"] = player.id,
            ["$privilegeLevel"] = player.level,
            ["$ping"] = get_var(id, "$ping")
        })
    end
    players[id] = nil
end

function OnSwitch(id)
    local player = players[id]
    if player then
        player.team = get_var(id, '$team')
        player.switched = true
        notify("OnSwitch", {
            ["$playerName"] = player.name,
            ["$team"] = player.team
        })
    end
end

function OnWarp(id)
    local player = players[id]
    if player then
        notify("OnWarp", {
            ["$playerName"] = player.name
        })
    end
end

function OnReset()
    notify("OnReset")
end

function OnLogin(id)
    local player = players[id]
    if (player) then
        notify("OnLogin", {
            ["$playerName"] = player.name
        })
    end
end

function OnSnap(id)
    local player = players[id]
    if (player) then
        notify("OnSnap", {
            ["$playerName"] = player.name
        })
    end
end

local command_type = {
    [0] = "rcon command",
    [1] = "console command",
    [2] = "chat command",
    [3] = "unknown command type"
}

function OnCommand(id, command, environment)
    local player = players[id]
    if (player and id > 0) then
        local cmd = command:match("^(%S+)")
        notify("OnCommand", {
            ["$type"] = command_type[environment],
            ["$name"] = player.name,
            ["$id"] = id,
            ["$cmd"] = cmd
        })
    end
end

local chat_type = {
    [0] = "GLOBAL",
    [1] = "TEAM",
    [2] = "VEHICLE",
    [3] = "UNKNOWN"
}

local function isCommand(str)
    return (str:sub(1, 1) == "/" or str:sub(1, 1) == "\\")
end

function OnChat(id, message, environment)
    local player = players[id]
    if (player and id > 0) then
        local msg = message:match("^(%S+)")
        if (not isCommand(msg)) then
            notify("OnChat", {
                ["$type"] = chat_type[environment],
                ["$name"] = player.name,
                ["$id"] = id,
                ["$msg"] = message
            })
        end
    end
end

function OnDeath(victimIndex, killerIndex, metaID)

    victimIndex = tonumber(victimIndex)
    killerIndex = tonumber(killerIndex)

    local victimPlayer = players[victimIndex]
    local killerPlayer = players[killerIndex]

    if victimPlayer then

        if metaID then
            victimPlayer.meta = metaID
            return true
        end

        local squashed = (killerIndex == 0)
        local guardians = (killerIndex == nil)
        local suicide = (killerIndex == victimIndex)
        local pvp = (killerIndex > 0 and killerIndex ~= victimIndex)
        local server = (killerIndex == -1 and not victimPlayer.switched)
        local fell = (victimPlayer.meta == falling or victimPlayer.meta == distance)
        local betrayal = (killerPlayer and not ffa and victimPlayer.team == killerPlayer.team and killerIndex ~= victimIndex)

        local eventType
        if pvp and not betrayal then

            if first_blood then
                first_blood = false
                eventType = 1
                goto done
            end

            -- killed from the grave
            if not player_alive(killerIndex) then
                eventType = 2
                goto done
            end

            -- vehicle kill
            local dyn = get_dynamic_player(killerIndex)
            if dyn ~= 0 then
                local vehicle = read_dword(dyn + 0x11C)
                if vehicle ~= 0xFFFFFFFF then
                    eventType = 3
                    goto done
                end
            end

            -- pvp
            eventType = 4

        elseif guardians then
            eventType = 5
        elseif suicide then
            eventType = 6
        elseif betrayal then
            eventType = 7
        elseif squashed then
            eventType = 8
        elseif fell then
            eventType = 9
        elseif server then
            eventType = 10
        else
            eventType = 11
        end

        :: done ::

        notify("OnDeath", {
            ["eventType"] = eventType,
            ["$killerName"] = killerPlayer and killerPlayer.name or "",
            ["$victimName"] = victimPlayer.name
        })
    end
end

function OnScriptUnload()
    -- N/A
end