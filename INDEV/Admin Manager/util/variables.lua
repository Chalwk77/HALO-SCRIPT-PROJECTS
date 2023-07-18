local variables = {}

function variables:registerLevelVariable()
    execute_command(
        "var_add " .. self.custom_level_var_name .. " 4"
    )
end

function variables:unregisterLevelVariable()
    execute_command(
        "var_del " .. self.custom_level_var_name
    )
end

function variables:setLevelVariable()
    execute_command(
        "var_set " .. self.custom_level_var_name ..
        " " .. self.level .. " " .. self.id 
    )
end

return variables