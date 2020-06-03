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
-- If false, the whole word will be censored
wordBuster.semiCensor = true

-- Block Word: If this is true, the users message will not be sent
wordBuster.blockWord = false

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

wordBuster.lang_directory = "wordbuster_database/"

-- Languages: Which languages should be loaded?
wordBuster.languages = {
    ["cs"] = false,
    ["da"] = false,
    ["de"] = false,
    ["en"] = true, -- English
    ["eo"] = false,
    ["es"] = false, -- Spanish
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
    [4] = false, -- ADMIN LEVEL 4
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

local len = string.len
local format = string.format
local sub, gsub = string.sub, string.gsub
local insert, remove = table.insert, table.remove

function OnScriptLoad()
    wordBuster.Load()
end

function wordBuster.Load()
    cprint("[Word Buster] Loading languages...", 2 + 8)
    wordBuster.badWords = {}

    local dir = wordBuster.lang_directory

    for lang, load in pairs(wordBuster.languages) do
        if load then

            local file = io.open(dir .. lang .. ".txt", "r")
            if (file ~= nil) then
                io.close(file)
            end

            if (file) then

                local words = {}
                for line in io.lines(dir .. lang .. ".txt") do
                    words[#words + 1] = line
                end

                for _, word in pairs(words) do
                    local formattedWord = ""
                    for _, char in pairs(string.ToTable(word)) do
                        if wordBuster.patterns[char] then
                            formattedWord = formattedWord .. wordBuster.patterns[char]
                        else
                            formattedWord = formattedWord .. "."
                        end
                    end
                    insert(wordBuster.badWords, { formattedWord, word, lang })
                end
            else
                cprint("[Word Buster] Couldn't load language '" .. lang .. "', language not found!", 4 + 8)
            end
        end
    end

    if (#wordBuster.badWords > 0) then

        for k, v in pairs(wordBuster.badWords) do
            if (v[1] == "" or v[1] == " ") then
                cprint("[Word Buster] Removing Pattern Entry " .. v, 4 + 8)
                remove(wordBuster.badWords, k) -- Removes empty filters
            end
        end

        local time_took = os.clock()
        cprint("[Word Buster] " .. #wordBuster.badWords .. " words loaded in " .. time_took .. " seconds", 2 + 8)
        register_callback(cb["EVENT_CHAT"], "OnPlayerChat")
        register_callback(cb["EVENT_GAME_START"], "OnGameStart")
    else
        unregister_callback(cb["EVENT_CHAT"])
        cprint("[Word Buster] Unable to load Bad Words for ", 4 + 8)
    end
end

function OnGameStart()
    -- DEBUG CODE:
    --local Msg, Params = wordBuster.isCensored("phrase")
    --if (#Params > 0) then
    --    for i = 1, #Params do
    --        cprint("------------- WORD FOUND ------------- ", 5 + 8)
    --        cprint("Pattern: " .. Params[i][1], 5 + 8)
    --        cprint("Word: " .. Params[i][2], 5 + 8)
    --        cprint("Language: " .. Params[i][3], 5 + 8)
    --    end
    --else
    --    cprint("WORD NOT FOUND", 4 + 8)
    --end
end

function OnPlayerChat(PlayerIndex, Message, Type)

    if (PlayerIndex > 0 and Type ~= 6) then

        local lvl = tonumber(get_var(PlayerIndex, "$lvl"))
        if (wordBuster.whitelist[lvl]) then
            return
        end

        local Msg, Params = wordBuster.isCensored(Message)
        if (#Params > 0) then

            Message = Msg

            cprint("--------- [ WORD BUSTER ] ---------", 5 + 8)
            for i = 1, #Params do
                cprint(Params[i][1] .. ", " .. Params[i][2] .. ", " .. Params[i][3])
            end

            if (wordBuster.notify) then
                local name = get_var(PlayerIndex, "$name")
                cprint(name .. " was notified that his/her message is censored", 5 + 8)
                rprint(PlayerIndex, wordBuster.notifyText)
            end
            cprint("--------------------------------------------------------------------", 5 + 8)


            if (wordBuster.blockWord) then
                return false
            end

            local f = wordBuster.chatFormat
            local FORMAT = wordBuster.formatMessage

            if (Type == 0) then
                execute_command("msg_prefix \"\"")
                say_all(FORMAT(PlayerIndex, Message, f.global))
                execute_command("msg_prefix \" " .. wordBuster.serverPrefix .. "\"")
                return false
            elseif (Type == 1) then
                wordBuster.SayTeam(PlayerIndex, FORMAT(PlayerIndex, Message, f.team))
                return false
            elseif (Type == 2) then
                wordBuster.SayTeam(PlayerIndex, FORMAT(PlayerIndex, Message, f.vehicle))
                return false
            end
        end
    end
end

function wordBuster.SayTeam(PlayerIndex, Message)
    execute_command("msg_prefix \"\"")
    local team = get_var(PlayerIndex, "$team")
    for i = 1, 16 do
        if player_present(i) then
            if (get_var(i, "$team") == team) then
                say(i, Message)
            end
        end
    end
    execute_command("msg_prefix \" " .. wordBuster.serverPrefix .. "\"")
end

function wordBuster.CensorWord(Str, Pattern)

    local l = 0
    local censor = ""

    local WORD = Str:match(Pattern)
    local ORI = WORD

    if (wordBuster.semiCensor) then
        for i = 1, len(WORD) do
            if (i > 1 and i < len(WORD)) then
                local letters = sub(WORD, i, i)
                WORD = gsub(WORD, letters, wordBuster.censor)
            end
        end
        return gsub(Str, ORI, WORD)
    else
        while l < len(WORD) do
            censor = censor .. wordBuster.censor
            l = l + 1
        end
        return gsub(Str, WORD, censor)
    end
end

function wordBuster.isCensored(Msg)
    local Params = { }
    for _, Pattern in pairs(wordBuster.badWords) do
        if (Msg:lower():match(Pattern[1])) then
            Msg = wordBuster.CensorWord(Msg, Pattern[1])
            Params[#Params + 1] = Pattern
        end
    end
    return Msg, Params
end

function wordBuster.formatMessage(PlayerIndex, Message, Str)

    local name = get_var(PlayerIndex, "$name")

    local patterns = {
        { "%%name%%", name },
        { "%%msg%%", Message },
        { "%%id%%", PlayerIndex }
    }

    for i = 1, #patterns do
        Str = (gsub(Str, patterns[i][1], patterns[i][2]))
    end

    return Str
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
