-- Word Buster Entry point file (v1.0)
-- Copyright (c) 2022, Jericho Crosby <jericho.crosby227@gmail.com>

api_version = '1.12.0.0'

local json = loadfile('./WordBuster/Utilities/Json.lua')()
local settings = loadfile('./WordBuster/settings.lua')()
settings.words = {}

local open = io.open
local MessageHandler

local function WriteToFile(t)
    local file = open(settings.infractions_directory, 'w')
    if (file) then
        file:write(json:encode_pretty(t))
        file:close()
    end
end

local function LoadInfractions()

    local content = ''
    local file = open(settings.infractions_directory, 'r')
    if (file) then
        content = file:read('*all')
        file:close()
    end

    local data = json:decode(content)
    if (not data) then
        WriteToFile({})
    end
    data = data or {}

    return data
end

function OnScriptLoad()

    local Grace = require('./WordBuster/Utilities.Grace')
    local BadWords = require('./WordBuster/Utilities.BadWords')
    MessageHandler = require('./WordBuster/Events.MessageHandler')

    local mt = {
        write = WriteToFile,
        settings = settings,
        infractions = LoadInfractions()
    }
    mt = { __index = mt }

    setmetatable(BadWords, mt)
    setmetatable(Grace, mt)
    setmetatable(MessageHandler, mt)

    BadWords:Load()
    Grace:Check()
    register_callback(cb['EVENT_CHAT'], 'OnChat')
end

function OnChat(Ply, Msg)
    return MessageHandler:OnSend(Ply, Msg)
end