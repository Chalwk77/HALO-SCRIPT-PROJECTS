--[[
--=====================================================================================================--
Script Name: ChatIDs, for SAPP (PC & CE)
Implementing API version: 1.11.0.0
Description:    This script will modify your players message chat format
                by adding an IndexID in front of their name in square brackets.

                [!] WARNING: This mod does not respect SAPP's built-in mute system (yet).

Team output: [Chalwk] [1]: This is a test message
Global output: Chalwk [1]: This is a test message

 ~ Change Log:
 - Jan 5th, 2019: Bug fixes and performance enhancements 

Copyright (c) 2016-2018, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE

* Written by Jericho Crosby (Chalwk)
--=====================================================================================================--
]]--

api_version = "1.11.0.0"
-- configuration starts
local global_format = "%sender_name% [%index%]: %message%"
local team_format = "[%sender_name%] [%index%]: %message%"

-- If you're using my Admin Chat Script with this, set this to TRUE!
local admin_chat = true
-- configuration ends

-- do not touch
local player_count = 0
--

function OnScriptLoad()
    register_callback(cb['EVENT_CHAT'], "OnPlayerChat")
    register_callback(cb['EVENT_GAME_END'], "OnGameEnd")
    register_callback(cb['EVENT_GAME_START'], "OnNewGame")
    register_callback(cb['EVENT_JOIN'], "OnPlayerJoin")
    register_callback(cb['EVENT_LEAVE'], "OnPlayerLeave")
    LoadTable()
end

function OnScriptUnload()
    ignore_list = { }
end

function OnPlayerJoin(PlayerIndex)
    player_count = player_count + 1
end

function OnPlayerLeave(PlayerIndex)
    player_count = player_count - 1
end

function OnPlayerChat(PlayerIndex, Message, type)
    if (game_over == false) then
        local message = tokenizestring(Message)
        if #message == 0 then
            return nil
        end
        if not (table.match(ignore_list, message[1])) then
            if (getAchat(PlayerIndex) == false) then
                for i = 0, #message do
                    if message[i] then
                        if string.sub(message[1], 1, 1) == "/" or string.sub(message[1], 1, 1) == "\\" then
                            return true
                        else
                            if GetTeamPlay() == true then
                                if type == 0 or type == 2 then
                                    SendToAll(Message, PlayerIndex)
                                elseif type == 1 then
                                    SendToTeam(Message, PlayerIndex)
                                end
                            else
                                SendToAll(Message, PlayerIndex)
                            end
                            return false
                        end
                    end
                end
            end
        end
    end
end

function SendToTeam(Message, PlayerIndex)
    for i = 1, player_count do
        if player_present(i) then
            local name = get_var(PlayerIndex, "$name")
            local index_id = get_var(PlayerIndex, "$n")
            if (get_var(i, "$team")) == (get_var(PlayerIndex, "$team")) then
                local team_format = string.gsub(team_format, "%%sender_name%%", name)
                local team_format = string.gsub(team_format, "%%index%%", index_id)
                local team_format = string.gsub(team_format, "%%message%%", Message)
                execute_command("msg_prefix \"\"")
                say(i, team_format)
                execute_command("msg_prefix \" *  * SERVER *  * \"")
            end
        end
    end
end

function SendToAll(Message, PlayerIndex)
    if player_present(PlayerIndex) then
        local name = get_var(PlayerIndex, "$name")
        local index_id = get_var(PlayerIndex, "$n")
        local global_format = string.gsub(global_format, "%%sender_name%%", name)
        local global_format = string.gsub(global_format, "%%index%%", index_id)
        local global_format = string.gsub(global_format, "%%message%%", Message)
        execute_command("msg_prefix \"\"")
        say_all(global_format)
        execute_command("msg_prefix \" *  * SERVER *  * \"")
    end
end

function GetTeamPlay()
    if get_var(0, "$ffa") == "0" then
        return true
    else
        return false
    end
end

function tokenizestring(inputstr, sep)
    if sep == nil then
        sep = "%s"
    end
    local t = {};
    i = 1
    for str in string.gmatch(inputstr, "([^" .. sep .. "]+)") do
        t[i] = str
        i = i + 1
    end
    return t
end

function OnNewGame()
    game_over = false
    LoadTable()
end

function OnGameEnd()
    game_over = true
end

function LoadTable()
    ignore_list = {}
    ignore_list = {
        "skip",
        "rtv",
        "keyword_3",
        "keyword_4",
        "keyword_5" -- Make sure the last entry in the table doesn't have a comma
    }
end

function table.match(table, value)
    for k, v in pairs(table) do
        if v == value then
            return k
        end
    end
end

function lines_from(file)
    lines = {}
    for line in io.lines(file) do
        lines[#lines + 1] = line
    end
    return lines
end

function getAchat(PlayerIndex)
    local bool = nil
    if admin_chat then
        if (tonumber(get_var(PlayerIndex, "$lvl"))) >= 1 then
            local name = get_var(PlayerIndex, "$name")
            local hash = get_var(PlayerIndex, "$hash")
            local lines = lines_from('sapp\\achat.temp')
            for k, v in pairs(lines) do
                if string.match(v, name .. ":" .. hash) then
                    bool = true
                    break
                else
                    bool = false
                end
            end
        else
            bool = false
        end
    else
        bool = false
    end
    return bool
end
