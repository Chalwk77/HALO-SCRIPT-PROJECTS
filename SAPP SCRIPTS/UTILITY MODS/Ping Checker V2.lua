--[[
--=====================================================================================================--
Script Name: Ping Checker V2, for SAPP (PC & CE)
Description: A simple addon to check your ping (or others)

Copyright (c) 2020, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE

* Written by Jericho Crosby (Chalwk)
--=====================================================================================================--
]]--

-- Config Starts
local ping_command = "ping"
local permission_level = -1
local messages = {
    "Your ping is %ping%",
    "%name%'s ping is %ping%",
    "Invalid Player ID. Usage: /%cmd% [number: 1-16] | */all | me",
    "Something went wrong. Unable to get %name%'s ping Please try again!"
}

-- Config Ends

api_version = "1.12.0.0"
local gmatch, gsub = string.gmatch, string.gsub

function OnScriptLoad()
    register_callback(cb["EVENT_COMMAND"], "OnServerCommand")
end

local hasAccess = function(PlayerIndex)
    return (tonumber(get_var(PlayerIndex, "$lvl")) >= permission_level)
end

function OnServerCommand(Executor, Command, _, _)
    local Args = CmdSplit(Command)
    if (Args[1] == nil or Args[1] == "") then
        return
    elseif (Args[1] == ping_command) and hasAccess(Executor) then

        local pl = GetPlayers(Executor, Args)
        if (pl) then
            for i = 1, #pl do
                local TargetID = pl[i]
                local ping = GetPing(TargetID)
                if (ping) then
                    if (tonumber(TargetID) == tonumber(Executor)) then
                        rprint(Executor, gsub(messages[1], "%%ping%%", ping))
                    else
                        local name = get_var(TargetID, "$name")
                        rprint(Executor, gsub(gsub(messages[2], "%%ping%%", ping), "%%name%%", name))
                    end
                else
                    rprint(Executor, messages[4])
                end
            end
        end
        return false
    end
end

function OnScriptUnload()

end

function GetPlayers(Executor, Args)
    local pl = { }
    if (Args[2] == nil or Args[2] == "me") then
        table.insert(pl, Executor)
    elseif (Args[2]:match("%d+") and player_present(Args[2])) then
        table.insert(pl, Args[2])
    elseif (Args[2] == "all" or Args[2] == "*") then
        for i = 1, 16 do
            if player_present(i) then
                table.insert(pl, i)
            end
        end
    else
        rprint(Executor, gsub(messages[3], "%%cmd%%", Args[1]))
    end
    return pl
end

function CmdSplit(CMD)
    local t, i = {}, 1
    for Args in gmatch(CMD, "([^%s]+)") do
        t[i] = Args
        i = i + 1
    end
    return t
end

function GetPing(TargetID)
    if (TargetID ~= 0) then
        local player = get_player(TargetID)
        if (player) then
            return read_word(player + 0xDC)
        end
    else
        cprint("You cannot execute this command from the server terminal", 4 + 8)
    end
end
