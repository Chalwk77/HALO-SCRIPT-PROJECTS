-- Word Buster Add Word command file (v1.0)
-- Copyright (c) 2022, Jericho Crosby <jericho.crosby227@gmail.com>

local Command = {
    name = 'wb_add_word',
    description = 'Add a word to lang file',
    admin_level = 4,
    help = 'Syntax: /$cmd (word) (lang)',
    no_perm = 'You need to be level $lvl or higher to use this command.'
}

function Command:Run(Ply, Args)

    local word = Args[2]
    local lang = Args[3]
    local dir = self.settings.lang_directory
    local file = self.settings.languages[lang]

    if (self.permission(Ply, self.admin_level, self.no_perm)) then

        if (not word) then
            self.send(Ply, 'No word defined.')
            self.send(Ply, self.help)
        elseif (not lang) then
            self.send(Ply, 'Invalid lang file.')
            self.send(Ply, self.help)
        elseif (file == nil) then
            self.send(Ply, 'Lang file not found.')
        elseif (file == false) then
            self.send(Ply, 'Sorry, that lang file is disabled.')
        else

            local content = self.read(dir .. lang)
            if (content) then
                content = content .. '\n' .. word
            else
                self.send(Ply, 'Error. File not found.')
                return false
            end

            self.write(dir .. lang, content)
            self.send(Ply, 'Adding "' .. word .. '" to ' .. lang)
        end
    end

    return false
end

return Command