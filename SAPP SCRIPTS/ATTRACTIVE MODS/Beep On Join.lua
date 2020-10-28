api_version = "1.12.0.0"

function OnScriptLoad()
    register_callback(cb["EVENT_JOIN"], "OnPlayerConnect")
end

function OnPlayerConnect(_)
    os.execute("echo \7")
end

function OnScriptUnload()
    -- N/A
end