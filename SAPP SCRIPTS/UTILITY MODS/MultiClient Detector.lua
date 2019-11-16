--[[
--=====================================================================================================--
Script Name: MultiClient Detector (v1.0), for SAPP (PC & CE)
Description: This script will detect whether a players game client is a Generic Multi-Client and retrieve an overall probability score. 
             The probability score is a score based on a number of factors that are analyzed.
             Unfortunately, this mod will never be 100% accurate but provides a good indication.
            
Copyright (c) 2019, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE
* Written by Jericho Crosby (Chalwk)
--=====================================================================================================--
]]--

api_version = "1.12.0.0"

-- Config Starts
local path = "sapp\\multiclients.txt"

-- Players with common ports are not considered to be using a MultiClient.
-- MultiClient almost never generates a common port.
-- Min Range, Max Range
local common_ports = {{2300, 2400}}

-- If the port is NOT common and is within a 4 digit range, what range should be considered as suspicious?
local min_range = 2401
local max_range = 9999

-- Query Command Syntax: /query_command [player id]
local query_command = "mc"

-- Command Output:
local output_message = "%name% - MultiClient Probability: %probability%% chance."

-- Minimum permission needed to execute "query_command"
local permission_level = 4

-- This is a list of all known pirated hashes:
local known_pirated_hashes = {
    "388e89e69b4cc08b3441f25959f74103",
    "81f9c914b3402c2702a12dc1405247ee",
    "c939c09426f69c4843ff75ae704bf426",
    "13dbf72b3c21c5235c47e405dd6e092d",
    "29a29f3659a221351ed3d6f8355b2200",
    "d72b3f33bfb7266a8d0f13b37c62fddb",
    "76b9b8db9ae6b6cacdd59770a18fc1d5",
    "55d368354b5021e7dd5d3d1525a4ab82",
    "d41d8cd98f00b204e9800998ecf8427e",
    "c702226e783ea7e091c0bb44c2d0ec64",
    "f443106bd82fd6f3c22ba2df7c5e4094",
    "10440b462f6cbc3160c6280c2734f184",
    "3d5cd27b3fa487b040043273fa00f51b",
    "b661a51d4ccf44f5da2869b0055563cb",
    "740da6bafb23c2fbdc5140b5d320edb1",
    "7503dad2a08026fc4b6cfb32a940cfe0",
    "4486253cba68da6786359e7ff2c7b467",
    "f1d7c0018e1648d7d48f257dc35e9660",
    "40da66d41e9c79172a84eef745739521",
    "2863ab7e0e7371f9a6b3f0440c06c560",
    "34146dc35d583f2b34693a83469fac2a",
    "b315d022891afedf2e6bc7e5aaf2d357",
    "63bf3d5a51b292cd0702135f6f566bd1",
    "6891d0a75336a75f9d03bb5e51a53095",
    "325a53c37324e4adb484d7a9c6741314",
    "0e3c41078d06f7f502e4bb5bd886772a",
    "fc65cda372eeb75fc1a2e7d19e91a86f",
    "f35309a653ae6243dab90c203fa50000",
    "50bbef5ebf4e0393016d129a545bd09d",
    "a77ee0be91bd38a0635b65991bc4b686",
    "3126fab3615a94119d5fe9eead1e88c1",
    "2f02b641060da979e2b89abcfa1af3d6",
}

-- Config Ends

local probability = {}

-- Variables for String Library:
local gsub = string.gsub
local lower, upper = string.lower, string.upper
local match, gmatch = string.match, string.gmatch
local len = string.len

function OnScriptLoad()
    register_callback(cb["EVENT_JOIN"], "OnPlayerConnect")
    register_callback(cb["EVENT_LEAVE"], "OnPlayerDisconnect")
    register_callback(cb["EVENT_GAME_START"], "OnGameStart")
    register_callback(cb['EVENT_COMMAND'], "OnServerCommand")
    if (get_var(0, "$gt") ~= "n/a") then
        probability = {}
        for i = 1,16 do
            if player_present(i) then
                SetProbability(i)
            end
        end
    end
end

function OnScriptUnload()

end

function OnGameStart()
    if (get_var(0, "$gt") ~= "n/a") then
        probability = {}
    end
end

function OnPlayerConnect(PlayerIndex)

    probability[PlayerIndex] = 0
    
    local params = GetClientData(PlayerIndex)
    SavePort(params)
    SetProbability(PlayerIndex)
end

function OnPlayerDisconnect(PlayerIndex)
    probability[PlayerIndex] = nil
end

function SetProbability(PlayerIndex)
    local params = GetClientData(PlayerIndex)
    
    -- Check if the players hash is on the list of known pirated hashes.
    -- If the player hash is not on this list it is a stronger indicator that they 
    -- are using a multiclient.
    local pirated = false
    for i = 1,#known_pirated_hashes do
        if (params.hash == known_pirated_hashes[i]) then
            pirated = true
        end
    end
    
    -- Players game client is NOT on list of known pirated hashes.
    -- Run some more checks:
    if (not pirated) then
        
        probability[PlayerIndex] = probability[PlayerIndex] + 1
        
        -- MultiClient generates a random port & hash every time you start halo.
        -- This checks if their current port & hash matches their last known port & hash.
        -- If no match is made then it's likely that they are using a MultiClient.
        -- Most people don't frequently change their port number.
        
        local DataOnFile = LoadClientData(params)
        if (DataOnFile.port ~= params.port) then
            probability[PlayerIndex] = probability[PlayerIndex] + 1 
        end
        if (DataOnFile.hash ~= params.hash) then
            probability[PlayerIndex] = probability[PlayerIndex] + 1 
        end
        --
        
        
        -- Check if their port is in the list of common ports:
        -- MultiClient almost never generates a common port.
        local common_port = false
        for i = 1,#common_ports do
            local min, max = common_ports[i][1], common_ports[i][2]
            if (tonumber(params.port) >= min and tonumber(params.port) <= max) then
                common_port = true
            end
        end
        --
        
        
        -- Port is not common:
        -- Run some more checks:
        if (not common_port) then
            probability[PlayerIndex] = probability[PlayerIndex] + 1
            -- Statistically, most people do not use ports greater than 4 digits.
            -- This provides a greater indication that they are using multiclient.
            -- Statistics taken from 9 years of halo server logs.
            if (len(params.port) > 4) then
                probability[PlayerIndex] = probability[PlayerIndex] + 1
            elseif (tonumber(params.port) >= min_range and tonumber(params.port) <= max_range) then
                probability[PlayerIndex] = probability[PlayerIndex] + 1
            end
        end
        
        probability[PlayerIndex] = (probability[PlayerIndex]/5) * 100
        -- Debugging --
        local chance = probability[PlayerIndex]
        local name = get_var(PlayerIndex, "$name")
        local msg = gsub(gsub(output_message, "%%name%%", name), "%%probability%%", chance)
        Respond(0, msg, 10)
    end
end

function SavePort(params)
    local file = io.open(path, "a+")
    if (file) then
        local data = LoadClientData(params)
        if (data == nil) then
            local contents = tostring(params.ip) .. "|" .. tostring(params.port) .. "-" .. tostring(params.hash)
            file:write( contents .. "\n")
        end
    end
    file:close()
end

function LoadClientData(params)
    local data = nil
    local lines = lines_from(path)
    for line, file_data in pairs(lines) do
        if (line ~= nil) then
            local ip = file_data:match(params.ip)
            if (ip) then
                data = {}
                data.port = file_data:match("|(%d+)")
                data.hash = file_data:match("-(.+)")
            end
        end
    end
    return data
end

function GetClientData(PlayerIndex)
    local params = {}
    local IP = get_var(PlayerIndex, "$ip")
    params.hash = get_var(PlayerIndex, "$hash")
    params.ip = IP:match('(%d+.%d+.%d+.%d+)')
    params.port = IP:match(":(%d+)")
    return params
end

function lines_from(file)
    local lines = {}
    for line in io.lines(file) do
        lines[#lines + 1] = line
    end
    return lines
end

function OnServerCommand(PlayerIndex, Command, Environment, Password)
    local cmd = CmdSplit(Command)
    if (#cmd == 0 or cmd == nil) then
        return
    else
        local e = tonumber(PlayerIndex) -- executor
        cmd[1] = lower(cmd[1]) or upper(cmd[1])
        if (cmd[1] == query_command) then
            local level = tonumber(get_var(e, "$lvl"))
            if (level >= permission_level or e == 0) then
                if (cmd[2] ~= nil and cmd[3] == nil) then
                    local target = tonumber(cmd[2])
                    if (target ~= nil and target > 0 and target < 17) then
                        if player_present(target) then
                            local chance = probability[target]
                            local name = get_var(target, "$name")
                            local msg = gsub(gsub(output_message, "%%name%%", name), "%%probability%%", chance)
                            Respond(e, msg, 10)
                        else
                            Respond(e, "Command Failed. Player #" .. target .. " is not online", 12)
                        end
                    else
                        Respond(e, "Invalid Player. Please type a number between [1-16]", 12)
                    end
                else
                    Respond(e, "Invalid Syntax. Usage: /" .. query_command .. " [player id]", 12)
                end
            else
                Respond(e, "Insufficient Permission", 12)
            end
            return false
        end
    end
end

function Respond(Executor, Message, Color)
    Color = Color or 12
    if (Executor == 0) then
        cprint(Message, Color)
    else
        rprint(Executor, Message)
    end
end

function CmdSplit(Command)
    local args, index = {}, 1
    for Params in gmatch(Command, "([^%s]+)") do
        args[index] = Params
        index = index + 1
    end
    return args
end
