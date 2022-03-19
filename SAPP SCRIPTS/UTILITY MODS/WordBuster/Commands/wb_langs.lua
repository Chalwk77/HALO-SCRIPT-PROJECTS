-- Word Buster List Langs command file (v1.0)
-- Copyright (c) 2022, Jericho Crosby <jericho.crosby227@gmail.com>

local Command = {
    name = 'wb_langs',
    description = 'Show list of langs',
    admin_level = 4,
    help = 'Syntax: /$cmd',
    no_perm = 'You need to be level $lvl or higher to use this command.'
}

function Command:Run(Ply)
    if (self.permission(Ply, self.admin_level, self.no_perm)) then
        self.send(Ply, 'Enabled Languages:')
        for Lang, Enabled in pairs(self.settings.languages) do
            if (Enabled) then
                self.send(Ply, Lang)
            end
        end
    end
    return false
end

return Command