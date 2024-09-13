--[[
--=====================================================================================================--
Script Name: Map Skip Tally, for SAPP (PC & CE)
Description: This script will create a historical record of map skips on a per-mode basis.

This script requires that the following JSON library is installed to your server:
http://regex.info/blog/lua/json

Place "json.lua" in your servers root directory (same location as sapp.dll).

The database of historical skips will be in a
file called "skip_tally.json" (located in the same directory as mapcycle.txt).

Copyright (c) 2022, Jericho Crosby <jericho.crosby227@gmail.com>
Notice: You can use this script subject to the following conditions:
https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/blob/master/LICENSE
--=====================================================================================================--
]]--

api_version = "1.12.0.0"

local file_name = 'skip_tally.json'
local query_cmd = 'tally'
local permission_level = 1
local deduct_on_quit = true

local dir, map, mode
local skipped, records = {}
local json = (loadfile "json.lua")()
local open = io.open

function OnScriptLoad()
    dir = read_string(read_dword(sig_scan('68??????008D54245468') + 0x1)) .. '\\sapp\\' .. file_name
    register_callback(cb['EVENT_CHAT'], 'OnChat')
    register_callback(cb['EVENT_JOIN'], 'OnJoin')
    register_callback(cb['EVENT_LEAVE'], 'OnQuit')
    register_callback(cb['EVENT_GAME_END'], 'OnEnd')
    register_callback(cb['EVENT_COMMAND'], 'QuerySkips')
    register_callback(cb['EVENT_GAME_START'], 'OnStart')
    OnStart()
end

local function Write(Content)
    local file = assert(open(dir, "w"))
    file:write(json:encode_pretty(Content))
    file:close()
end

function OnStart()
    if get_var(0, "$gt") ~= "n/a" then
        records = {}
        map = get_var(0, "$map")
        mode = get_var(0, "$mode")

        local file = open(dir, "r")
        local content = file and file:read("*all") or ""
        if file then file:close() end

        local data = json:decode(content) or {}
        data[map] = data[map] or {}
        data[map][mode] = data[map][mode] or 0
        Write(data)
        records = data
    end
end

function OnJoin(Ply)
    skipped[Ply] = false
end

function OnQuit(Ply)
    if deduct_on_quit and skipped[Ply] then
        records[map][mode] = records[map][mode] - 1
    end
    skipped[Ply] = nil
end

function OnEnd()
    for _, skip in pairs(skipped) do
        if skip then
            Write(records)
            break
        end
    end
end

function OnChat(Ply, Msg)
    if Msg:lower():match("skip") and not skipped[Ply] then
        skipped[Ply] = true
        records[map][mode] = records[map][mode] + 1
    end
end

local function Respond(Ply, Msg)
    if Ply == 0 then cprint(Msg) else rprint(Ply, Msg) end
end

local function HasPermission(Ply)
    return Ply == 0 or tonumber(get_var(Ply, '$lvl')) >= permission_level or Respond(Ply, 'Insufficient Permission')
end

function QuerySkips(Ply, CMD)
    if CMD:sub(1, #query_cmd):lower() == query_cmd and HasPermission(Ply) then
        Respond(Ply, map .. "/" .. mode .. ": " .. records[map][mode])
        return false
    end
end

function OnScriptUnload()
    -- N/A
end