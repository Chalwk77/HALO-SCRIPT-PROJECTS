require "bit"

base64 = {}

--- octet -> char encoding.
local ENCODABET = {
	'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J',
	'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T',
	'U', 'V', 'W', 'X', 'Y', 'Z', 'a', 'b', 'c', 'd',
	'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n',
	'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x',
	'y', 'z', '0', '1', '2', '3', '4', '5', '6', '7',
	'8', '9', '-', '_'
}

--- char -> octet encoding.
local DECODABET = {}
for i, v in ipairs(ENCODABET) do
	DECODABET[v] = i - 1
end

local PAD = nil

--- Converts a 6-bit octet into the associated Base64 character.
--
-- @param octet A 6-bit integer.
-- @return The Base64 representation of the character
local function toChar (octet)
	return assert(ENCODABET[octet + 1], "No Base64 character for octet: "..tostring(octet))
end

--- Converts a Base64 character into the associated octet.
--
-- @param char The single Base64 character.
-- @return The 6-bit integer representing the Base64 character.
local function toOctet (char)
	return assert(DECODABET[char], "Not a valid Base64 character: "..tostring(char))
end

--- Encodes a string into a Base64 string.
-- The input can be any string of arbitrary bytes.
-- If the input is not a string, or the string is empty, an error will be thrown.
--
-- @param input The input string.
-- @return The Base64 representation of the input string.
function base64.encode (input)

	assert(type(input) == "string", "Invalid input, expected type string but got: "..tostring(input).." as a: "..type(input))
	assert(#input > 0, "Invalid input, cannot encode an empty string.")

	local bytes = { input:byte(i, #input) }

	local out = {}

	-- Go through each triplet of 3 bytes, which produce 4 octets.
	local i = 1
	while i <= #bytes - 2 do
		local buffer = 0

		-- Fill the buffer with the bytes, producing a 24-bit integer.
		local b = bit.blshift(bytes[i], 16)
		b = bit.band(b, 0xff0000)
		buffer = bit.bor(buffer, b)

		b = bit.blshift(bytes[i + 1], 8)
		b = bit.band(b, 0xff00)
		buffer = bit.bor(buffer, b)

		b = bit.band(bytes[i + 2], 0xff)
		buffer = bit.bor(buffer, b)

		-- Read out the 4 octets into the output buffer.
		b = bit.blogic_rshift(buffer, 18)
		b = bit.band(b, 0x3f)
		out[#out + 1] = toChar(b)

		b = bit.blogic_rshift(buffer, 12)
		b = bit.band(b, 0x3f)
		out[#out + 1] = toChar(b)

		b = bit.blogic_rshift(buffer, 6)
		b = bit.band(b, 0x3f)
		out[#out + 1] = toChar(b)

		b = bit.band(buffer, 0x3f)
		out[#out + 1] = toChar(b)

		i = i + 3
	end

	-- Special case 1: One byte extra, will produce 2 octets.
	if #bytes % 3 == 1 then
		local buffer = bit.blshift(bytes[i], 16)
		buffer = bit.band(buffer, 0xff0000)

		local b = bit.blogic_rshift(buffer, 18)
		b = bit.band(b, 0x3f)
		out[#out + 1] = toChar(b)

		b = bit.blogic_rshift(buffer, 12)
		b = bit.band(b, 0x3f)
		out[#out + 1] = toChar(b)

		out[#out + 1] = PAD
		out[#out + 1] = PAD

	-- Special case 2: Two bytes extra, will produce 3 octets.
	elseif #bytes % 3 == 2 then
		local buffer = 0

		local b = bit.blshift(bytes[i], 16)
		b = bit.band(b, 0xff0000)
		buffer = bit.bor(buffer, b)

		b = bit.blshift(bytes[i + 1], 8)
		b = bit.band(b, 0xff00)
		buffer = bit.bor(buffer, b)

		b = bit.blogic_rshift(buffer, 18)
		b = bit.band(b, 0x3f)
		out[#out + 1] = toChar(b)

		b = bit.blogic_rshift(buffer, 12)
		b = bit.band(b, 0x3f)
		out[#out + 1] = toChar(b)

		b = bit.blogic_rshift(buffer, 6)
		b = bit.band(b, 0x3f)
		out[#out + 1] = toChar(b)

		out[#out + 1] = PAD
	end

	return table.concat(out)

end

--- Decodes a Base64 string into an output string of arbitrary bytes.
-- If the input is not a string, or the string is empty, or the string is not well-formed Base64, an error will be thrown.
--
-- @param input The Base64 input to decode.
-- @return The decoded Base64 string, as a string of bytes.
function base64.decode (input)

	assert(type(input) == "string", "Invalid input, expected type string but got: "..tostring(input).." as a: "..type(input))
	assert(#input > 0, "Invalid input, cannot decode an empty string.")

	local length = #input
	-- Ignore any padding.
	if PAD then
		length = input:find(PAD, 1, true) or (length + 1)
		length = length - 1
	end
	assert(length > 0, "Invalid input, cannot decode a padded string with no bytes: "..tostring(input))

	local out = {}

	-- Go through each group of 4 octets to obtain 3 bytes.
	local i = 1
	while i <= length - 3 do
		local buffer = 0

		-- Read the 4 octets into the buffer, producing a 24-bit integer.
		local b = toOctet(input:sub(i, i))
		b = bit.blshift(b, 18)
		buffer = bit.bor(buffer, b)
		i = i + 1

		b = toOctet(input:sub(i, i))
		b = bit.blshift(b, 12)
		buffer = bit.bor(buffer, b)
		i = i + 1

		b = toOctet(input:sub(i, i))
		b = bit.blshift(b, 6)
		buffer = bit.bor(buffer, b)
		i = i + 1

		b = toOctet(input:sub(i, i))
		buffer = bit.bor(buffer, b)
		i = i + 1

		-- Append the 3 re-constructed bytes into the output buffer.
		b = bit.blogic_rshift(buffer, 16)
		b = bit.band(b, 0xff)
		out[#out + 1] = b

		b = bit.blogic_rshift(buffer, 8)
		b = bit.band(b, 0xff)
		out[#out + 1] = b

		b = bit.band(buffer, 0xff)
		out[#out + 1] = b
	end

	-- Special case 1: Only 2 octets remain, producing 1 byte.
	if length % 4 == 2 then
		local buffer = 0

		local b = toOctet(input:sub(i, i))
		b = bit.blshift(b, 18)
		buffer = bit.bor(buffer, b)
		i = i + 1

		b = toOctet(input:sub(i, i))
		b = bit.blshift(b, 12)
		buffer = bit.bor(buffer, b)
		i = i + 1

		b = bit.blogic_rshift(buffer, 16)
		b = bit.band(b, 0xff)
		out[#out + 1] = b

	-- Special case 2: Only 3 octets remain, producing 2 bytes.
	elseif length % 4 == 3 then
		local buffer = 0

		local b = toOctet(input:sub(i, i))
		b = bit.blshift(b, 18)
		buffer = bit.bor(buffer, b)
		i = i + 1

		b = toOctet(input:sub(i, i))
		b = bit.blshift(b, 12)
		buffer = bit.bor(buffer, b)
		i = i + 1

		b = toOctet(input:sub(i, i))
		b = bit.blshift(b, 6)
		buffer = bit.bor(buffer, b)
		i = i + 1

		b = bit.blogic_rshift(buffer, 16)
		b = bit.band(b, 0xff)
		out[#out + 1] = b

		b = bit.blogic_rshift(buffer, 8)
		b = bit.band(b, 0xff)
		out[#out + 1] = b

	-- Special case 3: One octet remains, we can't get any bytes out of this, throw error.
	elseif length % 4 == 1 then
		error("Invalid length input string, extra character: "..tostring(input:sub(i, i)))
	end

	return string.char(unpack(out))

end
