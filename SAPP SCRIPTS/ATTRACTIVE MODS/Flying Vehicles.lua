--[[
--=====================================================================================================--
Script Name: Flying Vehicles, for SAPP (PC & CE)
Description: Fly vehicles that normally do not fly!

Copyright (c) 2021, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/blob/master/LICENSE
--=====================================================================================================--
]]--

api_version = "1.12.0.0"

-- config starts --
local FlyingVehicles = {

    -- This is the custom command used to toggle fly on/off:
    base_command = "fly",
    --

    -- Minimum permission required to turn fly mode on or off
    permission = 1,

    -- Should Flying Vehicles be reset when no one is online?
    no_players_reset = true,

    vehicles = {
        -- set to false to disable flying for specific vehicles:
        ["vehicles\\ghost\\ghost_mp"] = false,
        ["vehicles\\rwarthog\\rwarthog"] = true,
        ["vehicles\\warthog\\mp_warthog"] = true,
        ["vehicles\\banshee\\banshee_mp"] = false,
        ["vehicles\\scorpion\\scorpion_mp"] = false,
        ["vehicles\\c gun turret\\c gun turret_mp"] = false
    }
}
-- config ends --

api_version = "1.12.0.0"

local tag_address, tag_count

function OnScriptLoad()
    register_callback(cb["EVENT_COMMAND"], "OnCommand")
    register_callback(cb["EVENT_LEAVE"], "OnPlayerQuit")
    register_callback(cb["EVENT_GAME_START"], "OnGameStart")
    OnGameStart()
end

function OnScriptUnload()
    FlyingVehicles:Toggle()
end

function OnGameStart()
    if (get_var(0, "$gt") ~= "n/a") then
        tag_address = read_dword(0x40440000)
        tag_count = read_dword(0x4044000C)
        FlyingVehicles:Toggle()
    end
end

function FlyingVehicles:Quit()
    local count = tonumber(get_var(0, "$pn"))
    if (count - 1 == 0 and self.rollback) then
        self:Toggle()
    end
end

local function CMDSplit(CMD)
    local Args = { }
    for STR in CMD:gmatch("([^%s]+)") do
        Args[#Args + 1] = STR:lower()
    end
    return Args
end

function FlyingVehicles:OnCommand(Ply, CMD, _, _)
    local Args = CMDSplit(CMD)
    if (Args and Args[1] == self.base_command) then
        local lvl = tonumber(get_var(Ply, "$lvl"))
        if (lvl >= self.permission) then
            local toggled = (self.rollback)
            local state = Args[2]
            if (not state) then

                state = toggled
                if (state) then
                    state = "activated"
                else
                    state = "not activated"
                end
                rprint(Ply, "Flying Vehicles " .. state)

            elseif (state == "on" or state == "1" or state == "true") then
                state = "enabled"
            elseif (state == "off" or state == "0" or state == "false") then
                state = "disabled"
            else
                state = nil
            end

            if (toggled and state == "enabled" or not toggled and state == "disabled") then
                rprint(Ply, "Flying Vehicles already " .. state)
            elseif (state) then
                self:Toggle(state)
                say_all("Flying Vehicles " .. state)
            else
                rprint(Ply, "Invalid Command Argument.")
                rprint(Ply, 'Usage: "on", "1", "true", "off", "0" or "false"')
            end
        else
            rprint(Ply, "You do not have permission to execute that command")
        end
        return false
    end
end

function FlyingVehicles:Toggle(state)
    if (state == "enabled") then
        for i = 0, tag_count - 1 do
            local offset = tag_address + 0x20 * i
            if (read_dword(offset) == 1986357353) then
                local tag_name = read_string(read_dword(offset + 0x10))
                for tag, enabled in pairs(self.vehicles) do
                    if (tag_name == tag and enabled) then
                        local data = read_dword(offset + 0x14)
                        local value = read_word(data + 0x2F4)
                        if (value == 0 or value == 1 or value == 2 or value == 4) then
                            self.rollback = self.rollback or { }
                            self.rollback[#self.rollback + 1] = { data + 0x2F4, read_word(data + 0x2F4) }
                            write_word(data + 0x2F4, 0x3)
                        end
                    end
                end
            end
        end
        return
    elseif (self.rollback) then
        for _, v in pairs(self.rollback) do
            write_word(v[1], v[2])
        end
        self.rollback = nil
    end
end

function OnCommand(P, C)
    return FlyingVehicles:OnCommand(P, C)
end

function OnPlayerQuit()
    return FlyingVehicles:Quit()
end