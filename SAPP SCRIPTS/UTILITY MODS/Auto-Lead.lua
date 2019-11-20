--[[
--=====================================================================================================--
Script Name: Auto-Lead, for SAPP (PC & CE)
Description: Automatically turns No-Lead on/off on a per-map/per-gametype basis.
             You can have as many game types per map table as you like.
            
Copyright (c) 2019, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE

* Written by Jericho Crosby (Chalwk)
--======================================================================================================--
]]--

api_version = "1.12.0.0"

local settings = {

    -- Example: ["mapname"] = {["lnz-zombies"] = 1, ["epic-tslayer"] = 0},
    -- 1 = on, 0 = off
        
    ["beavercreek"] = {["gt1"] = 1, ["gt2"] = 1, ["gt3"] = 1},
    
    ["bloodgulch"] = {["gt1"] = 1, ["gt2"] = 1, ["gt3"] = 1},
    
    ["boardingaction"] = {["gt1"] = 1, ["gt2"] = 1, ["gt3"] = 1},
    
    ["carousel"] = {["gt1"] = 1, ["gt2"] = 1, ["gt3"] = 1},
    
    ["dangercanyon"] = {["gt1"] = 1, ["gt2"] = 1, ["gt3"] = 1},
    
    ["deathisland"] = {["gt1"] = 1, ["gt2"] = 1, ["gt3"] = 1},
    
    ["gephyrophobia"] = {["gt1"] = 1, ["gt2"] = 1, ["gt3"] = 1},
    
    ["icefields"] = {["gt1"] = 1, ["gt2"] = 1, ["gt3"] = 1},
    
    ["infinity"] = {["gt1"] = 1, ["gt2"] = 1, ["gt3"] = 1},
    
    ["sidewinder"] = {["gt1"] = 1, ["gt2"] = 1, ["gt3"] = 1},
    
    ["timberland"] = {["gt1"] = 1, ["gt2"] = 1, ["gt3"] = 1},
    
    ["hangemhigh"] = {["gt1"] = 1, ["gt2"] = 1, ["gt3"] = 1},
    
    ["ratrace"] = {["gt1"] = 1, ["gt2"] = 1, ["gt3"] = 1},
    
    ["damnation"] = {["gt1"] = 1, ["gt2"] = 1, ["gt3"] = 1},
    
    ["putput"] = {["gt1"] = 1, ["gt2"] = 1, ["gt3"] = 1},
    
    ["prisoner"] = {["gt1"] = 1, ["gt2"] = 1, ["gt3"] = 1},
    
    ["wizard"] = {["gt1"] = 1, ["gt2"] = 1, ["gt3"] = 1},
    
    -- repeat the structure to add more maps
    ["mapname"] = {["gametype here"] = 1},
    
}


function OnScriptLoad()
    register_callback(cb["EVENT_GAME_START"], "OnGameStart")
    if (get_var(0, "$gt") ~= "n/a") then
        timer(1000, "SetLead")
    end
end

function OnGameStart()
    if (get_var(0, "$gt") ~= "n/a") then
        timer(1000, "SetLead")
    end
end

function SetLead()
    local current_map = get_var(0, "$map")
    local state = get_var(0, "$mode")
    for mapname,gametype in pairs(settings) do
        if (current_map == mapname) and (gametype[state] ~= nil) then
            execute_command("no_lead " .. tostring(gametype[state]))
        end
    end
end

function OnScriptUnload()

end
