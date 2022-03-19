-- Word Buster Disable Lang command file (v1.0)
-- Copyright (c) 2022, Jericho Crosby <jericho.crosby227@gmail.com>

local Command = {
    name = 'wb_disable_lang',
    description = 'Disable lang file',
    admin_level = 4,
    help = 'Syntax: /$cmd',
    no_perm = 'You need to be level $lvl or higher to use this command.'
}

function Command:Run(Ply, Args)

    if (self.permission(Ply, self.admin_level, self.no_perm)) then

        local lang = Args[2]
        local file = self.settings.languages[lang]

        if (file == nil) then
            self.send(Ply, 'Lang file not found.')
        elseif (not lang) then
            self.send(Ply, 'Invalid lang file.')
            self.send(Ply, self.help)
        elseif (file == false) then
            self.send(Ply, lang .. ' is already disabled')
        else
            self.send(Ply, 'Disabling ' .. lang .. ', please wait...')
            self.settings.languages[lang] = false
            self.ReloadLangs:Load()
        end
    end
    return false
end

return Command