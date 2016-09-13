function GetRequiredVersion() return 200 end
function OnScriptLoad(processid, game, persistent) end
function OnScriptUnload() end
function OnTeamChange(player, old_team, new_team, relevant) if relevant then return false end end