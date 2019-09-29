--[[
--=====================================================================================================--
Script Name: VPN Blocker (VERSION 3), for SAPP (PC & CE)

This mod requires that you install all of the following database files to your servers root directory: 
https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/tree/master/Miscellaneous/VPN%20Blocker%20Database

Copyright (c) 2019, Jericho Crosby <jericho.crosby227@gmail.com>
* Notice: You can use this document subject to the following conditions:
https://github.com/Chalwk77/Halo-Scripts-Phasor-V2-/blob/master/LICENSE

* Written by Jericho Crosby (Chalwk)
--=====================================================================================================--
]] --

api_version = "1.12.0.0"

local vpn_blocker = { 
    database = {
        
        'firehol_proxies.netset',
        'firehol_level1.netset',
        'firehol_level2.netset',
        'firehol_level3.netset',
        
        'firehol_level4.netset',
        'firehol_abusers_1d.netset',
        
        'proxylists.netset',
        'proxylists_1d.netset',
        'proxylists_7d.netset',
        'proxylists_30d.netset',
        
        'bm_tor.netset',
        'vpn_ipv4.netset',
    },
    ips = {},
    action = "kick",
    feedback = "We\'ve detected that you\'re using a VPN or Proxy - we do not allow these!'"
}

function OnScriptLoad()
    vpn_blocker:GetData()
    register_callback(cb["EVENT_PREJOIN"], "OnPreJoin")
end

function OnPreJoin(p)
    local player = vpn_blocker:GetCredentials(p)
    for _,v in pairs(vpn_blocker.ips) do
        if (player.ip == v) then
            say(p, vpn_blocker.feedback)
            if (vpn_blocker.action == "kick") then
                execute_command("k " .. p)
                cprint(player.name .. " was kicked for using a VPN or Proxy", 4+8)
                log_note(player.name .. " was kicked for using a VPN or Proxy (IP: " .. player.ip .. " )")
            elseif (vpn_blocker.action == "ban") then
                execute_command("ipban " .. p)
                cprint(player.name .. " was banned for using a VPN or Proxy", 4+8)
                log_note(player.name .. " was banned for using a VPN or Proxy (IP: " .. player.ip .. " )")
            end
        end
    end
end

function vpn_blocker:GetData()
    cprint("VPN Blocker -> Retrieving vpn-ipv4 addresses. Please wait...", 2+8)
    
    local files = vpn_blocker.database
    
    for i = 1,#files do
        for line in io.lines(files[i]) do
            local ip = line:match('(%d+.%d+.%d+.%d+)')
            vpn_blocker.ips[#vpn_blocker.ips + 1] = ip
        end
    end
    cprint("VPN Blocker -> Successfully stored (" .. #vpn_blocker.ips .. ") vpn-ipv4 IPs.", 2+8)
end

function vpn_blocker:GetCredentials(p)
    local ip = get_var(p, "$ip")
    local name = get_var(p, "$name")
    return {ip = ip:match('(%d+.%d+.%d+.%d+)'), name = name}
end

function OnScriptUnload()
    --
end
