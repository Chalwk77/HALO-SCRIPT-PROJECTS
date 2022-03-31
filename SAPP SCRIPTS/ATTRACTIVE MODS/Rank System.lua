-- Rank System [Entry Point File] (v1.0)
-- Copyright (c) 2022, Jericho Crosby <jericho.crosby227@gmail.com>

local RankSystem = {
    players = {},
    delay_welcome = true,
    json = loadfile('./Rank System/Dependencies/Utils/Json.lua')(),
    dependencies = {
        ['./Rank System/'] = { 'settings' },
        ['./Rank System/Dependencies/Events/'] = {
            'Damage',
            'Death',
            'Join',
            'On Score'
        },
        ['./Rank System/Dependencies/Utils/'] = {
            'Load Stats',
            'Misc',
            'Player Components',
            'Update Rank'
        },
        ['./Rank System/Dependencies/Commands/'] = {
            'Prestige',
            'Rank List',
            'Rank',
            'Set Rank',
            'Top List'
        }
    }
}

local function HasPermission(Ply, Lvl, Msg)
    local lvl = tonumber(get_var(Ply, '$lvl'))
    return (Ply == 0 or lvl >= Lvl) or rprint(Ply, Msg) and false
end

local cmds = {}
function RankSystem:LoadDependencies()
    local s = self
    for path, t in pairs(self.dependencies) do
        for _, file in pairs(t) do
            local f = loadfile(path .. file .. '.lua')()
            local cmd = f.command_name
            if (cmd) then
                cmds[cmd] = f -- command file
                cmds[cmd].permission = HasPermission
                setmetatable(cmds[cmd], { __index = self })
            else
                setmetatable(s, { __index = f })
                s = f
            end
        end
    end
end

local function GetTag(Type, Name)
    local Tag = lookup_tag(Type, Name)
    return Tag ~= 0 and read_dword(Tag + 0xC) or nil
end

function RankSystem:TagsToID()

    local t = {}
    self.damage, self.collision = nil, nil

    local tags = self.credits.tags.damage
    for i = 1, #tags do
        local v = tags[i]
        local tag = GetTag(v[1], v[2])
        if (tag) then
            t[tag] = { v[3], v[4] }
        end
    end
    self.damage = t

    local col = self.credits.tags.collision
    local col_tag = GetTag(col[1], col[2])
    if (col_tag) then
        self.collision = col_tag
    end
end

function RankSystem:Init()

    self.players = {}
    self.delay_welcome = true
    self.first_blood = true
    self.gt = get_var(0, '$gt')
    self.team_play = (get_var(0, '$ffa') == '0')

    self:TagsToID()
    self.database = self:LoadStats()
    self.starting_credits = self:GetStartingCredits()

    timer(5000, 'DelayWelcome')
end

local open = io.open
function RankSystem:Update()
    local file = open(self.dir, 'w')
    if (file) then
        file:write(self.json:encode_pretty(self.database))
        file:close()
    end
end

------------------------------------------------------------
--- [ SAPP FUNCTIONS ] ---
------------------------------------------------------------

function OnStart()
    if (get_var(0, '$gt') ~= 'n/a') then
        RankSystem:Init()
        for i = 1, 16 do
            if player_present(i) then
                OnJoin(i)
            end
        end
    end
end

-- Update local database:
function OnEnd()
    if (RankSystem.update_file_database['OnEnd']) then
        RankSystem:Update()
    end
end

function OnJoin(P)

    RankSystem.players[P] = RankSystem:NewPlayer({
        pid = P,
        name = get_var(P, '$name'),
        team = get_var(P, '$team'),
        ip = get_var(P, '$ip'):match('%d+.%d+.%d+.%d+')
    })

    -- for debugging rank-up logic:
    -- RankSystem.players[P]:UpdateCR({ 10, '' })
end

function OnQuit(P)

    if (RankSystem.update_file_database['OnQuit']) then
        RankSystem:Update()
    end

    RankSystem.players[P] = nil
end

local function StrSplit(str)
    local t = { }
    for arg in str:gmatch("([^%s]+)") do
        t[#t + 1] = arg:lower()
    end
    return t
end

function OnCommand(P, Cmd)
    local args = StrSplit(Cmd)
    return (cmds[args[1]] and cmds[args[1]]:Run(P, args))
end

function OnDamage(V, K, M)
    RankSystem:OnDamage(V, K, M)
end

function OnDeath(V, K)
    RankSystem:OnDeath(V, K)
end

function OnSwitch(P)
    RankSystem.players[P].team = get_var(P, '$team')
end

function OnSpawn(P)
    RankSystem.players[P].meta_id = 0
end

function OnScore(P)
    RankSystem.players[P]:OnScore()
end

function DelayWelcome()
    RankSystem.delay_welcome = false
    return false
end

function OnScriptLoad()

    RankSystem:LoadDependencies()

    local dir = read_string(read_dword(sig_scan('68??????008D54245468') + 0x1))
    RankSystem.dir = dir .. '\\sapp\\' .. RankSystem.file

    -- Register needed event callbacks:
    register_callback(cb['EVENT_DIE'], 'OnDeath')
    register_callback(cb['EVENT_JOIN'], 'OnJoin')
    register_callback(cb['EVENT_LEAVE'], 'OnQuit')
    register_callback(cb['EVENT_SCORE'], 'OnScore')
    register_callback(cb['EVENT_SPAWN'], 'OnSpawn')
    register_callback(cb['EVENT_GAME_END'], 'OnEnd')
    register_callback(cb['EVENT_COMMAND'], 'OnCommand')
    register_callback(cb['EVENT_GAME_START'], 'OnStart')
    register_callback(cb['EVENT_TEAM_SWITCH'], 'OnSwitch')
    register_callback(cb['EVENT_DAMAGE_APPLICATION'], 'OnDamage')

    OnStart()
end

function OnScriptUnload()
    -- N/A
end

api_version = '1.12.0.0'