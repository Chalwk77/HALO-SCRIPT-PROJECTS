function convertbase(num, ib, ob)

	num = tostring(num)

	local digits = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"

	if ib == ob then return num end
	if ib > 36 or ib < 2 or ob > 36 or ob < 2 then return nil end

	local dec = 0
	
	if ib ~= 10 then
		-- Convert to Decimal
		local len = string.len(tostring(num))
		for i = 1,len do
			local d = tonumber(string.sub(num, i, i))
			dec = dec + (d * (ib) ^ (len - i))
		end
	else
		dec = num
	end

	-- Convert from Decimal to Output Base
	local str = ""
	repeat
		local d = (dec % ob) + 1
		dec = math.floor(dec / ob)
		str = string.sub(digits, d, d) .. str
	until dec == 0

	return str
end