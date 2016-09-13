-- Full Spec and spawn object script. z1'
 
function GetRequiredVersion()
        return 200
end
 
 
function OnScriptLoad(process)
end
 
 
function OnScriptUnload()
end
 
 
function OnNewGame(map)
           
    if map == "bloodgulch" then
        createobject("eqip", "powerups\\full-spectrum vision", 0, 60, false, 116.43, -126.52, 1.62)
            createobject("eqip", "powerups\\full-spectrum vision", 0, 180, false, 116.43, -126.52, 1.62)
                createobject("eqip", "powerups\\full-spectrum vision", 0, 300, false, 116.43, -126.52, 1.62)
                createobject("eqip", "powerups\\full-spectrum vision", 0, 420, false, 116.43, -126.52, 1.62)
                createobject("eqip", "powerups\\full-spectrum vision", 0, 540, false, 116.43, -126.52, 1.62)
                createobject("eqip", "powerups\\full-spectrum vision", 0, 660, false, 116.43, -126.52, 1.62)
        elseif map == "carousel" then
            createobject("eqip", "powerups\\full-spectrum vision", 0, 60, false, 1.59, -3.32, -2.56)
                createobject("eqip", "powerups\\full-spectrum vision", 0, 180, false, 1.59, -3.32, -2.56)
                createobject("eqip", "powerups\\full-spectrum vision", 0, 300, false, 1.59, -3.32, -2.56)
                createobject("eqip", "powerups\\full-spectrum vision", 0, 420, false, 1.59, -3.32, -2.56)
            createobject("eqip", "powerups\\full-spectrum vision", 0, 540, false, 1.59, -3.32, -2.56)
            createobject("eqip", "powerups\\full-spectrum vision", 0, 660, false, 1.59, -3.32, -2.56)
        elseif map == "infinity" then
        createobject("eqip", "powerups\\full-spectrum vision", 0, 60, false, -57.89, -97.87, 12.93)
            createobject("eqip", "powerups\\full-spectrum vision", 0, 180, false, -57.89, -97.87, 12.93)
                createobject("eqip", "powerups\\full-spectrum vision", 0, 300, false, -57.89, -97.87, 12.93)
                createobject("eqip", "powerups\\full-spectrum vision", 0, 420, false, -57.89, -97.87, 12.93)
                createobject("eqip", "powerups\\full-spectrum vision", 0, 540, false, -57.89, -97.87, 12.93)
                createobject("eqip", "powerups\\full-spectrum vision", 0, 660, false, -57.89, -97.87, 12.93)
        elseif map == "danger canyon" then
        createobject("eqip", "powerups\\full-spectrum vision", 0, 60, false, -18.36, 35.93, -7.24)     
        createobject("eqip", "powerups\\full-spectrum vision", 0, 180, false, -18.36, 35.93, -7.24)
        createobject("eqip", "powerups\\full-spectrum vision", 0, 300, false, -18.36, 35.93, -7.24)
        createobject("eqip", "powerups\\full-spectrum vision", 0, 420, false, -18.36, 35.93, -7.24)
        createobject("eqip", "powerups\\full-spectrum vision", 0, 540, false, -18.36, 35.93, -7.24)
        createobject("eqip", "powerups\\full-spectrum vision", 0, 660, false, -18.36, 35.93, -7.24)            
    elseif map == "death island" then
        createobject("eqip", "powerups\\full-spectrum vision", 0, 60, false, -26.69, -3.18, 7.61)      
        createobject("eqip", "powerups\\full-spectrum vision", 0, 180, false, -26.69, -3.18, 7.61)     
        createobject("eqip", "powerups\\full-spectrum vision", 0, 300, false, -26.69, -3.18, 7.61)     
        createobject("eqip", "powerups\\full-spectrum vision", 0, 420, false, -26.69, -3.18, 7.61)     
        createobject("eqip", "powerups\\full-spectrum vision", 0, 540, false, -26.69, -3.18, 7.61)     
        createobject("eqip", "powerups\\full-spectrum vision", 0, 660, false, -26.69, -3.18, 7.61)
    elseif map == "chillout" then
        createobject("eqip", "powerups\\full-spectrum vision", 0, 60, false, 1.62, 4.79, 3.11) 
        createobject("eqip", "powerups\\full-spectrum vision", 0, 180, false, 1.62, 4.79, 3.11)
        createobject("eqip", "powerups\\full-spectrum vision", 0, 300, false, 1.62, 4.79, 3.11)
        createobject("eqip", "powerups\\full-spectrum vision", 0, 420, false, 1.62, 4.79, 3.11)
        createobject("eqip", "powerups\\full-spectrum vision", 0, 540, false, 1.62, 4.79, 3.11)
        createobject("eqip", "powerups\\full-spectrum vision", 0, 660, false, 1.62, 4.79, 3.11)
    elseif map == "icefields" then
        createobject("eqip", "powerups\\full-spectrum vision", 0, 60, false, 18.99, 10.09, 4.42)       
        createobject("eqip", "powerups\\full-spectrum vision", 0, 180, false, 18.99, 10.09, 4.42)      
        createobject("eqip", "powerups\\full-spectrum vision", 0, 300, false, 18.99, 10.09, 4.42)      
        createobject("eqip", "powerups\\full-spectrum vision", 0, 420, false, 18.99, 10.09, 4.42)      
        createobject("eqip", "powerups\\full-spectrum vision", 0, 540, false, 18.99, 10.09, 4.42)      
        createobject("eqip", "powerups\\full-spectrum vision", 0, 660, false, 18.99, 10.09, 4.42)      
    elseif map == "ratrace" then
        createobject("eqip", "powerups\\full-spectrum vision", 0, 60, false, 15.45, -18.65, -1.16)
        createobject("eqip", "powerups\\full-spectrum vision", 0, 180, false, 15.45, -18.65, -1.16)
        createobject("eqip", "powerups\\full-spectrum vision", 0, 300, false, 15.45, -18.65, -1.16)
        createobject("eqip", "powerups\\full-spectrum vision", 0, 420, false, 15.45, -18.65, -1.16)
        createobject("eqip", "powerups\\full-spectrum vision", 0, 540, false, 15.45, -18.65, -1.16)
        createobject("eqip", "powerups\\full-spectrum vision", 0, 660, false, 15.45, -18.65, -1.16)    
    elseif map == "wizard" then
        createobject("eqip", "powerups\\full-spectrum vision", 0, 60, false, -5.05, -3.02, -2.75)
        createobject("eqip", "powerups\\full-spectrum vision", 0, 180, false, -5.05, -3.02, -2.75)
        createobject("eqip", "powerups\\full-spectrum vision", 0, 300, false, -5.05, -3.02, -2.75)
        createobject("eqip", "powerups\\full-spectrum vision", 0, 420, false, -5.05, -3.02, -2.75)
        createobject("eqip", "powerups\\full-spectrum vision", 0, 540, false, -5.05, -3.02, -2.75)
        createobject("eqip", "powerups\\full-spectrum vision", 0, 660, false, -5.05, -3.02, -2.75)     
    elseif map == "damnation" then
        createobject("eqip", "powerups\\full-spectrum vision", 0, 60, false, -0.53, -0.94, 1)
        createobject("eqip", "powerups\\full-spectrum vision", 0, 180, false, -0.53, -0.94, 1)
        createobject("eqip", "powerups\\full-spectrum vision", 0, 300, false, -0.53, -0.94, 1)
        createobject("eqip", "powerups\\full-spectrum vision", 0, 420, false, -0.53, -0.94, 1)
        createobject("eqip", "powerups\\full-spectrum vision", 0, 540, false, -0.53, -0.94, 1)
        createobject("eqip", "powerups\\full-spectrum vision", 0, 660, false, -0.53, -0.94, 1) 
    elseif map == "gephyrophobia" then
        createobject("eqip", "powerups\\full-spectrum vision", 0, 60, false, 18.7, -130.25, -15.89)
        createobject("eqip", "powerups\\full-spectrum vision", 0, 180, false, 18.7, -130.25, -15.89)
        createobject("eqip", "powerups\\full-spectrum vision", 0, 300, false, 18.7, -130.25, -15.89)
        createobject("eqip", "powerups\\full-spectrum vision", 0, 420, false, 18.7, -130.25, -15.89)
        createobject("eqip", "powerups\\full-spectrum vision", 0, 540, false, 18.7, -130.25, -15.89)
        createobject("eqip", "powerups\\full-spectrum vision", 0, 660, false, 18.7, -130.25, -15.89)
    elseif map == "hangemhigh" then                    
        createobject("eqip", "powerups\\full-spectrum vision", 0, 60, false, 33.49, 6.34, -7.95)
                createobject("eqip", "powerups\\full-spectrum vision", 0, 180, false, 33.49, 6.34, -7.95)
                createobject("eqip", "powerups\\full-spectrum vision", 0, 300, false, 33.49, 6.34, -7.95)
                createobject("eqip", "powerups\\full-spectrum vision", 0, 420, false, 33.49, 6.34, -7.95)
                createobject("eqip", "powerups\\full-spectrum vision", 0, 540, false, 33.49, 6.34, -7.95)
                createobject("eqip", "powerups\\full-spectrum vision", 0, 660, false, 33.49, 6.34, -7.95)
        elseif map == "sidewinder" then
            createobject("eqip", "powerups\\full-spectrum vision", 0, 60, false, 9.11, 3.68, -2.19)
                createobject("eqip", "powerups\\full-spectrum vision", 0, 180, false, 9.11, 3.68, -2.19)
                createobject("eqip", "powerups\\full-spectrum vision", 0, 300, false, 9.11, 3.68, -2.19)
                createobject("eqip", "powerups\\full-spectrum vision", 0, 420, false, 9.11, 3.68, -2.19)
                createobject("eqip", "powerups\\full-spectrum vision", 0, 540, false, 9.11, 3.68, -2.19)
                createobject("eqip", "powerups\\full-spectrum vision", 0, 660, false, 9.11, 3.68, -2.19)
    end        
 
end
 
 
function OnGameEnd(mode)
       
end
 
 
function OnServerChat(player, chattype, message)
        return 1
end
 
 
function OnServerCommand(player, command)
        return 1
end
 
 
function OnTeamDecision(cur_team)
        return cur_team
end
 
 
function OnPlayerJoin(player, team)
end
 
 
function OnPlayerLeave(player, team)
end
 
function OnPlayerKill(killer, victim, mode)
end
 
 
function OnKillMultiplier(player, multiplier)
end
 
 
function OnPlayerSpawn(player, m_objectId)
end
 
 
function OnPlayerSpawnEnd(player, m_objectId)
 
end
 
 
function OnTeamChange(relevant, player, team, dest_team)
        return 1
end
 
function OnClientUpdate(player, m_objectId)
 
 
end
 
 
function OnObjectInteraction(player, m_ObjectId, tagType, tagName)
        return 1
end
 
 
function OnWeaponReload(player, weapon)
        return 1
end
 
 
function OnVehicleEntry(relevant, player, vehicleId, vehicle_tag, seat)
        return 1
end
 
 
function OnVehicleEject(player, forceEject)
        return 1
end
 
 
 
function OnDamageLookup(receiving_obj, causing_obj, tagdata, tagname)
end
 
 
function OnWeaponAssignment(player, object, count, tag)
end
 
 
function OnObjectCreation(m_objectId, player_owner, tag)
end
 
 
function OnGrenadeSwap(player, cur_nadetype, next_nadetype)
 
end