--[[    
Document Name: On Player Score Messages
                Version : 1.00
                Creator(s): {ØZ}Çhälwk'
                Xfire : Chalwk77
	Website(s): www.joinoz.proboards.com AND www.phasor.proboards.com
	Gaming Clan: {ØZ} Elite SDTM Clan - on HALO PC.
	Server Name: {OZ}-12 Elite Combat Server - OZ Clan
	Script Status: Not completed

	
		
	 To Do List:
]]--
scores = {} -- OnPlayerScore
function OnScriptLoad(process, game, persistent)
    -- OnPlayerScore
    if game == true or game == "PC" then
        gametype_game = readbyte(0x671340 + 0x30)
    	team_play = readbyte(0x671340 + 0x34)
	else
		gametype_game = readbyte(0x5F5498 + 0x30)
		team_play = readbyte(0x5F5498 + 0x34)
	end
--------------------------------------------------------------------------------------------------------------------------------------
function GetRequiredVersion() return 200 end 
function OnScriptLoad(processid, game, persistent) end 
--------------------------------------------------------------------------------------------------------------------------------------
	-- OnPlayerScore
	local ip = getip(player)
	local score = getscore(player)
	if scores[ip] == nil and score > 0 then scores[ip] = score end
	if score > (scores[ip] or 0) then
		OnPlayerScore(player, score, gametype_game)
		scores[ip] = score
	end

function getscore(player) -- OnPlayerScore
        local score = 0
        local timed = false
        local m_player = getplayer(player)
        if gametype_game == 1 then
                score = readword(m_player + 0xC8)
        elseif gametype_game == 2 then
                local kills = readword(m_player + 0x9C)
                local antikills = 0
                if team_play == 0 then
                        antikills = readword(m_player + 0xB0)
                else
                        antikills = readword(m_player + 0xAC)
                end
                score = kills - antikills
        elseif gametype_game == 3 then
                local oddball_type = readbyte(gametype_base + 0x8C)
                if oddball_type == 0 or oddball_type == 1 then
                        timed = true
                        score = readdword(0x639E5C + player)
                else
                        score = readword(m_player + 0xC8)
                end
        elseif gametype_game == 4 then
                timed = true
                score = readword(m_player + 0xC4)
        elseif gametype_game == 5 then
                score = readword(m_player + 0xC6)
        end
        if timed then score = math.floor(score / 30) end
        return score
end