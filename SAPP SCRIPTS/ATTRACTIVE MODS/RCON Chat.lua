--[[
--=====================================================================================================--
Script Name: RCON Chat, for SAPP, (PC & CE)
Description: Player messages will appear in the RCON Environment

Copyright (c) 2021, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/blob/master/LICENSE
--=====================================================================================================--
]]--

-- config starts --
local chat = {

    -- Global
    [0] = "%name% [%id%]: %msg%",

    -- Team:
    [1] = "[%name%] [%id%]: %msg%",

    -- Vehicle:
    [2] = "[%name%] [%id%]: %msg%",

    -- Messages containing these keywords (at the beginning of the string) will not trigger chat formatting:
    ignore_list = {
        "rtv",
        "skip"
    }
}

-- config ends --

api_version = "1.12.0.0"

local team_play

function OnScriptLoad()
    register_callback(cb["EVENT_CHAT"], "RconChat")
    register_callback(cb["EVENT_GAME_START"], "OnGameStart")
    OnGameStart()
end

function OnGameStart()
    if (get_var(0, "$gt") ~= "n/a") then
        team_play = (get_var(0, "$ffa") == "0") or nil
    end
end

local function Contains(word)
    for _, v in pairs(chat.ignore_list) do
        if (v == word) then
            return true
        end
    end
    return false
end

local function InVehicle(Ply)
    local DyN = get_dynamic_player(Ply)
    local vehicle = read_dword(DyN + 0x11C)
    local object = get_object_memory(vehicle)
    return (DyN ~= 0 and vehicle ~= 0xFFFFFFFF), object or false
end

function RconChat(Ply, Msg, Type)

    local args = { }
    for Params in Msg:gmatch("([^%s]+)") do
        args[#args + 1] = Params:lower()
    end

    if (#args > 0) then

        local chat_command = Msg:sub(1, 1) == "/" or Msg:sub(1, 1) == "\\"
        if (not chat_command and not Contains(args[1])) then

            local msg = chat[Type]
            local p_name = get_var(Ply, "$name")

            local original_message = Msg
            Msg = msg:gsub("%%name%%", p_name):gsub("%%id%%", Ply):gsub("%%msg%%", Msg)

            -- team:
            if (Type == 1) then

                if (team_play) then
                    for i = 1, 16 do
                        if player_present(i) then
                            if (get_var(Ply, "$team") == get_var(i, "$team")) then
                                rprint(i, Msg)
                            end
                        end
                    end
                    return false
                end

                Msg = original_message
                Msg = chat[0]:gsub("%%name%%", p_name):gsub("%%id%%", Ply):gsub("%%msg%%", Msg)
                goto global

                -- vehicle
            elseif (Type == 2) then
                for i = 1, 16 do
                    if player_present(i) then

                        local in_vehicle_a, vehicle_a = InVehicle(i)
                        local in_vehicle_b, vehicle_b = InVehicle(Ply)

                        if (in_vehicle_a and in_vehicle_b and vehicle_a == vehicle_b) then
                            rprint(i, Msg)
                        end
                    end
                end
                return false
            end

            :: global ::
            for i = 1, 16 do
                if player_present(i) then
                    rprint(i, Msg)
                end
            end

            return false
        end
    end
end