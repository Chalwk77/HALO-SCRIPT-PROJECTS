--[[
--======================================================================================================--
Script Name: Beep On Join, for SAPP (PC & CE)
Description: Added a new script that produces an audible beep when someone joins the server.

Copyright (c) 2020, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/blob/master/LICENSE

* Written by Jericho Crosby (Chalwk)
--======================================================================================================--
]]--

api_version = "1.12.0.0"

function OnScriptLoad()
    register_callback(cb["EVENT_JOIN"], "OnPlayerConnect")
end

function OnPlayerConnect(_)
    os.execute("echo \7")
end

function OnScriptUnload()
    -- N/A
end