local VIP = {

    -- List of VIP players (case sensitive):
    --
    --=====================================--
    names = {
        "Chalwk",
        "example_name",
    },
    --=====================================--

    -- Modes this script will work on:
    -- format: ["example game mode"] = max player limit
    --
    modes = {
        ["MyOddball"] = 2,
        --
        -- repeat the structure to add more entries:
        --
    }
}

api_version = "1.12.0.0"

local limit

function OnScriptLoad()
    register_callback(cb["EVENT_GAME_START"], "OnStart")
end

function OnStart()

    if (get_var(0, "$gt") ~= "n/a") then

        local mode = get_var(0, "$mode")
        if (VIP.modes[mode]) then
            limit = VIP.modes[mode]
            register_callback(cb["EVENT_PREJOIN"], "OnPreJoin")
            goto done
        end
    end

    unregister_callback(cb["EVENT_PREJOIN"])
    :: done ::
end

local function IsVIP(name)
    for _, v in pairs(VIP.names) do
        if (name == v) then
            return true
        end
    end
    return false
end

function OnPreJoin(Ply)

    local name = get_var(Ply, "$name")
    if (IsVIP(name)) then

        local players = { }
        for i = 1, 16 do
            if player_present(i) then
                name = get_var(i, "$name")
                if not (IsVIP(name)) then
                    table.insert(players, i)
                end
            end
        end

        if (#players == limit) then
            local n = rand(1, #players + 1)
            local id = players[n]
            execute_command("k " .. id)
        end
    end
end

function OnScriptUnload()
    -- N/A
end