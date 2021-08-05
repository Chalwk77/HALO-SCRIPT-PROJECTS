--[[
--=====================================================================================================--
Script Name: Time Played, for SAPP (PC & CE)
Description: This script will let you check how much time
             a player has spent on the server and how many times they have joined.

Copyright (c) 2020-2021, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/blob/master/LICENSE
--=====================================================================================================--
]]--

api_version = "1.12.0.0"

local TimePlayed = {

    -- Custom command used to check play-time + join count:
    --
    command = "check",

    -- Minimum permission lvl required to execute "/check"
    --
    permission = 1,

    -- During what events should the TimePlayed.json database be updated?
    --
    update_file_database = {
        ["even_game_end"] = true,
        ["even_join"] = true,
        ["even_leave"] = true
    },

    -- A JSON database containing player stats.
    -- This file will be located in the server's root directory.
    --
    dir = "TimePlayed.json",

    -- Client data is saved as a json array.
    -- The array index for each client will either be "IP", or "IP:PORT".
    -- Set to 1 for IP-only indexing.
    --
    ClientIndexType = 2,
}

-- Preload JSON Interpreter Library:
--
local json = (loadfile "json.lua")()

local join_time = { }

function OnScriptLoad()

    -- register needed event callbacks:
    --

    register_callback(cb["EVENT_GAME_END"], "OnGameEnd")
    register_callback(cb["EVENT_JOIN"], "OnPlayerConnect")
    register_callback(cb["EVENT_GAME_START"], "OnGameStart")
    register_callback(cb["EVENT_COMMAND"], "OnServerCommand")
    register_callback(cb["EVENT_LEAVE"], "OnPlayerDisconnect")
    --

    TimePlayed:CheckFile(true)
end

function OnScriptUnload()
    TimePlayed:UpdateJSON()
end

function OnGameStart()
    TimePlayed:CheckFile()
end

function OnGameEnd()
    TimePlayed:UpdateJSON("even_game_end")
end

function TimePlayed:UpdateJSON(TYPE)
    if (self.update_file_database[TYPE]) then
        -- saves local database (self.database) to self.dir:
        --
        local db = self:GetLocalDB()
        if (db) then
            local file = assert(io.open(self.dir, "w"))
            if (file) then
                file:write(json:encode_pretty(db))
                file:close()
            end
        end
    end
end

function OnPlayerConnect(Ply)
    TimePlayed:AddNewPlayer(Ply, false)
end

function OnPlayerDisconnect(Ply)
    TimePlayed:UpdateJSON("event_leave")
    TimePlayed.players[Ply ~= nil and Ply] = nil
end

function TimePlayed:AddNewPlayer(Ply, ManualLoad)

    local ip = self:GetIP(Ply)
    local name = get_var(Ply, "$name")

    local db = self.database
    if (db[ip] == nil) then
        db[ip] = {
            ip = ip,
            time = 0, -- set initial play time to zero
            joins = 0,
            name = name,
        }
    end

    self.database = db

    self.players[Ply] = { }
    self.players[Ply] = db[ip]
    self.players[Ply].name = name -- update name
    self.players[Ply].joins = db[ip].joins + 1
    self.players[Ply].time = db[ip].time -- match time on file (last known time)

    join_time[Ply] = os.time()

    -- false when called from OnPlayerConnect()
    if (not ManualLoad) then
        self:UpdateJSON("event_join")
    end
end

function TimePlayed:GetLocalDB()
    local db = self.database
    if (db) then
        for i = 1, 16 do

            -- update self.database:
            --
            if (player_present(i) and self.players[i]) then

                local time = os.time() - join_time[i]
                self.players[i].time = self.players[i].time + time

                local ip = self:GetIP(i)
                db[ip] = self.players[i]
            end
        end
    end

    return db
end

function TimePlayed:CheckFile(ScriptLoad)

    if (ScriptLoad) then
        self.database = nil
    end

    self.players = { }
    self.game_started = false

    if (get_var(0, "$gt") ~= "n/a") then

        self.game_started = true

        if (self.database == nil) then

            local content = ""
            local file = io.open(self.dir, "r")
            if (file) then
                content = file:read("*all")
                file:close()
            end

            local records = json:decode(content)
            if (not records) then
                file = assert(io.open(self.dir, "w"))
                if (file) then
                    records = { }
                    file:write(json:encode_pretty(records))
                    file:close()
                end
            end

            self.database = records

            for i = 1, 16 do
                if player_present(i) then
                    self:AddNewPlayer(i, true)
                end
            end
        end
    end
end

local function secondsToTime(seconds)
    local years = math.floor(seconds / (60 * 60 * 24 * 365))
    seconds = seconds % (60 * 60 * 24 * 365)
    local weeks = math.floor(seconds / (60 * 60 * 24 * 7))
    seconds = seconds % (60 * 60 * 24 * 7)
    local days = math.floor(seconds / (60 * 60 * 24))
    seconds = seconds % (60 * 60 * 24)
    local hours = math.floor(seconds / (60 * 60))
    seconds = seconds % (60 * 60)
    local minutes = math.floor(seconds / 60)
    seconds = seconds % 60
    return years, weeks, days, hours, minutes, seconds
end

function TimePlayed:OnCommand(Ply, CMD)

    local Args = { }
    for Params in CMD:gmatch("([^%s]+)") do
        Args[#Args + 1] = Params:lower()
    end

    if (#Args > 0) then
        local lvl = tonumber(get_var(Ply, "$lvl"))
        if (Args[1] == self.command) then
            if (lvl >= self.permission) then
                local pl = self:GetPlayers(Ply, Args)
                if (pl) then
                    for i = 1, #pl do

                        local TID = tonumber(pl[i])

                        local session_time = join_time[TID]
                        local time_on_file = self.players[TID].time

                        local time = (os.time() + time_on_file) - session_time

                        -- convert time format:
                        local years, weeks, days, hours, minutes, seconds = secondsToTime(time)
                        time = "Y: " .. years .. " W: " .. weeks .. " D: " .. days .. " H: " .. hours .. " M: " .. minutes .. " S: " .. seconds
                        rprint(Ply, time)

                        rprint(Ply, " ") -- spacing

                        local joins = "Games Played: " .. self.players[TID].joins
                        rprint(Ply, joins)
                    end
                end
            else
                -- no permission
            end
            return false
        end
    end
end

function TimePlayed:Respond(Ply, Msg)
    if (Ply == 0) then
        cprint(Msg)
    else
        rprint(Ply, Msg)
    end
end

function TimePlayed:GetIP(Ply)
    local ip = get_var(Ply, "$ip")
    ip = ip or self.players[Ply].ip
    if (self.ClientIndexType == 1) then
        ip = ip:match("%d+.%d+.%d+.%d+")
    end
    return ip
end

function TimePlayed:GetPlayers(Executor, Args)
    local pl = { }
    if (Args[2] == "me" or Args[2] == nil) then
        if (Executor ~= 0) then
            table.insert(pl, Executor)
        else
            self:Respond(Executor, "The server cannot execute this command!", rprint, 10)
        end
    elseif (Args[2] ~= nil and Args[2]:match("^%d+$")) then
        if player_present(Args[2]) then
            table.insert(pl, Args[2])
        else
            self:Respond(Executor, "Player #" .. Args[2] .. " is not online", rprint, 10)
        end
    elseif (Args[2] == "all" or Args[2] == "*") then
        for i = 1, 16 do
            if player_present(i) then
                table.insert(pl, i)
            end
        end
        if (#pl == 0) then
            self:Respond(Executor, "There are no players online!", rprint, 10)
        end
    else
        self:Respond(Executor, "Invalid Command Syntax. Please try again!", rprint, 10)
    end
    return pl
end

function OnServerCommand(P, C)
    return TimePlayed:OnCommand(P, C)
end