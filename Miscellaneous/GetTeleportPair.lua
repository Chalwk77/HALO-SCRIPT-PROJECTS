api_version = '1.12.0.0'

function OnScriptLoad()
    register_callback(cb['EVENT_TICK'], 'OnTick')
    register_callback(cb['EVENT_COMMAND'], 'Reset')
end

local str = ''
local state = 0
local count = 0
local f, p = string.format, '%0.3f'
local mode = 1 -- teleports = 1, vehicles = 2

local function GetTeleportPair(i, x, y, z, r)
    if (count == 0) then
        rprint(i, 'origin x,y,z set')
        count = 1
        str = '{ ' .. x .. ', ' .. y .. ', ' .. z .. ', 0.5, '
    elseif (count == 1) then
        rprint(i, 'destination x,y,z set')
        str = str .. x .. ', ' .. y .. ', ' .. z .. ', ' .. r .. ' },'
        count = 0
        cprint(str)
    end
end

local function GetVehiclePos(i, x, y, z, r)
    rprint(i, 'vehicle position saved')
    cprint('{ ' .. x .. ', ' .. y .. ', ' .. z .. ', ' .. r .. ', 30, 1 },')
end

function OnTick()
    for i = 1, 16 do
        local dyn = get_dynamic_player(i)
        if player_present(i) and player_alive(i) and dyn ~= 0 then

            local shooting = read_float(dyn + 0x490)
            if (shooting ~= state and shooting == 1) then

                local r = read_float(dyn + 0x82)
                local x, y, z = read_vector3d(dyn + 0x5C)
                x, y, z, r = f(p, x), f(p, y), f(p, z), f(p, r)

                if (mode == 1) then
                    GetTeleportPair(i, x, y, z, r)
                elseif (mode == 2) then
                    GetVehiclePos(i, x, y, z, r)
                end
            end
            state = shooting
        end
    end
end

local function Split(CMD)
    local t = { }
    for Params in CMD:gmatch('([^%s]+)') do
        t[#t + 1] = Params:lower()
    end
    return t
end

function Reset(Ply, CMD)
    local args = Split(CMD)
    if (#args > 0 and args[1] == 'reset') then
        count = 0
        return false, rprint(Ply, 'Coords reset.')
    elseif (#args > 0 and args[1] == 'mode') then
        mode = tonumber(args[2])
        if (mode == 1) then
            rprint(Ply, 'MODE: ' .. mode .. ' [TELEPORTS]')
        elseif (mode == 2) then
            rprint(Ply, 'MODE: ' .. mode .. ' [VEHICLES]')
        end
        return false
    end
end

function OnScriptUnload()
    -- N/A
end