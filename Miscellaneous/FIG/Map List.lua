--[[
--=====================================================================================================--
Script Name: Map List, for SAPP (PC & CE)
Description: Display current/next map cycle information:

See config for command syntax.

Copyright (c) 2022, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/blob/master/LICENSE
--=====================================================================================================--
]]--

-- config starts --

-- Command to show current/next map (and map cycle position):
-- Syntax: /command
--
local map_list_command = "maplist"

-- Command to show map at specific map cycle position:
-- Syntax: /command [pos]
--
local what_is_next_command = "whatis"

-- Path to the mapcycle.txt file:
--
local path = "cg/sapp/mapcycle.txt"

-- Customizable message output:
--
local output = {

    -- Message outputs when you type /map_list_command:
    --
    "Current Map: $map ($mode) | Pos: ($pos/$total)",
    "Next Map: $map ($mode) | Pos: ($pos/$total)",

    -- message output when you type /what_is_next_command:
    --
    "$map ($mode) | Pos: $pos/$total",
}

-- config ends --

local map, mode
local maps = { }

api_version = "1.12.0.0"

local function STRSplit(CMD, Delim)
    local Args = { }
    for line in CMD:gsub('"', ""):gmatch("([^" .. Delim .. "]+)") do
        Args[#Args + 1] = line
    end
    return Args
end

function OnScriptLoad()

    register_callback(cb["EVENT_COMMAND"], "OnCommand")
    register_callback(cb["EVENT_GAME_START"], "OnStart")

    local entries = { }
    local file = io.open(path)
    if (file) then
        for entry in file:lines() do
            table.insert(entries, entry)
        end
        file:close()
    end

    for pos, entry in pairs(entries) do
        local lines = STRSplit(entry, ":")
        maps[pos] = maps[pos] or {}
        for i, v in pairs(lines) do
            if (i == 1) then
                maps[pos].map = v
            else
                maps[pos].mode = v
            end
        end
    end

    OnStart()
end

-- Custom print function:
-- @Param Ply (player index id [number])
-- @Param Msg (message [string])
--
local function Say(Ply, Msg)
    return (Ply == 0 and cprint(Msg, 10) or rprint(Ply, Msg))
end

-- Used to format messages:
--
local function FormatTxt(Str, Pos, Map, Mode, Total)

    local words = {
        ["$pos"] = Pos,
        ["$map"] = Map,
        ["$mode"] = Mode,
        ["$total"] = Total,
    }

    local msg = Str
    for k, v in pairs(words) do
        msg = msg:gsub(k, v)
    end

    return msg
end

-- Display current map:
-- @Param Ply (player index id)
-- @Return Next map array
--
local function ShowCurrentMap(Ply)

    local next_map = { }
    local txt = output[1]
    for i, t in pairs(maps) do
        if (map == t.map and mode == t.mode) then
            next_map = { maps[i + 1], i }
            Say(Ply, FormatTxt(txt, i, t.map, t.mode, #maps))
            break
        end
    end

    if (#next_map == 0) then
        Say(Ply, "Unable to display map info.")
        Say(Ply, "Current map and/or mode is not configured in mapcycle.txt.")
        return
    end

    return next_map
end

-- Show next map array:
-- @Param Ply (player index id)
-- @Param t (next map array)
--
local function ShowNextMap(Ply, table)
    local txt = output[2]
    local t, i = table[1], table[2]
    Say(Ply, FormatTxt(txt, i, t.map, t.mode, #maps))
end

function OnCommand(Ply, CMD)

    local Args = STRSplit(CMD, "%s")
    if (#Args > 0) then

        -- map list command --
        if (Args[1] == map_list_command) then

            local next_map = ShowCurrentMap(Ply)

            if (next_map and #next_map > 0) then
                ShowNextMap(Ply, next_map)
            end

            return false

            -- what is next command --
        elseif (Args[1] == what_is_next_command) then

            if (Args[2] ~= nil and Args[2]:match("%d+")) then
                local i = tonumber(Args[2])
                local t = maps[i]
                if (t) then
                    local txt = output[3]
                    Say(Ply, FormatTxt(txt, i, t.map, t.mode, #maps))
                else
                    goto error
                end
                return false
            end

            :: error ::
            Say(Ply, "Please enter a number between 1/" .. #maps)
            return false
        end
    end
end

function OnStart()
    if (get_var(0, "$gt") ~= "n/a") then
        map = get_var(0, "$map")
        mode = get_var(0, "$mode")
    end
end

function OnScriptUnload()
    -- N/A
end