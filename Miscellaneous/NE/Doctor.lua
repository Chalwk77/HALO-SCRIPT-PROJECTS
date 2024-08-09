--[[
--=====================================================================================================--
Script Name: Doctor, Doctor!, for SAPP (PC & CE)
Description: Call a doctor!

Copyright (c) 2022, Jericho Crosby <jericho.crosby227@gmail.com>
Notice: You can use this script subject to the following conditions:
https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/blob/master/LICENSE
--=====================================================================================================--
]]

-------------------
-- config starts --
-------------------
-- Custom command to call a doctor:
-- Syntax: /command
local command = "dr"

-- Health will regen in increments of this amount:
local increment = 0.1016

-- Minimum permission level required to execute the /command:
-- All players = -1
-- Admins = levels 1-4
local permission_level = -1

-- Customizable messages:
local messages = {
    [1] = "Health is regenerating...",
    [2] = "You already have full health!",
    [3] = "You do not have permission to execute that command!",
}
-----------------
-- config ends --
-----------------

api_version = "1.12.0.0"

function OnScriptLoad()
    register_callback(cb['EVENT_COMMAND'], "OnCommand")
end

local lower = string.lower
local gmatch = string.gmatch
local function CMDSplit(CMD)
    local args = {}
    for params in gmatch(CMD, "([^%s]+)") do
        args[#args + 1] = lower(params)
    end
    return args
end

local function GetHealth(DyN)
    return read_float(DyN + 0xE0)
end

function Regen(DyN, Ply)
    if (DyN ~= 0 and player_alive(Ply)) then
        local health = GetHealth(DyN)
        if (health < 1) then
            write_float(DyN + 0xE0, (health + increment > 1 and 1) or increment)
        elseif (health == 1) then
            return false
        end
    end
    return true
end

function OnCommand(Ply, CMD)
    local args = CMDSplit(CMD)
    if (args[1] == command) then
        local lvl = tonumber(get_var(Ply, "$lvl"))
        if (lvl >= permission_level) then
            if (player_alive(Ply)) then
                local DyN = get_dynamic_player(Ply)
                local health = GetHealth(DyN)
                if (health == 1) then
                    rprint(Ply, messages[2])
                else
                    rprint(Ply, messages[1])
                    timer(1000, "Regen", DyN, Ply)
                end
            else
                rprint("Please wait until you respawn!")
            end
        else
            rprint(Ply, messages[3])
        end
        return false
    end
end

function OnScriptUnload()
    -- N/A
end