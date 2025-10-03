-- Strings utils

local str_utils = {}

-- trim input string
str_utils.trim = function(str)
	str = string.gsub(str, '^%s*(.-)%s*$', '%1')
	return str
end

return str_utils
