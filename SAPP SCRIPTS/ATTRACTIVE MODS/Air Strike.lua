-- Configuration starts here:
api_version = "1.12.0.0"

-- Minimum number of projectiles to spawn
local min_proj = 1
-- Maximum number of projectiles to spawn
local max_proj = 5

-- Minimum time interval between airstrikes
local min_interval = 1
-- Maximum time interval between airstrikes
local max_interval = 60

-- Minimum height at which projectiles spawn
local min_height = 5
-- Maximum height at which projectiles spawn
local max_height = 20

-- Projectile velocity limits
local velocity_limits = {
    x = { min = -5, max = 5 },
    y = { min = -10, max = 5 },
    z = { min = -10, max = 5 },
}

-- Explosion settings
local explosion_damage = 50 -- Damage dealt by the explosion
local explosion_radius = 5 -- Radius of the explosion effect

-- Dictionary containing strike locations for different maps
local strike_locations = {
    ["bloodgulch"] = {
        { 64, -112.09, 2.21 },
        { 52.96, -93.79, 0.47 },
        { 38.64, -91.71, 0.37 },
        { 81.41, -145.96, 0.6 },
        { 36.64, -105.38, 1.8 },
        { 92.14, -141.23, 1.18 },
        { 79.61, -135.17, 0.99 },
        { 80.48, -121.13, 0.63 },
        { 61.68, -129.85, 1.37 },
        { 46.78, -131.33, 1.28 },
        { 47.78, -116.02, 0.74 },
        { 80.01, -107.42, 2.31 },
        { 81.66, -116.47, 0.78 },
        { 94.88, -127.31, 1.77 },
        { 101.5, -143.25, 1.07 },
        { 82.27, -156.12, 0.19 },
        { 52.43, -111.84, 0.64 },
        { 28.06, -19.75, -18.65 }
    }
}

-- Configuration ends here

local rocket
local locations
local start, finish
local time = os.time

function OnScriptLoad()
    register_callback(cb["EVENT_GAME_START"], "OnStart")
end

local function NewTimes()
    start = time
    finish = time() + rand(min_interval, max_interval + 1)
end

local function GetTag(Type, Name)
    local Tag = lookup_tag(Type, Name)
    return Tag ~= 0 and read_dword(Tag + 0xC) or nil
end

function OnStart()
    if get_var(0, "$gt") ~= "n/a" then
        rocket = GetTag("proj", "weapons\\rocket launcher\\rocket")

        local map = get_var(0, "$map")
        locations = strike_locations[map]

        if locations and rocket then
            NewTimes()
            register_callback(cb["EVENT_TICK"], "OnTick")
            return
        end
    end
    unregister_callback(cb["EVENT_TICK"])
end

-- Function to calculate projectile trajectory with a downward angle
local function CalculateProjectileVelocity(x, y, z)
    local x_vel = rand(velocity_limits.x.min, velocity_limits.x.max + 1)
    local y_vel = rand(velocity_limits.y.min, 0) -- Adjusted for a downward angle
    local z_vel = math.max(0, -(-y_vel * 0.2 + (z * 0.1))) -- Ensures z velocity is not negative
    return x_vel, y_vel, z_vel
end

-- Function to apply explosive damage to nearby players
local function ApplyExplosionDamage(x, y, z)
    for i = 1, 16 do
        if player_present(i) and player_alive(i) then
            local px, py, pz = GetXYZ(i)
            local distance = math.sqrt((px - x) ^ 2 + (py - y) ^ 2 + (pz - z) ^ 2)
            if distance <= explosion_radius then
                local damage = explosion_damage * (1 - (distance / explosion_radius)) -- Damage decreases with distance
                --
                -- do something here
                --
                --
            end
        end
    end
end

-- Function to broadcast an incoming airstrike message
local function BroadcastAirstrikeMessage(x, y, z)
    local message = "Incoming airstrike at coordinates (" .. x .. ", " .. y .. ", " .. z .. ")! Take cover!"
    for i = 1, 16 do
        if player_present(i) then
            say(i, message)
        end
    end
end

function OnTick()
    if start() >= finish then
        local n = rand(1, #locations + 1)
        local x, y, z = locations[n][1], locations[n][2], locations[n][3]
        local num_proj = rand(min_proj, max_proj + 1)

        -- Broadcast airstrike message before spawning projectiles
        BroadcastAirstrikeMessage(x, y, z)

        for _ = 1, num_proj do
            local h = rand(min_height, max_height + 1)
            local payload = spawn_object("", "", x, y, z + h, 0, rocket)
            local object = get_object_memory(payload)
            if object ~= 0 then
                local x_vel, y_vel, z_vel = CalculateProjectileVelocity(x, y, z)
                write_float(object + 0x68, x_vel)
                write_float(object + 0x6C, y_vel)
                write_float(object + 0x70, z_vel)
            end
        end

        -- Apply explosion damage when all projectiles have been spawned
        --ApplyExplosionDamage(x, y, z)

        NewTimes()
    end
end

function OnScriptUnload()
    -- N/A
end