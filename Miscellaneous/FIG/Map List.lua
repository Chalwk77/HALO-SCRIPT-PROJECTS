--[[
--=====================================================================================================--
Script Name: Map List, for SAPP (PC & CE)
Description: Display current/next map & mode in mapcycle.txt

See config for command syntax.

Known Issue:
If there are duplicate map:mode configurations in mapcycle.txt,
you may get an incorrect map list readout when you type /map_list_command.

Copyright (c) 2022, Jericho Crosby <jericho.crosby227@gmail.com>
Notice: You can use this script subject to the following conditions:
https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/blob/master/LICENSE
--=====================================================================================================--
]]--

-- config starts --

-- Command to show current/next map & mode:
-- Syntax: /command
--
local map_list_command = "maplist"

-- Command to show map & mode at specific map cycle position:
-- Syntax: /command [pos]
--
local what_is_next_command = "whatis"

-- Customizable message output:
--
local output = {

    -- $map   = map name
    -- $mode  = game mode
    -- $pos   = map cycle position
    -- $total = total number of maps in mapcycle.txt

    -- Message output when you type /map_list_command:
    --
    "Current Map: $map ($mode) | Pos: ($pos/$total)",
    "Next Map: $map ($mode) | Pos: ($pos/$total)",

    -- message output when you type /what_is_next_command:
    --
    "$map ($mode) | Pos: $pos/$total"
}

-- config ends --

local map, mode
local maps = { }

api_version = "1.12.0.0"

-- Captures strings that contain at least one character of anything other than the Delimiter.
-- @Param CMD (command string [string])
-- @Param Delim (pattern separator [string])
-- @Return An array of strings
--
local function STRSplit(CMD, Delim)
    local Args = { }
    for word in CMD:gsub('"', ""):gmatch("([^" .. Delim .. "]+)") do
        Args[#Args + 1] = word:lower()
    end
    return Args
end

-- Register needed event call backs:
--
function OnScriptLoad()

    -- Open mapcycle.txt,
    -- Iterate over all lines (ignores empty lines),
    -- Split map:mode and store as component properties of maps[i]
    --
    local cg_dir = read_string(read_dword(sig_scan("68??????008D54245468") + 0x1))
    local file = cg_dir .. "\\sapp\\mapcycle.txt"
    file = io.open(file)
    if (file) then

        local i = 1
        for entry in file:lines() do
            local args = STRSplit(entry, ":")
            maps[i] = { map = args[1], mode = args[2] }
            i = i + 1
        end
        file:close()

        register_callback(cb["EVENT_COMMAND"], "OnCommand")
        register_callback(cb["EVENT_GAME_START"], "OnStart")

        OnStart()
    end
end

-- Custom print function:
-- @Param Ply (player index id [number])
-- @Param Msg (message [string])
--
local function Say(Ply, Msg)
    return (Ply == 0 and cprint(Msg, 10) or rprint(Ply, Msg))
end

-- Used to format messages:
-- @Return Formatted message [string]
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

-- Return the next map array:
-- @Param i (map array index)
-- @Return {next map array, next map array index}
--
local function GetNextMap(i)
    i = (i + 1)
    local next = maps[i]
    return {
        next and next or maps[1],
        next and i or 1
    }
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
            next_map = GetNextMap(i)
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
local function ShowNextMap(Ply, next_map)
    local txt = output[2]
    local t, i = next_map[1], next_map[2]
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
        map = get_var(0, "$map"):lower()
        mode = get_var(0, "$mode"):lower()
    end
end

function OnScriptUnload()
    -- N/A
end