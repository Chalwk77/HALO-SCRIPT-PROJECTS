--[[
--=====================================================================================================--
Script Name: One In The Chamber, for SAPP (PC & CE)
Description:

GAME MECHANICS:
1). Spawn with a pistol that has no ammo.
2). Melee someone to receive 1 bullet
3). Killing someone results in recieving 1 more bullet
4). When you die your bullet count is reset

Copyright (c) 2016-2018, Jericho Crosby <jericho.crosby227@gmail.com>
Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE
~ Created by Jericho Crosby (Chalwk)
--=====================================================================================================--
]]

api_version = '1.12.0.0'

function OnScriptLoad()
    register_callback(cb['EVENT_JOIN'], 'OnPlayerJoin')
end

function OnScriptUnload()

end

function OnPlayerJoin(PlayerIndex)

end
