-- Snipers Dream Team Mod [Portals File] (v1.0)
-- Copyright (c) 2022, Jericho Crosby <jericho.crosby227@gmail.com>

local SDTM = {}

-- Called when a new game has started:
-- Loops through portals table: settings[map][portals]
-- Sets self.portals to the portal table.
function SDTM:Load()
    local map = self.map
    map = self.settings[map]
    if (map and map.portals and #map.portals > 0) then
        self.portals = (map.portals) or nil
    end
end

-- Make sure player is present, alive and isn't in a vehicle:
-- @Param Ply (player id)
-- @Return dyn (player memory address)
local function Valid(Ply)
    if (Ply and player_present(Ply) and player_alive(Ply)) then
        local dyn = get_dynamic_player(Ply)
        if (dyn ~= 0 and (read_dword(dyn + 0x11C) == 0xFFFFFFFF)) then
            return dyn
        end
    end
    return nil
end

-- Called every 1/30th second.
-- * Checks if a player is near a portal and teleports them.
function SDTM:PortalCheck()
    if (self.portals) then
        for i, _ in pairs(self.players) do
            local dyn = Valid(i)
            if (dyn) then
                local x, y, z = self:GetPos(dyn)
                for _, b in pairs(self.portals) do
                    local z_off = b[8] -- extra height above ground at destination z-coord
                    local dx, dy, dz = b[1], b[2], b[3] -- destination x,y,z
                    local trigger_distance = b[4] -- origin x,y,z trigger radius
                    if self:GetDist(x, y, z, dx, dy, dz) <= trigger_distance then
                        write_vector3d(dyn + 0x5C, b[5], b[6], b[7] + z_off)
                        goto next
                    end
                end
            end
            :: next ::
        end
    end
end

return SDTM
