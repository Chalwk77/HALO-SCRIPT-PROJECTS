--[[
--=====================================================================================================--
Script Name: Map Skip Tally, for SAPP (PC & CE)
Description: This script will create a historical record of map skips.

This script requires that the following json library is installed to your server:
Place "json.lua" in your servers root directory (same location as sapp.dll).

http://regex.info/blog/lua/json

--
--
The database of historical skips will be in a 
file called "skip_tally.json" (locatd in the same directory as mapcycle.txt).
--
--

Copyright (c) 2022, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/blob/master/LICENSE
--=====================================================================================================--
]]--

-- config starts --

-- Name of the database file:
--
local file_name = "skip_tally.json"

-- Command used to check historical skips:
--
local query_cmd = "tally"

-- Minimum permission level required to execute /query_cmd:
--
local permission_level = 1

-- config ends --

api_version = "1.12.0.0"

local dir, map, mode
local skipped, records = { }, { }
local json = (loadfile "json.lua")()

function OnScriptLoad()

    local path = read_string(read_dword(sig_scan("68??????008D54245468") + 0x1))
    dir = path .. "\\sapp\\" .. file_name

    register_callback(cb["EVENT_CHAT"], "OnChat")
    register_callback(cb["EVENT_JOIN"], "OnJoin")
    register_callback(cb["EVENT_LEAVE"], "OnQuit")
    register_callback(cb["EVENT_GAME_END"], "OnEnd")
    register_callback(cb["EVENT_COMMAND"], "QuerySkips")
    register_callback(cb["EVENT_GAME_START"], "OnStart")

    Setup()
end

function OnStart()
    Setup()
end

function OnJoin(Ply)
    skipped[Ply] = false
end

function OnQuit(Ply)
    if (skipped[Ply]) then
        records[map][mode] = records[map][mode] - 1
    end
end

function OnEnd()
    local file = assert(io.open(dir, "w"))
    if (file) then
        file:write(json:encode_pretty(records))
        io.close(file)
    end
end

function OnChat(Ply, Msg)
    if Msg:lower():match("skip") and not skipped[Ply] then
        skipped[Ply] = true
        records[map][mode] = records[map][mode] + 1
    end
end

local function Respond(Ply, Msg)
    return (Ply == 0 and cprint(Msg) or rprint(Ply, Msg))
end

local function HasPermission(Ply)
    local lvl = tonumber(get_var(Ply, "$lvl"))
    return (Ply == 0 or lvl >= permission_level or Respond(Ply, "Insufficient Permission"))
end

function QuerySkips(Ply, CMD, _, _)
    if (CMD:sub(1, query_cmd:len()):lower() == query_cmd and HasPermission(Ply)) then
        Respond(Ply, map .. "/" .. mode .. ": " .. records[map][mode])
        return false
    end
end

local function Write(Content)
    local file = assert(io.open(dir, "w"))
    if (file) then
        file:write(json:encode_pretty(Content))
        io.close(file)
    end
end

function Setup()
    if get_var(0, "$gt") ~= "n/a" then

        records = { }
        map = get_var(0, "$map")
        mode = get_var(0, "$mode")

        local content = ""
        local file = io.open(dir, "r")
        if (file) then
            content = file:read("*all")
            io.close(file)
        end

        local data = json:decode(content)
        if (not data or not data[map]) then
            data = { [map] = { [mode] = 0 } }
            Write(data)
        elseif (not data[map][mode]) then
            data[map][mode] = 0
            Write(data)
        end

        records = data
    end
end

function OnScriptUnload()
    -- N/A
end