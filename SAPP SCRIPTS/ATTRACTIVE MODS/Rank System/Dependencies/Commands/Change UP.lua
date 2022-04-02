-- Rank System [Change UP Command File] (v1.0)
-- Copyright (c) 2022, Jericho Crosby <jericho.crosby227@gmail.com>

local Command = {
    command_name = 'cpu', -- short for change password/username
    admin_level = -1,
    help = 'Syntax: /cpu [current/new username] [current/new password]',
    description = 'Change your account password',
    no_perm = 'You need to be level -1 or higher to use this command.'
}

function Command:Run(Ply, Args)
    if (Ply == 0) then
        cprint('Sorry, you cannot execute this command from terminal.', 12)
        return false
    elseif (self.permission(Ply, self.admin_level, self.no_perm)) then

        local t = self:GetPlayer(Ply)

        local username = Args[2]
        local password = Args[3]
        if (not username or not password) then
            t:Send(self.help)
            return false
        end

        local acc = self.db[t.username]
        if (not t.logged_in) then
            t:Send('You need to be logged in to do that.')
        elseif (#Args > 3) then
            t:Send('Too many arguments!')
            t:Send('Make sure username & password do not contain spaces.')
        elseif (acc) then

            if (acc.username ~= username and acc.password ~= password) then
                t:Send('Username & Password changed')
            elseif (acc.username == username and acc.password ~= password) then
                t:Send('Password changed')
            elseif (acc.username ~= username and acc.password == password) then
                t:Send('Username changed')
            end

            self.db[username] = self.db[t.username]
            self.db[username].password = password
            self.db[t.username] = nil

            t.username = username
            self:Update()
        else
            t:Send('Something went wrong')
        end
    end

    return false
end

return Command