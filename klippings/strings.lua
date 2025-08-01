-- Strings utils

local str_utils = {}

-- trim input string
str_utils.trim = function(str)
	return string.match(str, '^%s*(.-)%s*$')
end

return str_utils
