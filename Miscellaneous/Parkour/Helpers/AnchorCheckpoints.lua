local Objects = {}

function Objects:Anchor()

    for object, v in pairs(self.objects) do
        local memory = get_object_memory(object)
        if (memory ~= 0) then

            local x, y, z = v.x, v.y, v.z

            -- update object x,y,z coordinates:
            write_float(memory + 0x5C, x)
            write_float(memory + 0x60, y)
            write_float(memory + 0x64, z)

            -- update object velocities:
            write_float(memory + 0x68, 0) -- x vel
            write_float(memory + 0x6C, 0) -- y vel
            write_float(memory + 0x70, 0) -- z vel

            -- update object yaw, pitch, roll
            write_float(memory + 0x90, 0) -- yaw
            write_float(memory + 0x8C, 0) -- pitch
            write_float(memory + 0x94, 0) -- roll
        end
    end
end

return Objects