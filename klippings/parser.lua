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

-- "– Ваш выделенный отрывок в месте 2147–2148 | Добавлено: воскресенье, 16 июня 2019 г. в 23:38:53"
local pattern = '^– %D+ (%d+)–(%d+) | Добавлено: %D+ (%d+) (%D+) (%d+) г. в (%d+):(%d+):(%d+)$'
local months = {
	'января',
	'февраля',
	'марта',
	'апреля',
	'мая',
	'июня',
	'июля',
	'августа',
	'сентября',
	'октября',
	'ноября',
	'декабря',
}
local get_month_number = function(month)
	for num, name in pairs(months) do
		if month == name then
			return num
		end
	end
end
parser.extract_info = function(str)
	local loc_start, loc_end, day, month, year, hour, minute, second = string.match(trim(str), pattern)

	month = get_month_number(month)

	local time = 0
	if day and month and year and hour and minute and second then
		time = os.time({
			year = year,
			month = month,
			day = day,
			hour = hour,
			min = minute,
			sec = second,
		})

		-- validate time
		-- FIXME: lint warning
		if os.time(os.date('*t', time)) ~= time then
			time = 0
		end
	end

	loc_start = tonumber(loc_start)
	loc_end = tonumber(loc_end)
	local loc = loc_start and loc_end and { loc_start, loc_end } or { 0, 0 }

	return loc, time
end

return parser
