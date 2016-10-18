--[[
------------------------------------
Script Name: HPC CommandSpy, for SAPP
    - Implementing API version: 1.11.0.0

Description: Spy on your players commands!
             This script will show commands typed by non-admins (to admins). 
             Admins wont see their own commands (:

This script is also available on my github! Check my github for regular updates on my projects, including this script.
https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS

    Change Log:
        [^] Initial Upload
        [*] Fixed a rather terrible bug.
        [+] Added an option to hide specific commands.
        
    [!] Script functions just fine right now as it is. Features from the to do list will come when I have time.
        
    To Do List:
        - Toggle commandspy on|off
        - Permission Based
        - [done] - Hide specific commands
        - Exclude from specific players
        
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

settings = {
    ["HideCommands"] = true,
}

--=========================================================--
commands_to_hide = {
    "/command1",
    "/command2",
    "/command3",
    "/command4",
    "/command5",
    "/command6",
    "/command7",
    -- repeat the structure to add more commands
}
--=========================================================--

api_version = "1.11.0.0"

function OnScriptLoad()
    register_callback(cb['EVENT_CHAT'], "OnChatMessage")
    register_callback(cb['EVENT_GAME_START'], "OnNewGame")
    register_callback(cb['EVENT_GAME_END'], "OnGameEnd")
end

function OnNewGame()
    game_started = true
end

function OnGameEnd()
    game_started = false
end

function OnChatMessage(PlayerIndex, Message)
    if (tonumber(get_var(PlayerIndex,"$lvl"))) >= 0 then
        AdminIndex = tonumber(PlayerIndex)
    end
    local Message = tostring(Message)
    local command = tokenizestring(Message, " ")
    local count = #command
    iscommand = nil
    if string.sub(command[1], 1, 1) == "/" then
        cmd = command[1]:gsub("\\", "/")
        iscommand = true
    else 
        iscommand = false
    end
    for k, v in pairs(commands_to_hide) do
        if cmd == v then
            hidden = true
            break
        end
    end    
        if (tonumber(get_var(PlayerIndex,"$lvl"))) == -1 then
            RegularPlayer = tonumber(PlayerIndex)
            if player_present(RegularPlayer) ~= nil then
                if iscommand then 
                    if RegularPlayer then
                        if settings["HideCommands"] then 
                            if not hidden then 
                                CommandSpy("[SPY]   " .. get_var(PlayerIndex, "$name") .. ":    \"" .. Message .. "\"", AdminIndex)
                            else
                                return false
                            end
                        else
                        CommandSpy("[SPY]   " .. get_var(PlayerIndex, "$name") .. ":    \"" .. Message .. "\"", AdminIndex)
                    end
                end
            end
        end
    end
end

function CommandSpy(Message, AdminIndex) 
    for i = 1,16 do
        if i ~= RegularPlayer then
            rprint(i, Message)
        end
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

function OnError(Message)
    print(debug.traceback())
end
