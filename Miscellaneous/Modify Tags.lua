--[[
--=====================================================================================================--
Script Name: Modify Tags, for SAPP (PC & CE)
Description: Frags & Plasma grenades are both super powerful
             and you can throw them 5x further than vanilla settings.

Copyright (c) 2021, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/blob/master/LICENSE
--=====================================================================================================--
]]--


api_version = "1.12.0.0"

function OnScriptLoad()
    register_callback(cb["EVENT_GAME_START"], "OnGameStart")
end

function OnGameStart()
    if (get_var(0, "$gt") ~= "n/a") then
        local tag_address = read_dword(0x40440000)
        local tag_count = read_dword(0x4044000C)

        -- weapons\frag grenade\shock wave.jpt!
        for i = 0, tag_count - 1 do
            local tag = tag_address + 0x20 * i
            local tag_name = read_string(read_dword(tag + 0x10))
            local tag_class = read_dword(tag)
            if (tag_class == 1785754657 and tag_name == "weapons\\frag grenade\\shock wave") then
                local tag_data = read_dword(tag + 0x14)
                write_dword(tag_data + 0xd4, 1048576000)
                write_dword(tag_data + 0xd8, 1022739087)
                break
            end
        end

        -- weapons\frag grenade\explosion.jpt!
        for i = 0, tag_count - 1 do
            local tag = tag_address + 0x20 * i
            local tag_name = read_string(read_dword(tag + 0x10))
            local tag_class = read_dword(tag)
            if (tag_class == 1785754657 and tag_name == "weapons\\frag grenade\\explosion") then
                local tag_data = read_dword(tag + 0x14)
                write_dword(tag_data + 0x0, 1073741824)
                write_dword(tag_data + 0x4, 1083703296)
                write_dword(tag_data + 0xcc, 1061158912)
                write_dword(tag_data + 0xd4, 1011562294)
                write_dword(tag_data + 0x1d0, 1131413504)
                write_dword(tag_data + 0x1d4, 1135575040)
                write_dword(tag_data + 0x1d8, 1135575040)
                write_dword(tag_data + 0x1f4, 1092091904)
                break
            end
        end

        -- weapons\frag grenade\frag grenade.proj
        for i = 0, tag_count - 1 do
            local tag = tag_address + 0x20 * i
            local tag_name = read_string(read_dword(tag + 0x10))
            local tag_class = read_dword(tag)
            if (tag_class == 1886547818 and tag_name == "weapons\\frag grenade\\frag grenade") then
                local tag_data = read_dword(tag + 0x14)
                write_dword(tag_data + 0x1bc, 1050253722)
                write_dword(tag_data + 0x1c0, 1050253722)
                write_dword(tag_data + 0x1cc, 1057803469)
                write_dword(tag_data + 0x1ec, 1065353216)
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
                write_dword(tag_data + 0x4, 1086324736)
                write_dword(tag_data + 0x1d0, 1140457472)
                write_dword(tag_data + 0x1d4, 1140457472)
                write_dword(tag_data + 0x1d8, 1140457472)
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
                write_dword(tag_data + 0x1bc, 1065353216)
                write_dword(tag_data + 0x1c0, 1065353216)
                write_dword(tag_data + 0x1cc, 1056964608)
                write_dword(tag_data + 0x1ec, 1077936128)
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
                write_dword(tag_data + 0x1d0, 1137180672)
                write_dword(tag_data + 0x1d4, 1137180672)
                write_dword(tag_data + 0x1d8, 1137180672)
                write_dword(tag_data + 0x1f4, 1092616192)
                break
            end
        end
    end
end