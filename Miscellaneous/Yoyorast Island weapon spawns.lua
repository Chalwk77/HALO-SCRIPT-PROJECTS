--[[
    ------------------------------------
Script Name: Yoyoroast (spawn with sniper), for SAPP | (PC\CE)

This script was requested!


* A simplified version of my Custom Weapon spawn script. 
* Designed for use on the Yoyorast Island V2 map only.
* Player's will only spawn with the sniper rifle.

Copyright (c) 2016-2017, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE

* IGN: Chalwk
* Written by Jericho Crosby (Chalwk)
-----------------------------------
]]--

api_version = "1.12.0.0"
bool = { }
weapons = { }
weapons[1] = "deathstar\\Yoyorast Island V2\\weapon\\tag_1769"

function OnScriptLoad()
    register_callback(cb["EVENT_TICK"], "OnTick")
    register_callback(cb['EVENT_SPAWN'], "OnPlayerSpawn")
end

function OnScriptUnload()

end

function OnPlayerSpawn(PlayerIndex)
    bool[PlayerIndex] = true
end


function OnTick()
    for i = 1, 16 do
        if (player_alive(i)) then
            local player = get_dynamic_player(i)
            if (bool[i] == true) then
                execute_command("wdel " .. i)
                local x, y, z = read_vector3d(player + 0x5C)
                assign_weapon(spawn_object("weap", weapons[1], x, y, z), i)
                bool[i] = false
            end
        end
    end
end
