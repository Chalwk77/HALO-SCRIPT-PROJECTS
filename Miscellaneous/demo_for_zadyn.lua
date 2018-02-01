api_version = "1.12.0.0"
message_board = {"Welcome to $SERVER_NAME"}
function OnScriptLoad()
    register_callback(cb['EVENT_JOIN'], "OnPlayerJoin")
end
function OnPlayerJoin(PlayerIndex)
    for k,v in pairs(message_board) do
        rprint(v)
    end
end
