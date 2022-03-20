-- Snipers Dream Team Mod [Entry Point File] (v1.0)
-- Copyright (c) 2022, Jericho Crosby <jericho.crosby227@gmail.com>

local root = './Snipers Dream Team Mod/'
local SDTM = {
    players = {},
    settings = require(root .. 'settings')
}

-- Dependency Loader:
-- Loads dependency files; Each file inherits the SDTM object.
local function LoadDependencies()
    for path, t in pairs({
        [root .. 'Dependencies/'] = {
            'Portals',
            'EditTags',
            'Tea Bagging',
            'Vehicle Spawner'
        }
    }) do
        for _, file in pairs(t) do
            SDTM[file] = setmetatable(require(path .. file), {
                __index = SDTM
            })
        end
    end
end
LoadDependencies()

-- New Player has joined:
-- * Creates a new player table; Inherits the SDTM parent object.
-- @Param o (player table [table])
-- @Return o (player table [table])
function SDTM:NewPlayer(o)

    setmetatable(o, self)
    self.__index = self

    o.loc, o.count, o.state = {}, 0, 0
    return o
end

-- Returns player map coordinates:
-- @Param dyn (player memory address)  [number]
-- @return x,y,z [32-bit floating point numbers]
--
function SDTM:GetPos(dyn)
    local x, y, z
    local vehicle = read_dword(dyn + 0x11C)
    local object = get_object_memory(vehicle)
    if (vehicle == 0xFFFFFFFF) then
        x, y, z = read_vector3d(dyn + 0x5c)
    elseif (object ~= 0) then
        x, y, z = read_vector3d(object + 0x5c)
    end
    return x, y, z
end

-- Distance function using pythagoras theorem:
-- @Param x1, y1, z1 (origin x,y,z)  [floating point numbers]
-- @Param x2, y2, z2 (current x,y,z) [floating point numbers]
-- @return Sqrt of (x1-x2)*2 + (y1-y2)*2 + (z1-z2)*2
--
local sqrt = math.sqrt
function SDTM:GetDist(x1, y1, z1, x2, y2, z2)
    return sqrt((x1 - x2) ^ 2 + (y1 - y2) ^ 2 + (z1 - z2) ^ 2)
end

-- Broadcast Function:
-- @Param msg (message) [string]
-- Temporarily removes the server prefix and replaces it when the relay is done.
--
function SDTM:Broadcast(msg)
    execute_command("msg_prefix \"\"")
    say_all(msg)
    execute_command("msg_prefix \" " .. self.settings.server_prefix .. "\"")
end

------------------------------------------------------------
--- [ SAPP FUNCTIONS ] ---
------------------------------------------------------------

-- Register needed SAPP Events:
register_callback(cb['EVENT_TICK'], 'OnTick')
register_callback(cb['EVENT_JOIN'], 'OnJoin')
register_callback(cb['EVENT_DIE'], 'OnDeath')
register_callback(cb['EVENT_GAME_START'], 'OnStart')

-- New Game Started:
-- Called when a new game has started.
-- Loads dependency functions and sets up player tables.
function OnStart()
    if (get_var(0, '$gt') ~= 'n/a') then

        SDTM.map = get_var(0, '$map')
        SDTM.mode = get_var(0, '$mode')

        for i = 1, 16 do
            if player_present(i) then
                OnJoin(i)
            end
        end

        SDTM['EditTags']:Edit()
        SDTM['Portals']:Load()
        SDTM['Vehicle Spawner']:Load()
    end
end

-- Game Tick:
-- Called every 1/30th second.
-- * Checks if a player is near a portal and teleports them.
-- * Checks if a player is tea bagging someone.
-- * Respawns map vehicles.
function OnTick()
    SDTM['Portals']:PortalCheck()
    SDTM['Tea Bagging']:TeaBagging()
    SDTM['Vehicle Spawner']:RespawnVehicle()
end

-- Called when a player has died:
-- * Saves the victims map coordinates.
-- @Param V (victim id)
-- @Param K (killer id)
function OnDeath(V, K)
    SDTM['Tea Bagging']:SaveLoc(V, K)
end

-- Called when a player has finished connecting:
function OnJoin(P)
    local name = get_var(P, '$name')
    SDTM.players[P] = SDTM:NewPlayer({ name = name })
end

-- Called when a player has finished respawning:
-- * Resets the crouch count (used by tea bag feature).
-- @Param P (player id)
function OnSpawn(P)
    SDTM.players[P].count = 0
end

-- Called when a player has quit:
-- * Nullifies the table for this player.
-- @Param P (player id)
function OnQuit(P)
    SDTM.players[P] = nil
end