--[[
--=====================================================================================================--
Script Name: LoadOut, for SAPP (PC & CE)
Description: N/A

~ acknowledgements ~
Concept credit goes to OSH Clan, a gaming community operating on Halo CE.
- website:  https://oldschoolhalo.boards.net/

Copyright (c) 2020, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE

* Written by Jericho Crosby (Chalwk)
--=====================================================================================================--
]]--

api_version = "1.12.0.0"
-- Configuration Begins --
local loadout = {
    classes = {
        ["Regeneration"] = {
            command = "regen",
        },
        ["Armor Boost"] = {
            command = "armor",
        },
        ["Partial Camo"] = {
            command = "camo",
        },
        ["Recon"] = {
            command = "speed",
        }
    }
}
-- Configuration Ends --

local function Init()
    loadout.players = { }
    for i = 1, 16 do
        if player_present(i) then
            InitPlayer(i, false)
        end
    end
end

function OnScriptLoad()
    if (get_var(0, '$gt') ~= "n/a") then
        Init()
    end
end

function OnScriptUnload()

end

function OnGameStart()
    if (get_var(0, '$gt') ~= "n/a") then
        Init()
    end
end

function OnGameEnd()

end

function OnServerCommand(Executor, Command, _, _)

end

function OnTick()

end

function InitPlayer(Ply, Reset)
    if (Reset) then
        loadout.players[Ply] = { }
    else
        loadout.players[Ply] = {

        }
    end
end

function OnPlayerConnect(Ply)
    InitPlayer(Ply, false)
end

function OnPlayerDisconnect(Ply)
    InitPlayer(Ply, true)
end

function OnPlayerSpawn(Ply)

end