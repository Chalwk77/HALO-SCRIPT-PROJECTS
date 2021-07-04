--[[
--=====================================================================================================--
Script Name: Custom Wdel, for SAPP (PC & CE)
Description: This script overrides SAPP's built-in wdel command.
             The flag will not be removed from a players inventory.

             Credits: "no one"
             Request Link: https://opencarnage.net/index.php?/topic/7091-block-wdel-n-with-the-flag/

Copyright (c) 2021, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/blob/master/LICENSE
--=====================================================================================================--
]]--

-- config starts --

-- Custom command used to remove weapons:
-- Syntax: /command "me", "all", "*" or [#1-16]
-- Example: /wdel 1, or /wdel me, or /wdel *
local command = "wdel"

-- Permission level required to execute the custom command
local permission_required = 1
-- config ends --

api_version = "1.12.0.0"

function OnScriptLoad()
    register_callback(cb["EVENT_COMMAND"], "OnCommand")
end

local function Respond(Ply, Msg)
    if (Ply == 0) then
        cprint(Msg)
    else
        rprint(Ply, Msg)
    end
end

local function GetPlayers(Ply, Args)

    local players = { }
    local TID = Args[2]

    if (TID == nil or TID == "me") then
        table.insert(players, Ply)
    elseif (TID == "all" or TID == "*") then
        for i = 1, 16 do
            if player_present(i) then
                table.insert(players, i)
            end
        end
    elseif (TID:match("%d+") and tonumber(TID:match("%d+")) > 0) then
        if player_present(TID) then
            table.insert(players, TID)
        else
            Respond(Ply, "Player #" .. TID .. " is not online!")
        end
    else
        Respond(Ply, "Invalid Target ID Parameter")
        Respond(Ply, 'Usage: "me", "all", "*" or [#1-16]')
    end

    return players
end

local function GetWeapons(DyN)
    local weapons = { }
    for i = 0, 3 do
        local weapon = read_dword(DyN + 0x2F8 + 0x4 * i)
        if (weapon ~= 0xFFFFFFFF) then
            local object = get_object_memory(weapon)
            if (object ~= 0) then
                local tag_address = read_word(object)
                local tag_data = read_dword(read_dword(0x40440000) + tag_address * 0x20 + 0x14)
                if (read_bit(tag_data + 0x308, 3) ~= 1) then
                    weapons[#weapons + 1] = weapon
                end
            end
        end
    end
    return weapons
end

function OnCommand(Ply, CMD, _, _)

    local Args = { }
    for Params in CMD:gmatch("([^%s]+)") do
        Args[#Args + 1] = Params:lower()
    end

    if (#Args[1] > 0 and Args[1] == command) then
        local lvl = tonumber(get_var(Ply, "$lvl"))
        if (lvl >= permission_required or Ply == 0) then
            local pl = GetPlayers(Ply, Args)
            if (pl) then

                for PID = 1, #pl do

                    local TID = tonumber(pl[PID])
                    local name = get_var(TID, "$name")

                    if (player_alive(TID)) then

                        local DyN = get_dynamic_player(TID)
                        if (DyN ~= 0) then

                            local stdout = true
                            local weapons = GetWeapons(DyN)

                            for _, weapon in pairs(weapons) do
                                destroy_object(weapon)
                                if (stdout) then
                                    stdout = false
                                    Respond(Ply, "Weapons removed for " .. name)
                                end
                            end
                        end
                    else
                        Respond(Ply, name .. " is not alive!")
                    end
                end
            end
        else
            Respond(Ply, "You do not have permission execute this command!")
        end

        return false
    end
end

function OnScriptUnload()
    -- N/A
end