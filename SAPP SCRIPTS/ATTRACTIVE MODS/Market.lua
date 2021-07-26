--[[
--=====================================================================================================--
Script Name: Market, for SAPP (PC & CE)
Description: Gain +30 points for every kill.
             Use these points to buy one of the following:

             Camouflage ($60, 30 seconds)
             God Mode ($200, 30 seconds)
             Grenades (frags/plasmas) - ($30 each, 2x)
             Overshield ($60, full shield)
             Health ($100, full health)
             Speed Boost ($60, 1.3x)

             Easily edit custom command, price, duration and catalogue message.

             Catalogue command: /market
             Used to view available items for purchase.

Credits: "upmx" for requesting the script on Open Carnage:Market
https://opencarnage.net/index.php?/topic/7112-change-points-for-an-item-a-market/

Copyright (c) 2021, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/blob/master/LICENSE
--=====================================================================================================--
]]--

api_version = "1.12.0.0"

local Market = {

    -- Starting balance (on join):
    starting_balance = 0,

    -- Points per kill:
    points = 30,

    -- Message seen on kill.
    message = "+%money%->%total%",

    -- Command used to view available items for purchase:
    catalogue_command = "market",

    Commands = {

        -- Camouflage:
        -- ["SAPP COMMAND EXECUTED"] = {"custom command", price, duration, catalogue message}
        ["camo"] = { "m1", 60, 30, "-60 -> Camo (30 seconds)" },


        --
        -- God Mode:
        -- ["SAPP COMMAND EXECUTED"] = {"custom command", price, duration, catalogue message}
        ["god"] = { "m2", 200, 30, "-200 -> God (30 seconds)" },


        --
        -- Frags:
        -- ["SAPP COMMAND EXECUTED"] = {"custom command", price, total, catalogue message}
        ["nades"] = { "m3", 30, 2, "-30 -> Frags (x2)" },


        --
        -- Plasmas:
        -- ["SAPP COMMAND EXECUTED"] = {"custom command", price, total, catalogue message}
        ["plasmas"] = { "m4", 30, 2, "-30 -> Plasmas (x2)" },


        --
        -- Speed Boost:
        -- ["SAPP COMMAND EXECUTED"] = {"custom command", price, speed, catalogue message}
        ["s"] = { "m5", 60, 1.3, "-60 -> Speed Boost (1.3x)" },


        --
        -- Overshield:
        -- ["SAPP COMMAND EXECUTED"] = {"custom command", price, state, catalogue message}
        ["sh"] = { "m6", 100, 1, "-100 -> Camo (full shield)" },


        --
        -- Health:
        -- ["SAPP COMMAND EXECUTED"] = {"custom command", price, h-points, catalogue message}
        ["hp"] = { "m7", 100, 1, "-100 -> HP (full health)" },
    }
}

function OnScriptLoad()
    register_callback(cb["EVENT_COMMAND"], "OnCommand")
    register_callback(cb["EVENT_DIE"], "OnPlayerDeath")
end

function OnPlayerDeath(VictimIndex, KillerIndex)
    local k = tonumber(KillerIndex)
    local v = tonumber(VictimIndex)
    if (k > 0 and player_present(k) and k ~= v) then

        local points = Market.points
        local score = tonumber(get_var(k, "$score"))

        local total = (score + points)
        execute_command("score " .. k .. " " .. total)

        rprint(k, Market.message:gsub("%%money%%", points):gsub("%%total%%", total))
    end
end

function OnCommand(Ply, CMD, _, _)

    local Args = { }
    for Params in CMD:gmatch("([^%s]+)") do
        Args[#Args + 1] = Params:lower()
    end

    if (#Args[1] > 0) then

        local response
        for cmd, v in pairs(Market.Commands) do

            if (Args[1] == Market.catalogue_command) then
                rprint(Ply, "/" .. cmd .. " " .. v[#v])
                response = false
            elseif (Args[1] == v[1]) then
                local score = tonumber(get_var(Ply, "$score"))
                if (score >= v[2]) then
                    rprint(Ply, v[#v])
                    execute_command(cmd .. " " .. Ply .. " " .. v[3])
                    execute_command("score " .. Ply .. " " .. score - v[2])
                    response = false
                else
                    say(Ply, "You do not have enough money!")
                    response = false
                end
                response = false
            end
        end

        return response
    end
end

function OnScriptUnload()
    -- N/A
end