-- Custom Explosion effect (for Shoo)
-- By Chalwk, v 1.0

local custom_command = "boom"
local permission_level = 1

local enable_messages = false
local messages = {
    [1] = "|cBoom! You blew up %victim_name%",
    [2] = "|cBoom! You were blown up by %killer_name%",
    [3] = "|cBoom! You blew yourself up!"
}

api_version = "1.12.0.0"

local grenade_objects = { }
local gsub, gmatch = string.gsub, string.gmatch

function OnScriptLoad()
    register_callback(cb['EVENT_TICK'], "OnTick")
    register_callback(cb['EVENT_GAME_START'], "OnNewGame")
    register_callback(cb["EVENT_COMMAND"], "OnServerCommand")
    if (get_var(0, "$gt") ~= "n/a") then
        grenade_objects = { }
    end
end

function OnScriptUnload()

end

function OnTick()
    if (#grenade_objects > 0) then

        for i = 1, #grenade_objects do
            if (grenade_objects[i]) then
                local projectile = get_object_memory(grenade_objects[i])
                if (projectile == 0) then
                    table.remove(grenade_objects, i)
                end
            end
        end

        if (#grenade_objects == 0) then
            RollBackPlasmaGrenade()
        end
    end
end

function OnNewGame()
    if (get_var(0, "$gt") ~= "n/a") then
        grenade_objects = { }
    end
end

function OnServerCommand(Executor, Command, _, _)
    local CMD = CmdSplit(Command)
    if (CMD == nil or CMD == "") then
        return
    else

        CMD[1] = string.lower(CMD[1]) or string.upper(CMD[1])
        if (CMD[1] == custom_command) then

                local lvl = tonumber(get_var(Executor, "$lvl"))
            if (lvl >= permission_level) then
                local pl = GetPlayers(Executor, CMD)
                if (pl) then
                    for i = 1, #pl do
                        local TargetID = tonumber(pl[i])
                        if (TargetID ~= 0) then
                            local DynamicPlayer = get_dynamic_player(TargetID)
                            if (DynamicPlayer ~= 0) then

                                local coords = GetXYZ(DynamicPlayer)
                                local payload = spawn_object("proj", "weapons\\plasma grenade\\plasma grenade", coords.x, coords.y, coords.z + 5)
                                if (payload) then

                                    local projectile = get_object_memory(payload)
                                    if (projectile ~= 0) then

                                        grenade_objects[#grenade_objects + 1] = payload
                                        ModifyPlasmaGrenade()

                                        write_float(projectile + 0x68, 0)
                                        write_float(projectile + 0x6C, 0)
                                        write_float(projectile + 0x70, -9999)

                                        if (enable_messages) then

                                            local TargetName = get_var(TargetID, "$name")
                                            local ExecutorName = get_var(Executor, "$name")

                                            if (Executor == 0) then
                                                ExecutorName = "The Server"
                                            end

                                            if (Executor ~= TargetID) then
                                                Respond(Executor, gsub(messages[1], "%%victim_name%%", TargetName), 2 + 8, "rcon")
                                                Respond(TargetID, gsub(messages[2], "%%killer_name%%", ExecutorName), 2 + 8, "rcon")
                                            else
                                                Respond(Executor, messages[3], 2 + 8, "rcon")
                                            end
                                        end
                                    end
                                end
                            end
                        else
                            Respond(Executor, "Server cannot be exploded!", 4 + 8, "rcon")
                        end
                    end
                end
            else
                Respond(Executor, "You do not have permission execute this command", 4 + 8, "rcon")
            end
            return false
        end
    end
end

function ModifyPlasmaGrenade()
    local tag_address = read_dword(0x40440000)
    local tag_count = read_dword(0x4044000C)

    -- weapons\plasma grenade\shock wave.jpt!
    for i = 0, tag_count - 1 do
        local tag = tag_address + 0x20 * i
        local tag_name = read_string(read_dword(tag + 0x10))
        local tag_class = read_dword(tag)
        if (tag_class == 1785754657 and tag_name == "weapons\\plasma grenade\\shock wave") then
            local tag_data = read_dword(tag + 0x14)
            write_dword(tag_data + 0x0, 1092616192)
            write_dword(tag_data + 0x4, 1092616192)
            break
        end
    end

    -- weapons\plasma grenade\explosion.jpt!
    for i = 0, tag_count - 1 do
        local tag = tag_address + 0x20 * i
        local tag_name = read_string(read_dword(tag + 0x10))
        local tag_class = read_dword(tag)
        if (tag_class == 1785754657 and tag_name == "weapons\\plasma grenade\\explosion") then
            local tag_data = read_dword(tag + 0x14)
            write_dword(tag_data + 0x0, 1084227584)
            write_dword(tag_data + 0x4, 1084227584)
            write_dword(tag_data + 0x1d0, 1065353216)
            write_dword(tag_data + 0x1d4, 1065353216)
            write_dword(tag_data + 0x1d8, 1065353216)
            write_dword(tag_data + 0x1f4, 1094713344)
            break
        end
    end

    -- weapons\plasma grenade\plasma grenade.proj
    for i = 0, tag_count - 1 do
        local tag = tag_address + 0x20 * i
        local tag_name = read_string(read_dword(tag + 0x10))
        local tag_class = read_dword(tag)
        if (tag_class == 1886547818 and tag_name == "weapons\\plasma grenade\\plasma grenade") then
            local tag_data = read_dword(tag + 0x14)
            write_dword(tag_data + 0x1bc, 0)
            write_dword(tag_data + 0x1c0, 0)
            break
        end
    end

    -- weapons\plasma grenade\attached.jpt!
    for i = 0, tag_count - 1 do
        local tag = tag_address + 0x20 * i
        local tag_name = read_string(read_dword(tag + 0x10))
        local tag_class = read_dword(tag)
        if (tag_class == 1785754657 and tag_name == "weapons\\plasma grenade\\attached") then
            local tag_data = read_dword(tag + 0x14)
            write_dword(tag_data + 0x0, 1084227584)
            write_dword(tag_data + 0x4, 1084227584)
            write_dword(tag_data + 0x1d0, 1065353216)
            write_dword(tag_data + 0x1d4, 1065353216)
            write_dword(tag_data + 0x1d8, 1065353216)
            write_dword(tag_data + 0x1f4, 1094713344)
            break
        end
    end
end

function RollBackPlasmaGrenade()
    local tag_address = read_dword(0x40440000)
    local tag_count = read_dword(0x4044000C)
    -- weapons\plasma grenade\shock wave.jpt!
    for i = 0, tag_count - 1 do
        local tag = tag_address + 0x20 * i
        local tag_name = read_string(read_dword(tag + 0x10))
        local tag_class = read_dword(tag)
        if (tag_class == 1785754657 and tag_name == "weapons\\plasma grenade\\shock wave") then
            local tag_data = read_dword(tag + 0x14)
            write_dword(tag_data + 0x0, 1080033280)
            write_dword(tag_data + 0x4, 1090519040)
            break
        end
    end

    -- weapons\plasma grenade\explosion.jpt!
    for i = 0, tag_count - 1 do
        local tag = tag_address + 0x20 * i
        local tag_name = read_string(read_dword(tag + 0x10))
        local tag_class = read_dword(tag)
        if (tag_class == 1785754657 and tag_name == "weapons\\plasma grenade\\explosion") then
            local tag_data = read_dword(tag + 0x14)
            write_dword(tag_data + 0x0, 1056964608)
            write_dword(tag_data + 0x4, 1073741824)
            write_dword(tag_data + 0x1d0, 1117782016)
            write_dword(tag_data + 0x1d4, 1123024896)
            write_dword(tag_data + 0x1d8, 1123024896)
            write_dword(tag_data + 0x1f4, 1082130432)
            break
        end
    end


    -- weapons\plasma grenade\plasma grenade.proj
    for i = 0, tag_count - 1 do
        local tag = tag_address + 0x20 * i
        local tag_name = read_string(read_dword(tag + 0x10))
        local tag_class = read_dword(tag)
        if (tag_class == 1886547818 and tag_name == "weapons\\plasma grenade\\plasma grenade") then
            local tag_data = read_dword(tag + 0x14)
            write_dword(tag_data + 0x1bc, 1073741824)
            write_dword(tag_data + 0x1c0, 1073741824)
            break
        end
    end


    -- weapons\plasma grenade\attached.jpt!
    for i = 0, tag_count - 1 do
        local tag = tag_address + 0x20 * i
        local tag_name = read_string(read_dword(tag + 0x10))
        local tag_class = read_dword(tag)
        if (tag_class == 1785754657 and tag_name == "weapons\\plasma grenade\\attached") then
            local tag_data = read_dword(tag + 0x14)
            write_dword(tag_data + 0x0, 0)
            write_dword(tag_data + 0x4, 0)
            write_dword(tag_data + 0x1d0, 1117782016)
            write_dword(tag_data + 0x1d4, 1123024896)
            write_dword(tag_data + 0x1d8, 1123024896)
            write_dword(tag_data + 0x1f4, 1082130432)
            break
        end
    end
end

function TagInfo(obj_type, obj_name)
    local tag = lookup_tag(obj_type, obj_name)
    return tag ~= 0 and read_dword(tag + 0xC) or nil
end

function CmdSplit(CMD)
    local Args, index = { }, 1
    for Params in gmatch(CMD, "([^%s]+)") do
        Args[index] = Params
        index = index + 1
    end
    return Args
end

function GetXYZ(DynamicPlayer)
    local coordinates, x, y, z = {}
    local VehicleID = read_dword(DynamicPlayer + 0x11C)
    if (VehicleID == 0xFFFFFFFF) then
        x, y, z = read_vector3d(DynamicPlayer + 0x5c)
    else
        x, y, z = read_vector3d(get_object_memory(VehicleID) + 0x5c)
    end
    coordinates.x, coordinates.y, coordinates.z = x, y, z
    return coordinates
end

function GetPlayers(P, Args)
    local pl = { }
    if (Args[2] == nil or Args[2] == "me") then
        pl[#pl + 1] = P
    elseif (Args[2]:match("%d+")) and player_present(Args[2]) then
        pl[#pl + 1] = Args[2]
    elseif (Args[2] == "all" or Args[2] == "*") then
        for i = 1, 16 do
            if player_present(i) then
                pl[#pl + 1] = i
            end
        end
    else
        Respond(P, "Invalid Player ID or Player not Online", 4 + 8, "rcon")
        Respond(P, "Command Usage: " .. Args[1] .. " [number: 1-16] | */all | me", 4 + 8, "rcon")
    end
    return pl
end

function Respond(PlayerIndex, Message, Color, ChatType)
    if (PlayerIndex == 0) then
        Color = Color or 2 + 8
        cprint(Message, Color)
    else
        if (ChatType == "rcon") then
            rprint(PlayerIndex, Message)
        else
            say(PlayerIndex, Message)
        end
    end
end
