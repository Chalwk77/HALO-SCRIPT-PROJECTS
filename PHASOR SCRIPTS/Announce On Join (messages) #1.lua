--[[
------------------------------------
Script Name: Welcome Message #1, for PHASOR

Description: Extremely simple welcome message handler. 
          
This script is also available on my github! Check my github for regular updates on my projects, including this script.
https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS

Copyright (c) 2016-2017, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE

* IGN: Chalwk
* Written by Jericho Crosby
-----------------------------------
]]--


AnnounceMessage = "Welcome to <input here>"

function GetRequiredVersion()
    return 200
end

function OnScriptLoad(processid, game, persistent) end
function OnScriptUnload() end

function OnPlayerJoin(player)
    privatesay(player, AnnounceMessage, false)
end
