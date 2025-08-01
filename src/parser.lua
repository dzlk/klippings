local str_utils = require('klippings.strings')

local parser = {}
local trim = str_utils.trim

-- find_authors_braces find coordinates substring with authors
local function find_authors_braces(str)
	local r = -1

	for i = #str, 1, -1 do
		local c = string.sub(str, i, i)
		if c == ')' then
			r = i
		elseif c == '(' then
			return i, r
		end
	end

	return -1, -1
end

-- fix_title replace bad symbols
local function fix_title(title)
	title = string.gsub(title, '%)', '')
	title = string.gsub(title, '%s*%(', '. ')

	return title
end

-- extract_title function tries to get the book title and authors
parser.extract_title = function(str)
	local title = trim(str)
	local authors = {}

	local l, r = find_authors_braces(str)
	if l > -1 and r > -1 then
		title = trim(string.sub(str, 1, l - 1))

		local authors_str = trim(string.sub(str, l + 1, r - 1))
		for author in string.gmatch(authors_str, '([^,]+)') do
			table.insert(authors, trim(author))
		end
	end

	return fix_title(title), authors
end

return parser
