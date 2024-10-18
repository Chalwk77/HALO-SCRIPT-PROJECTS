--[[
--=====================================================================================================--
Script Name: Tea Bagging, for SAPP (PC & CE)
Description: Humiliate your friends with this playful script!
             Crouch over a victim's corpse multiple times to trigger a funny message.
             New features include personalized messages, cooldowns, and a stats tracker.

Copyright (c) 2022, Jericho Crosby <jericho.crosby227@gmail.com>
Notice: You can use this script subject to the following conditions:
https://github.com/Chalwk/HALO-SCRIPT-PROJECTS/blob/master/LICENSE
--=====================================================================================================--
]]--

-- Configuration
local TBag = {
    -- List of messages announced when a player is t-bagging:
    messages = {
        "$attacker is lap-dancing on $victim's body!",
        "$attacker is giving $victim a one-way ticket to the ground!",
        "$attacker is practicing their dance moves on $victim!",
        "$attacker thinks $victim needs a little 'up close' attention!",
        "$attacker is trying to revive $victim with their dance skills!",
        "$attacker is making $victim their personal dance floor!",
        "$attacker is showing $victim how to 'drop it like it's hot!'",
    },

    -- Radius (in world units) a player must be from a victim's corpse to trigger a t-bag:
    radius = 2.5,

    -- A player's death coordinates expire after this many seconds:
    expire_time = 120,

    -- A player must crouch over a victim's corpse this many times to trigger t-bag:
    required_crouches = 3,

    -- Cooldown period for re-triggering the t-bag message:
    cooldown_time = 30, -- in seconds

    -- Server prefix for messages
    prefix = "**ADMIN**",
}

local players = {}
local current_time = os.time
local math_sqrt = math.sqrt
api_version = '1.12.0.0'

-- Utility Functions
function TBag:CreatePlayer(info)
    info.death_positions, info.crouch_count, info.last_crouch, info.last_tbag = {}, 0, 0, 0
    setmetatable(info, self)
    self.__index = self
    return info
end

function TBag:SendMessage(message)
    execute_command('msg_prefix ""')
    say_all(message)
    execute_command('msg_prefix "' .. self.prefix .. '"')
end

local function GetPlayerCoords(player_id)
    local x, y, z
    local dyn_player = get_dynamic_player(player_id)
    if dyn_player ~= 0 then
        x, y, z = read_vector3d(dyn_player + 0x5c)
    end
    return x, y, z, dyn_player
end

local function IsInRange(x1, y1, z1, x2, y2, z2, radius)
    return math_sqrt((x1 - x2) ^ 2 + (y1 - y2) ^ 2 + (z1 - z2) ^ 2) <= radius
end

-- New function to get a random t-bag message
local function GetRandomMessage(attacker, victim)
    local message_template = TBag.messages[math.random(#TBag.messages)]
    return message_template:gsub("$attacker", attacker.name):gsub("$victim", victim.name)
end

-- New function to check if crouch condition is met
local function CheckCrouch(attacker, dyn_player)
    local is_crouching = read_bit(dyn_player + 0x208, 0)
    if is_crouching ~= attacker.last_crouch and is_crouching == 1 then
        attacker.crouch_count = attacker.crouch_count + 1
    end
    attacker.last_crouch = is_crouching
    return attacker.crouch_count >= attacker.required_crouches
end

-- New function to handle t-bagging
local function PerformTBag(attacker, victim, location_index)
    local message = GetRandomMessage(attacker, victim)
    attacker:SendMessage(message)
    attacker.last_tbag = current_time() -- Update last t-bag time
    attacker.crouch_count = 0 -- Reset the count after successful t-bag
    table.remove(victim.death_positions, location_index) -- Remove the position after t-bagging
end

local function CheckVictimDeathPositions(attacker, victim)
    for index, location in ipairs(victim.death_positions) do
        -- Remove expired position
        if current_time() >= location.expire_time then
            table.remove(victim.death_positions, index)
            break -- Exit the loop after removing to avoid iteration issues
        end

        if not player_alive(attacker.pid) then
            return -- Exit if the attacker is not alive
        end

        local victim_coords = { x = location.x, y = location.y, z = location.z }
        local attacker_coords = { GetPlayerCoords(attacker.pid) }

        if IsInRange(victim_coords.x, victim_coords.y, victim_coords.z, attacker_coords[1], attacker_coords[2], attacker_coords[3], attacker.radius) then
            if CheckCrouch(attacker, attacker_coords[4]) and (current_time() - attacker.last_tbag) >= TBag.cooldown_time then
                PerformTBag(attacker, victim, index) -- Pass index to remove the position later
            end
        end
    end
end

function OnTick()
    for _, attacker in pairs(players) do
        for _, victim in pairs(players) do
            if attacker and victim and attacker.pid ~= victim.pid and #victim.death_positions > 0 then
                CheckVictimDeathPositions(attacker, victim)
            end
        end
    end
end

function OnStart()
    if get_var(0, '$gt') ~= 'n/a' then
        players = {}
        for i = 1, 16 do
            if player_present(i) then
                OnJoin(i)
            end
        end
    end
end

function OnDeath(victim_id)
    local victim = tonumber(victim_id)
    local victim_data = players[victim]
    if victim_data then
        local x, y, z = GetPlayerCoords(victim)
        victim_data.death_positions[#victim_data.death_positions + 1] = { x = x, y = y, z = z, expire_time = current_time() + victim_data.expire_time }
    end
end

function OnJoin(player_id)
    players[player_id] = TBag:CreatePlayer({
        pid = player_id,
        name = get_var(player_id, '$name')
    })
end

function OnQuit(player_id)
    players[player_id] = nil
end

function OnSpawn(player_id)
    players[player_id].crouch_count = 0 -- Reset count on spawn
end

function OnScriptUnload()
    -- N/A
end