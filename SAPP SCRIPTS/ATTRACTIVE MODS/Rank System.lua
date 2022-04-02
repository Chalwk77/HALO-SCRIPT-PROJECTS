-- Rank System [Entry Point File] (v1.0)
-- Copyright (c) 2022, Jericho Crosby <jericho.crosby227@gmail.com>

local RankSystem = {
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
            'Change UP',
            'Create',
            'Login',
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

function RankSystem:Init()

    self.delay_welcome = true
    self.first_blood = true
    self.gt = get_var(0, '$gt')
    self.ffa = (get_var(0, '$ffa') == '1')

    self:TagsToID()

    timer(5000, 'DelayWelcome')
end

local open = io.open
function RankSystem:Update()
    local file = open(self.dir, 'w')
    if (file) then
        file:write(self.json:encode_pretty(self.db))
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

function OnEnd()
    -- Update local database:
    if (RankSystem.update_file_database['OnEnd']) then
        RankSystem:Update()
    end
end

function OnJoin(P)
    RankSystem:Join(P)
end

function OnQuit()
    if (RankSystem.update_file_database['OnQuit']) then
        RankSystem:Update()
    end
end

local function StrSplit(str)
    local t = { }
    for arg in str:gmatch("([^%s]+)") do
        t[#t + 1] = arg
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
    RankSystem:GetPlayer(P).team = get_var(P, '$team')
end

function OnSpawn(P)
    RankSystem:GetPlayer(P).meta_id = 0
end

function OnScore(P)
    RankSystem:GetPlayer(P):OnScore()
end

function DelayWelcome()
    RankSystem.delay_welcome = false
    return false
end

function OnScriptLoad()

    RankSystem:LoadDependencies()

    local dir = read_string(read_dword(sig_scan('68??????008D54245468') + 0x1))
    RankSystem.dir = dir .. '\\sapp\\' .. RankSystem.file
    RankSystem.db = RankSystem:LoadStats()

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