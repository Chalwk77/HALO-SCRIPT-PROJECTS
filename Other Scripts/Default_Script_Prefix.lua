default_script_prefix = "* "
phasor_privatesay = privatesay
phasor_say = say
function say(message, script_prefix)
    if GAME == "PC" then
        phasor_say((script_prefix or default_script_prefix) .. " " .. message, false)
    else
        phasor_say(message, false)
    end
end

function privatesay(player, message, script_prefix)
    if GAME == "PC" then
        phasor_privatesay(player, (script_prefix or default_script_prefix) .. " " .. message, false)
    else
        phasor_privatesay(player, message, false)
    end
end

function Say(message, time, exception)
	time = time or 3
	for i=0,15 do
		if getplayer(i) and exception ~= i then
			privateSay(i, message, time)
		end
	end
end

function privateSay(player, message, time)
	local time = time or 3
	if message then
		sendconsoletext(player, message, time)
	end
end