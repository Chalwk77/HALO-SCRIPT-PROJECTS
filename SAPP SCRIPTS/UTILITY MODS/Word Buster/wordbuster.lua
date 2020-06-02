--[[
--=====================================================================================================--
Script Name: Word Buster (v1.0), for SAPP (PC & CE)
Description: An extremely advanced Chat Filter mod

Copyright (c) 2020, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE

* Written by Jericho Crosby (Chalwk)
--=====================================================================================================--
]]--

api_version = "1.12.0.0"

local wordBuster = { }
-- Word Buster Configuration --

-- Version: Current version of Word Buster
wordBuster.version = 1.0

-- Censor: Which character should be used to replace bad words?
wordBuster.censor = "*"

-- Semi Censor: Show the first and last character of bad words?
wordBuster.semiCensor = true

-- Notify: Notify the user that one of his/her words were censored.
wordBuster.notify = true

wordBuster.serverPrefix = "**SAPP**"

-- Notify Text: Text to notify the user with.
wordBuster.notifyText = "Watch your language!"

-- Chat Format: Messages are formatted as per default settings
wordBuster.chatFormat = {
    global = "%name%: %msg%",
    team = "[%name%]: %msg%",
    vehicle = "[%name%]: %msg%"
}

-- Languages: Which languages should be loaded?
wordBuster.languages = {
    ["cs"] = false,
    ["da"] = false,
    ["de"] = false,
    ["en"] = true, -- English
    ["eo"] = false,
    ["es"] = true, -- Spanish
    ["fr"] = false,
    ["hu"] = false,
    ["it"] = false,
    ["ja"] = false,
    ["ko"] = false,
    ["nl"] = false,
    ["no"] = false,
    ["pl"] = false,
    ["pt"] = false,
    ["ru"] = false,
    ["sv"] = false,
    ["th"] = false,
    ["tr"] = false,
    ["zh"] = false,
    ["tlh"] = false,
}

-- Whitelist: Groups allowed to use bad words.
wordBuster.whitelist = {
    [-1] = false, -- PUBLIC
    [1] = true, -- ADMIN LEVEL 1
    [2] = true, -- ADMIN LEVEL 2
    [3] = true, -- ADMIN LEVEL 3
    [4] = true, -- ADMIN LEVEL 4
}

-- Patterns: Advanced users only, patterns used to block variations of bad words.
wordBuster.patterns = {
    ["a"] = "[aA@]",
    ["b"] = "[bB]",
    ["c"] = "[cCkK]",
    ["d"] = "[dD]",
    ["e"] = "[eE3]",
    ["f"] = "[fF]",
    ["g"] = "[gG6]",
    ["h"] = "[hH]",
    ["i"] = "[iIl!1]",
    ["j"] = "[jJ]",
    ["k"] = "[cCkK]",
    ["l"] = "[lL1!i]",
    ["m"] = "[mM]",
    ["n"] = "[nN]",
    ["o"] = "[oO0]",
    ["p"] = "[pP]",
    ["q"] = "[qQ9]",
    ["r"] = "[rR]",
    ["s"] = "[sS$5]",
    ["t"] = "[tT7]",
    ["u"] = "[uUvV]",
    ["v"] = "[vVuU]",
    ["w"] = "[wW]",
    ["x"] = "[xX]",
    ["y"] = "[yY]",
    ["z"] = "[zZ2]"
}

function OnScriptLoad()
    wordBuster.Load()
end

function wordBuster.Load()
    cprint("[Word Buster] Loading languages...", 2 + 8)
    wordBuster.badWords = {}

    for lang, load in pairs(wordBuster.languages) do
        if load then

            local rawData
            local file = io.open("wordbuster_database/" .. lang .. ".txt", "r")
            if (file ~= nil) then
                rawData = file:read("*all")
                io.close(file)
            end

            if (file) then
                local words = StrSplit(rawData)
                for _, word in pairs(words) do
                    local formattedWord = ""
                    for _, char in pairs(string.ToTable(word)) do
                        if wordBuster.patterns[char] then
                            formattedWord = formattedWord .. wordBuster.patterns[char]
                        else
                            formattedWord = formattedWord .. word
                        end
                    end
                    table.insert(wordBuster.badWords, formattedWord)
                end
            else
                cprint("[Word Buster] Couldn't load language '" .. lang .. "', language not found!", 4 + 8)
            end
        end
    end

    if (#wordBuster.badWords > 0) then

        for k, v in pairs(wordBuster.badWords) do
            if (v == "" or v == " ") then
                cprint("[Word Buster] Removing Pattern Entry " .. v, 4+8)
                table.remove(wordBuster.badWords, k) -- Removes empty filters
            end
        end

        local time_took = os.clock()
        cprint("[Word Buster] " .. #wordBuster.badWords .. " words loaded in " .. time_took .. " seconds", 2 + 8)
        register_callback(cb["EVENT_CHAT"], "OnPlayerChat")

    else
        unregister_callback(cb["EVENT_CHAT"])
        cprint("[Word Buster] Unable to load Bad Words for ", 4 + 8)
    end
end

function OnPlayerChat(PlayerIndex, Message, Type)

    if (PlayerIndex > 0 and Type ~= 6) then

        local lvl = tonumber(get_var(PlayerIndex, "$lvl"))
        if (wordBuster.whitelist[lvl]) then
            return
        end

        for _, Pattern in pairs(wordBuster.badWords) do

            if string.find(Message:lower(), Pattern) then

                if (wordBuster.notify) then
                    rprint(PlayerIndex, wordBuster.notifyText)
                end

                local f = wordBuster.chatFormat
                local name = get_var(PlayerIndex, "$name")

                local formatMsg = function(Str)
                    local patterns = {
                        { "%%name%%", name },
                        { "%%msg%%", Message },
                        { "%%id%%", PlayerIndex }
                    }
                    for i = 1, #patterns do
                        Str = (string.gsub(Str, patterns[i][1], patterns[i][2]))
                    end

                    return Str
                end

                execute_command("msg_prefix \"\"")
                if (Type == 0) then
                    say_all(formatMsg(f.global))
                    return false
                elseif (Type == 1) then
                    wordBuster.SayTeam(P, formatMsg(f.team))
                    return false
                elseif (Type == 2) then
                    wordBuster.SayTeam(P, formatMsg(f.vehicle))
                    return false
                end
                execute_command("msg_prefix \" " .. wordBuster.serverPrefix .. "\"")
            end
        end
    end
end

function wordBuster.SayTeam(PlayerIndex, Message)
    local team = get_var(PlayerIndex, "$team")
    for i = 1, 16 do
        if player_present(i) then
            if (get_var(i, "$team") == team) then
                say(i, Message)
            end
        end
    end
end

function StrSplit(STR)
    local t, i = {}, 1
    for Args in string.gmatch(STR, "([^%s]+)") do
        t[i] = Args
        i = i + 1
    end
    return t
end

string.ToTable = function(String)
    local Array = {}
    for i = 1, String:len() do
        table.insert(Array, String:sub(i, i))
    end
    return Array
end

function report()
    local script_version = string.format("%0.2f", wordBuster.version)
    cprint("--------------------------------------------------------", 5 + 8)
    cprint("Please report this error on github:", 7 + 8)
    cprint("https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/issues", 7 + 8)
    cprint("Script Version: " .. script_version, 7 + 8)
    cprint("--------------------------------------------------------", 5 + 8)
end

function OnError()
    cprint(debug.traceback(), 4 + 8)
    timer(50, "report")
end
