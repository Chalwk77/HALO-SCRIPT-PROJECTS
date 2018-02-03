--[[
--=====================================================================================================--
Script Name: Welcome Message, for SAPP (PC & CE)
Description: This mod was requested by someone called mdc81 on opencarnage.net for use on their private server.

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
  	say(PlayerIndex, "Welcome Friend " .. get_var(PlayerIndex, "$name"))
end
