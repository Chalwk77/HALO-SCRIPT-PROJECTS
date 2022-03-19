-- Word Buster Message Handler file (v1.0)
-- Copyright (c) 2022, Jericho Crosby <jericho.crosby227@gmail.com>

local Message = {
    kick = function(id, option)
        local r = option.on_punish:gsub('$punishment', 'kicked')
        execute_command('k ' .. id .. ' ' .. r)
    end,
    ban = function(id, option)
        local r = option.on_punish:gsub('$punishment', 'banned')
        local d = option.ban_duration
        execute_command('ipban ' .. id .. ' ' .. d .. ' ' .. r)
    end
}

function Message:FormatNotify(name, word, pattern, lang)
    local msg = self.settings.notify_console_format
    if (self.settings.notify_console) then
        msg = msg              :gsub('$name', name):
        gsub('$word', word)    :
        gsub('$regex', pattern):
        gsub('$lang', lang)
        self.send(0, msg)
    end
end

local function IsCommand(Msg)
    return (Msg:sub(1, 1) == '/' or Msg:sub(1, 1) == '\\')
end

function Message:Send(Ply, Msg)

    if (not IsCommand(Msg)) then

        local words = self.settings.words
        local id = get_var(Ply, '$ip')
        local name = get_var(Ply, '$name')
        local word = Msg:lower():gsub('(.*)', ' %1 ')

        for i = 1, #words do

            local regex = words[i].regex
            local lang = words[i].language

            for j = 1, #regex do
                if (word:find('[^%a]' .. regex[j] .. '[^%a]')) then

                    word = words[i].word
                    self:FormatNotify(name, word, regex[j], lang)
                    self:NewInfraction(id, name)

                    if (self.infractions[id].warnings == self.settings.warnings) then
                        self.send(Ply, self.settings.last_warning)
                    elseif (self.infractions[id].warnings > self.settings.warnings) then
                        if (self.settings.punishment == 'kick') then
                            self.kick(Ply, self.settings)
                        elseif (self.settings.punishment == 'ban') then
                            self.ban(Ply, self.settings)
                        end
                        self.infractions[id] = nil
                    else
                        self.send(Ply, self.settings.notify_text)
                    end

                    self.write(self.settings.infractions_directory, self.infractions, true)
                    return false
                end
            end
        end
    end
end

local date = os.date
function Message:NewInfraction(id, name)

    local day = date('*t').day
    local month = date('*t').month
    local year = date('*t').year

    self.infractions[id] = self.infractions[id] or { warnings = 0 }
    self.infractions[id].last_infraction = { day = day, month = month, year = year }
    self.infractions[id].warnings = self.infractions[id].warnings + 1
    self.infractions[id].name = name
end

return Message