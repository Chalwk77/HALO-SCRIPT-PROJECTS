--[[
------------------------------------
Script Name: HPC Chat Logger V2, for SAPP
    - Implementing API version: 1.11.0.0

Description: This script will log player chat to <sapp server>/Server Chat.txt

This script is also available on my github! Check my github for regular updates on my projects, including this script.
https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS

    Change Log:
        [+] Added Command Logging
        [+] Added Quit/Join logging
        [*] Reformatted file output so all the text aligns properly.
        [^] Seperated Command/Chat logging. Commands appear in Magenta by default, and Chat in Cyan
        [+] Added CommandSpy feature: 
            - Spy on your players commands!
            - CommandSpy will show commands typed by non-admins (to admins). 
            - Admins wont see their own commands (:
        
Copyright ©2016 Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE

* IGN: Chalwk
* Written by Jericho Crosby
-----------------------------------
]]--

--[[
    
Set color of console (0-255). Setting to 0 is white over black. !
0 - Black, 1 - Blue, 2 - Green, 3 - Cyan, 4 - Red
5 - Magenta, 6 - Gold, 7 - White. !
Add 8 to make text bold. !
Add 16 x Color to set background color.
    
]]

-- Console only -- 
CommandOutputColor = 4+8 -- Magenta
ChatOutputColor = 3+8 -- Cyan

api_version = "1.11.0.0"
local dir = 'sapp\\Server Chat.txt'
local timestamp = os.date("[%d/%m/%Y - %H:%M:%S]")

function OnScriptLoad()
    register_callback(cb['EVENT_CHAT'], "OnChatMessage")
    register_callback(cb['EVENT_GAME_START'], "OnNewGame")
    register_callback(cb['EVENT_GAME_END'], "OnGameEnd")
    register_callback(cb['EVENT_JOIN'], "OnPlayerJoin")
    register_callback(cb['EVENT_LEAVE'], "OnPlayerLeave")
end

function OnScriptUnload() end

function OnNewGame()
    local file = io.open(dir, "a+")
    if file ~= nil then
        local map = get_var(0, "$map")
        local gt = get_var(0, "$mode")
        local n1 = "\n"
        local t1 = os.date("[%A %d %B %Y] - %X - A new game has started on " .. tostring(map) .. ", Mode: " .. tostring(gt))
        local n2 = "\n---------------------------------------------------------------------------------------------\n"
        file:write(n1, t1, n2)
        file:close()
    end
end

function OnGameEnd()
    local file = io.open(dir, "a+")
    if file ~= nil then
        local data = os.date("[%A %d %B %Y] - %X - The game is ending - ")
        file:write(data)
        file:close()
    end
end

function OnPlayerJoin(PlayerIndex)
    local file = io.open(dir, "a+")
        if file ~= nil then
        name = get_var(PlayerIndex, "$name")
        id = get_var(PlayerIndex, "$n")
        ip = get_var(PlayerIndex, "$ip")
        hash = get_var(PlayerIndex, "$hash")
        file:write(timestamp .. "    [JOIN]    Name: " .. name .. "    ID: [" .. id .. "]    IP: [" .. ip .. "]    CD-Key Hash: [" .. hash .. "]\n")
        file:close()
    end
end

function OnPlayerLeave(PlayerIndex)
    local file = io.open(dir, "a+")
        if file ~= nil then
        file:write(timestamp .. "    [QUIT]    Name: " .. name .. "    ID: [" .. id .. "]    IP: [" .. ip .. "]    CD-Key Hash: [" .. hash .. "]\n")
        file:close()
    end
end

function tokenizestring(inputstr, sep)
    if sep == nil then
        sep = "%s"
    end
    local t={} ; i=1
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
        t[i] = str
        i = i + 1
    end
    return t
end

function OnChatMessage(PlayerIndex, Message, type)
    if (tonumber(get_var(PlayerIndex,"$lvl"))) >= 0 then
        AdminIndex = tonumber(PlayerIndex)
    end
    local t = tokenizestring(Message)
    local Message = tostring(Message)
    local name = get_var(PlayerIndex, "$name")
    count = #t
    iscommand = nil
    if string.sub(t[1], 1, 1) == "/" or string.sub(t[1], 1, 1) == "\\" then 
        iscommand = true
        chattype = "[COMMAND] "
    else 
        iscommand = false
    end
    if type == 0 then -- T
        Type = "[GLOBAL]  "
    elseif type == 1 then -- Y
        Type = "[TEAM]    "
    elseif type == 2 then -- H
        Type = "[VEHICLE] "
    end    
        if player_present(PlayerIndex) ~= nil then
            if iscommand then 
                WriteData(dir, "   " .. chattype .. "     " .. name .. " [" .. id .. "]: " .. tostring(Message))
                output("* Executing Command: \"" .. Message .. "\" from " .. name)
            else
                WriteData(dir, "   " .. Type .. "     " .. name .. " [" .. id .. "]: " .. tostring(Message))
                cprint(Type .." " .. name .. " [" .. id .. "]: " .. tostring(Message), ChatOutputColor)
            end
            if (tonumber(get_var(PlayerIndex,"$lvl"))) == -1 then
                RegularPlayer = tonumber(PlayerIndex)
                if player_present(RegularPlayer) ~= nil then
                    if iscommand then 
                        if RegularPlayer then
                            CommandSpy("SPY:    " .. name .. ":    " .. Message, AdminIndex)
                        end
                    end
                end
            end
        end
    return true
end

function CommandSpy(Message, AdminIndex) 
    for i = 1,16 do
        if i ~= RegularPlayer then
            rprint(i, Message)
        end
    end
end

function WriteData(dir, value)
    local file = io.open(dir, "a+")
    if file ~= nil then
        local chatValue = string.format("%s\t%s\n", timestamp, tostring(value))
        file:write(chatValue)
        file:close()
    end
end

function output(Message, PlayerIndex)
    if Message then
        if Message == "" then
            return
        end
        cprint(Message, CommandOutputColor)
    end
end

function OnError(Message)
    print(debug.traceback())
end

--[[

SAPP will log player chat to the sapp.log file, however, it's difficult to wade through all the other event logs it handles.
Personally, I find it convenient to have a 'dedicated' server chat.txt file. Which is where this script comes into play.

]]
