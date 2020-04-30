-- Hot Commands (for seven, by Chalwk)
api_version = "1.12.0.0"

-- Config Starts -----------------------------------------------------------------------------------------
local hot_commands = {
    ["sayrules"] = {
        "No portal camping or blocking, no any kind of cheating",
        "No vehicles in the tunnels or on the flags",
        "No Cursing or bad names",
        "No harassing an AG member or anyone in the AG Server",
        "AFK kick time is 150 secs, then you will be kicked",
        "Non-members of AG cannot use the AG tags"
    },
    ["sayhi"] = {
        "Welcome to the «ÅG~ unlimited rocket server",
        "Enjoy your time with awesome «ÅG~ Clan",
        "Please follow the rules",
        "Bienvenid@ a «ÅG~ unlimited rocket server",
        "Disfruta de tu tiempo con el increíble «ÅG~ Clan",
        "Por favor, sigue las reglas"
    },

    ["_other"] = {
        "add something here"
    },
    -- repeat the structure to add more entries
}

local server_prefix = "«ÅG~ Clan "
-- Config Ends -----------------------------------------------------------------------------------------

local gmatch, lower = string.gmatch, string.lower

function OnScriptLoad()
    register_callback(cb["EVENT_COMMAND"], "OnServerCommand")
end

function OnServerCommand(Admin, Command, _, _)
    local Cmd = CmdSplit(Command)
    local lvl = tonumber(get_var(Admin, "$lvl"))
    if (#Cmd == 0) then
        return false
    elseif (lvl >= 1) then
        Cmd[1] = lower(Cmd[1]) or upper(Cmd[1])
        for command, content in pairs(hot_commands) do
            if (Cmd[1] == command) then
                execute_command("msg_prefix \"\"")
                for i = 1, #content do
                    say_all(get_var(Admin, "$name") .. ": " .. content[i])
                end
                execute_command("msg_prefix \" **" .. server_prefix .. "**\"")
                return false
            end
        end
    end
end

function CmdSplit(Command)
    local t, i = {}, 1
    for Args in gmatch(Command, "([^%s]+)") do
        t[i] = Args
        i = i + 1
    end
    return t
end

function OnScriptUnload()

end
