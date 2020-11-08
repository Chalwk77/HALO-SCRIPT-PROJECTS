--[[
--=====================================================================================================--
Script Name: Color Changer, for SAPP (PC & CE)
Description: Change any player's armor color on demand.

Command Syntax: 
    * /setcolor [player id | me | */all] [color id]
    "me" can be used in place of your own player id

    Valid Color IDS:
    white or 0
    black or 1
    red or 2
    blue or 3
    gray or 4
    yellow or 5
    green or 6
    pink or 7
    purple or 8
    cyan or 9
    cobalt or 10
    orange or 11
    teal or 12
    sage or 13
    brown or 14
    tan or 15
    maroon or 16
    salmon or 17

Copyright (c) 2019-2020, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE

* Written by Jericho Crosby (Chalwk)

- This script is included in the Velocity Multi-Mod with many improvements.
--=====================================================================================================--
]] --

api_version = "1.12.0.0"

-- configuration [starts]
local color = {
    command = "setcolor",
    permission = 1,
    permission_other = 4,
}
-- configuration [ends]

function OnScriptLoad()
    register_callback(cb['EVENT_COMMAND'], "OnServerCommand")
    register_callback(cb['EVENT_SPAWN'], "OnPlayerSpawn")
end

function OnScriptUnload()
    --
end

local function checkAccess(e)
    if (e ~= -1 and e >= 1 and e < 16) then
        if (tonumber(get_var(e, "$lvl"))) >= privilege_level then
            return true
        else
            rprint(e, "Command failed. Insufficient Permission.")
            return false
        end
    else
        cprint("You cannot execute this command from the console.", 4 + 8)
        return false
    end
end

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

function OnServerCommand(PlayerIndex, CMD)
    local Args = CMDSplit(CMD)

    if (command == lower(base_command)) then
        if (checkAccess(executor)) then
            if not isTeamPlay() then
                if (args[1] ~= nil) then
                    is_error = false
                    validate_params()
                    if not (target_all_players) then
                        if not (is_error) and isOnline(TargetID, executor) then
                            color:change(players)
                        end
                    end
                else
                    rprint(executor, "Invalid syntax. Usage: /" .. base_command .. " [player id] [color id]")
                end
            else
                rprint(executor, "This command doesn't work on Team-Based games.")
            end
        end
        return false
    end
end

function color:change(params)
    local params = params or {}

    local executor_id = params.eid or nil
    local target_id = params.tid or nil
    local target_name = params.tn or nil

    local color = params.color or nil

    local function getplayer(PlayerIndex)
        if tonumber(PlayerIndex) then
            if tonumber(PlayerIndex) ~= 0 then
                local m_player = get_player(PlayerIndex)
                if m_player ~= 0 then
                    return m_player
                end
            end
        end
        return nil
    end

    if player_alive(target_id) then
        local player_object = get_dynamic_player(target_id)
        local player_obj_id = read_dword(get_player(target_id) + 0x34)
        local m_player = getplayer(target_id)
        if player_object then
            local ERROR
            local x, y, z = read_vector3d(player_object + 0x5C)
            if color == "white" or color == "0" then
                write_byte(m_player + 0x60, 0)
            elseif color == "black" or color == "1" then
                write_byte(m_player + 0x60, 1)
            elseif color == "red" or color == "2" then
                write_byte(m_player + 0x60, 2)
            elseif color == "blue" or color == "3" then
                write_byte(m_player + 0x60, 3)
            elseif color == "gray" or color == "4" then
                write_byte(m_player + 0x60, 4)
            elseif color == "yellow" or color == "5" then
                write_byte(m_player + 0x60, 5)
            elseif color == "green" or color == "6" then
                write_byte(m_player + 0x60, 6)
            elseif color == "pink" or color == "7" then
                write_byte(m_player + 0x60, 7)
            elseif color == "purple" or color == "8" then
                write_byte(m_player + 0x60, 8)
            elseif color == "cyan" or color == "9" then
                write_byte(m_player + 0x60, 9)
            elseif color == "cobalt" or color == "10" then
                write_byte(m_player + 0x60, 10)
            elseif color == "orange" or color == "11" then
                write_byte(m_player + 0x60, 11)
            elseif color == "teal" or color == "12" then
                write_byte(m_player + 0x60, 12)
            elseif color == "sage" or color == "13" then
                write_byte(m_player + 0x60, 13)
            elseif color == "brown" or color == "14" then
                write_byte(m_player + 0x60, 14)
            elseif color == "tan" or color == "15" then
                write_byte(m_player + 0x60, 15)
            elseif color == "maroon" or color == "16" then
                write_byte(m_player + 0x60, 16)
            elseif color == "salmon" or color == "17" then
                write_byte(m_player + 0x60, 17)
            else
                rprint(executor_id, "Invalid Color")
                ERROR = true
            end
            if not (ERROR) then
                if (player_obj_id ~= nil) then
                    rprint(executor_id, target_name .. " had their color changed to " .. color)
                    destroy_object(player_obj_id)
                    if colorspawn == nil then
                        colorspawn = { }
                    end
                    if colorspawn[target_id] == nil then
                        colorspawn[target_id] = { }
                    end
                    colorspawn[target_id][1], colorspawn[target_id][2], colorspawn[target_id][3] = x, y, z
                end
            end
        end
    else
        rprint(executor_id, get_var(target_id, "$name") .. " is not alive!")
    end
end

function OnPlayerSpawn(PlayerIndex)
    local player_object = get_dynamic_player(PlayerIndex)
    if player_object then
        if colorspawn == nil then
            colorspawn = { }
        end
        if colorspawn[PlayerIndex] == nil then
            colorspawn[PlayerIndex] = { }
        end
        if (player_object ~= 0) then
            if colorspawn[PlayerIndex][1] then
                write_vector3d(get_dynamic_player(PlayerIndex) + 0x5C, colorspawn[PlayerIndex][1], colorspawn[PlayerIndex][2], colorspawn[PlayerIndex][3])
                colorspawn[PlayerIndex] = { }
            end
        end
    end
end

function isTeamPlay()
    if get_var(0, "$ffa") == "0" then
        return true
    else
        return false
    end
end

local function CMDSplit(CMD)
    local Args, index = { }, 1
    CMD = gsub(CMD, '"', "")
    for Params in gmatch(CMD, "([^%s]+)") do
        Args[index] = lower(Params)
        index = index + 1
    end
    return Args
end

function Mod:GetPlayers(Executor, Args, Pos)
    local pl = { }
    if (Args[Pos] == nil or Args[Pos] == "me" or Args[Pos] == "-gd" or Args[Pos] == "-seat" or Args[Pos] == "-amount") then
        if (Executor ~= 0) then
            table.insert(pl, Executor)
        else
            self:Respond(Executor, "Please enter a valid player id", 10)
        end
    elseif (Args[Pos] ~= nil) and (Args[Pos]:match("^%d+$")) then
        if player_present(Args[Pos]) then
            table.insert(pl, Args[Pos])
        else
            self:Respond(Executor, "Player #" .. Args[Pos] .. " is not online", 10)
        end
    elseif (Args[Pos] == "all" or Args[Pos] == "*") then
        for i = 1, 16 do
            if player_present(i) then
                table.insert(pl, i)
            end
        end
        if (#pl == 0) then
            self:Respond(Executor, "There are no players online!", 10)
        end
    else
        self:Respond(Executor, "Invalid Command Syntax. Please try again!", 10)
    end
    return pl
end

--[[
    Valid Color IDS:
    
    white or 0
    black or 1
    red or 2
    blue or 3
    gray or 4
    yellow or 5
    green or 6
    pink or 7
    purple or 8
    cyan or 9
    cobalt or 10
    orange or 11
    teal or 12
    sage or 13
    brown or 14
    tan or 15
    maroon or 16
    salmon 17
]]
