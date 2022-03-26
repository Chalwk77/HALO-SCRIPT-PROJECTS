-- Rank System [Entry Point File] (v1.0)
-- Copyright (c) 2022, Jericho Crosby <jericho.crosby227@gmail.com>

local RankSystem = {
    players = {},
    json = loadfile('./Rank System/Dependencies/Utils/Json.lua')(),
    dependencies = {
        ['./Rank System/'] = { 'settings' },
        ['./Rank System/Dependencies/Events/'] = {
            'Death',
            'Damage'
        },
        ['./Rank System/Dependencies/Utils/'] = {
            'LoadStats',
            'UpdateRank',
            'Rank Printer',
            'Player Components'
        },
        ['./Rank System/Dependencies/Commands/'] = {
            'Rank',
            'Set Rank',
            'Rank List',
            'Top List',
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
    local dam = self.credits.tags.damage
    for _, v in pairs(dam) do
        local tag = GetTag(v[1], v[2])
        if (tag) then
            t[tag] = { v[3], v[4] }
        end
    end
    self.credits.tags.damage = t

    self.collision = nil
    local col = self.credits.tags.collision
    local col_tag = GetTag(col[1], col[2])
    if (col_tag) then
        self.collision = col_tag
    end
end

function RankSystem:Init()

    self.players = {}
    self.first_blood = true
    self.team_play = (get_var(0, '$ffa') == '0')
    self.database = self:LoadStats()
    self:TagsToID()

    local sR = self.starting_rank
    local sG = self.starting_grade
    local rank_id = self:GetRankID(sR)

    local done = {}
    for i = 1, #self.ranks do
        for k = 1, #self.ranks[i].grade do
            done[i] = done[i] or {}
            if (i == rank_id and k == sG) then
                done[i][k] = true

                local req = self.ranks[i].grade[k]
                local start = self.starting_credits
                local precede = self.ranks[i].grade[k - 1] -- before
                local supersede = self.ranks[i].grade[k + 1] -- after
                local next_rank = self.ranks[i + 1]

                local auto
                if (next_rank and start >= next_rank.grade[1]) then
                    self.starting_credits, auto = req, true
                elseif (not precede and start < req) then
                    self.starting_credits, auto = req, true
                elseif (precede and start < precede) then
                    self.starting_credits, auto = req, true
                elseif (supersede and start > supersede) then
                    self.starting_credits, auto = req, true
                elseif (not supersede and start >= next_rank.grade[1]) then
                    self.starting_credits, auto = req, true
                elseif (start == precede or start == supersede) then
                    self.starting_credits, auto = req, true
                end

                if (auto) then
                    cprint('[RANK SYSTEM] -> Auto-Setting starting credits', 12)
                end

            elseif (i == rank_id and k < sG) then
                done[i][k] = true
            elseif (i == rank_id and k > sG or i > rank_id) then
                done[i][k] = false
            else
                done[i][k] = true
            end
        end
    end

    self.done_default = done
end

local open = io.open
function RankSystem:Update()
    local file = open(self.dir, 'w')
    if (file) then
        file:write(self.json:encode_pretty(self.database))
        file:close()
    end
end

function RankSystem:NewPlayer(o)

    setmetatable(o, self)
    self.__index = self

    local stats = self.database
    if (not stats[o.ip]) then
        stats[o.ip] = {
            name = o.name,
            done = self.done_default,
            rank = self.starting_rank,
            grade = self.starting_grade,
            credits = self.starting_credits
        }
    end
    self.database = stats -- update database

    o.meta_id = 0
    o.stats = stats[o.ip]
    o:ShowRank(o.ip, true)

    if (self.update_file_database['OnJoin']) then
        self:Update()
    end

    return o
end

function RankSystem:Send(msg, Global)
    if (not Global) then
        rprint(self.pid, msg)
    else
        for i, _ in pairs(self.players) do
            if (i ~= self.pid) then
                rprint(i, msg)
            end
        end
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
    local t = RankSystem.players[P]
    local s = RankSystem.credits.score
    t:UpdateCR({ s[1], s[2] })
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