-- Word Buster Entry point file (v1.0)
-- Copyright (c) 2022, Jericho Crosby <jericho.crosby227@gmail.com>

api_version = '1.12.0.0'

local json = loadfile('./WordBuster/Utilities/Json.lua')()
local settings = require('./WordBuster/settings')
settings.words = {}

local cmds, files = {}, {}
local required_files = {
    ['./WordBuster/Utilities.'] = { 'BadWords', 'Grace' },
    ['./WordBuster/Events.'] = { 'OnMessage' },
}

local open = io.open
local function WriteFile(Dir, Content, JSON)
    local file = open(Dir, 'w')
    if (file) then
        file:write(JSON and json:encode_pretty(Content) or Content)
        file:close()
    end
end

local function ReadFile(dir)
    local content = ''
    local file = open(dir, 'r')
    if (file) then
        content = file:read('*all')
        file:close()
    end
    return content
end

local function LoadInfractions()
	local dir = settings.infractions_directory
    local content = ReadFile(dir)
    local data = json:decode(content)
    if (not data) then
        WriteFile(dir, {}, true)
    end
    return data or {}
end

local function StrSplit(str)
    local args = { }
    for arg in str:gmatch("([^%s]+)") do
        args[#args + 1] = arg:lower()
    end
    return args
end

local function Respond(Ply, Msg)
    return (Ply == 0 and cprint(Msg) or rprint(Ply, Msg))
end

local function HasPermission(Ply, Lvl, Msg)
    local lvl = tonumber(get_var(Ply, '$lvl'))
    return (Ply == 0 or lvl >= Lvl) or Respond(Ply, Msg) and false
end

local function LoadCommands(mt)
    local path = './WordBuster/Commands/'
    for file, enabled in pairs(settings.commands) do
        if (enabled) then
            local command = require(path .. file)
            local cmd = command.name
            cmds[cmd] = command
            cmds[cmd].help = command.help:gsub('$cmd', cmd)
            cmds[cmd].no_perm = command.no_perm:gsub('$lvl', command.admin_level)
            cmds[cmd].ReloadLangs = files['BadWords']
            cmds[cmd].permission = HasPermission
            setmetatable(cmds[cmd], mt)
        end
    end
end

local function LoadFiles(mt)
    for path, t in pairs(required_files) do
        for _, file in pairs(t) do
            files[file] = setmetatable(require(path .. file), mt)
        end
    end
end

local function StringToTable(str)
    local t = {}
    for i = 1, str:len() do
        t[#t + 1] = str:sub(i, i)
    end
    return t
end

local mt = {
    send = Respond,
    read = ReadFile,
    write = WriteFile,
    settings = settings,
    stringToTable = StringToTable,
    infractions = LoadInfractions()
}
mt = { __index = mt }

function OnScriptLoad()

    LoadFiles(mt)
    LoadCommands(mt)

    files['BadWords']:Load()

    register_callback(cb['EVENT_CHAT'], 'Chat')
    register_callback(cb['EVENT_COMMAND'], 'Command')
end

function Command(Ply, Cmd)
    local args = StrSplit(Cmd)
    return (cmds[args[1]] and cmds[args[1]]:Run(Ply, args))
end

function Chat(Ply, Msg)
    return files['OnMessage']:Send(Ply, Msg)
end