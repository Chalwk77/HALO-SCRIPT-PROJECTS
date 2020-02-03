--[[
--=====================================================================================================--
Script Name: Resupply (v1.2), for SAPP (PC & CE)
Description: Use a custom command to resupply your inventory with grenades and ammo.

A more advanced version of this will come at a later date.

Copyright (c) 2019, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE

* Written by Jericho Crosby (Chalwk)
--=====================================================================================================--
]]--

api_version = "1.12.0.0"

-- Configuration [starts]
local command_aliases = {
    "res",
    "sup",
    "resupply",
}
local privilege_level = -1
local ammo, mag = 200, 500
local grenades = 4
local battery = 100 -- Full battery
local message = "[RESUPPLY] +%ammo% ammo, +%mag% mag, +%grenades% grenades, %battery%% battery"
-- Configuration [ends].

local lower, gsub = string.lower, string.gsub
function OnScriptLoad()
    register_callback(cb["EVENT_COMMAND"], "OnServerCommand")
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
        cprint("This command cannot be executed from console.")
    end
end

function OnServerCommand(PlayerIndex, Command)
    local command, args = cmdsplit(Command)
    local executor = tonumber(PlayerIndex)
    local response
    for i = 1, #command_aliases do
        if (command == lower(command_aliases[i])) then
            if (checkAccess(executor)) then
                if (args[2] == nil) then
                    if player_alive(executor) then
                        for weapon = 1, 4 do
                            execute_command("ammo " .. executor .. " " .. ammo .. " " .. weapon)
                            execute_command("mag " .. executor .. " " .. mag .. " " .. weapon)
                            execute_command("battery " .. executor .. " " .. battery .. " " .. weapon)
                        end
                        execute_command("nades " .. executor .. " " .. grenades)
                        rprint(executor, gsub(gsub(gsub(gsub(message, "%%ammo%%", ammo), "%%mag%%", mag), "%%grenades%%", grenades), "%%battery%%", battery))
                    else
                        rprint(executor, "Please wait until you respawn.")
                    end
                else
                    rprint(executor, "Invalid syntax. Usage: /" .. command_aliases[i])
                end
            end
            response = false
            break
        end
    end
    return response
end

function cmdsplit(str)
    local subs = {}
    local sub = ""
    local ignore_quote, inquote, endquote
    for i = 1, string.len(str) do
        local bool
        local char = string.sub(str, i, i)
        if char == " " then
            if (inquote and endquote) or (not inquote and not endquote) then
                bool = true
            end
        elseif char == "\\" then
            ignore_quote = true
        elseif char == "\"" then
            if not ignore_quote then
                if not inquote then
                    inquote = true
                else
                    endquote = true
                end
            end
        end

        if char ~= "\\" then
            ignore_quote = false
        end

        if bool then
            if inquote and endquote then
                sub = string.sub(sub, 2, string.len(sub) - 1)
            end

            if sub ~= "" then
                table.insert(subs, sub)
            end
            sub = ""
            inquote = false
            endquote = false
        else
            sub = sub .. char
        end

        if i == string.len(str) then
            if string.sub(sub, 1, 1) == "\"" and string.sub(sub, string.len(sub), string.len(sub)) == "\"" then
                sub = string.sub(sub, 2, string.len(sub) - 1)
            end
            table.insert(subs, sub)
        end
    end

    local cmd = subs[1]
    local args = subs
    table.remove(args, 1)

    return cmd, args
end
