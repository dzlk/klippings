require('luarocks.loader')
local busted = require('busted')

local parser = require('klippings.parser')

local describe, it, assert = busted.describe, busted.it, busted.assert

--

local function extract(str)
	return parser.extract_title(str)
end

describe('Test parsing title ::', function()
	it('should extract title without author', function()
		local title, authors = extract('Time Predictions')

		assert.equal('Time Predictions', title)
		assert.same(authors, {})
	end)

	it('should extract title and author', function()
		local title, authors = extract('Time Predictions (Halkjelsvik)')

		assert.equal('Time Predictions', title)
		assert.same({ 'Halkjelsvik' }, authors)
	end)

	it('should extract title and many authors', function()
		local title, authors = extract('Time Predictions (Halkjelsvik, Torleif)')

		assert.equal('Time Predictions', title)
		assert.same({ 'Halkjelsvik', 'Torleif' }, authors)
	end)

	it('should extract title with braces', function()
		local title, authors = extract('Time Predictions (Simula SpringerBriefs on Computing) (Halkjelsvik, Torleif)')
		assert.equal('Time Predictions. Simula SpringerBriefs on Computing', title)
		assert.same({ 'Halkjelsvik', 'Torleif' }, authors)
	end)
end)

describe('Test parsing info (Ru)) ::', function()
	local make_loc_str = function(loc_start, loc_end)
		return string.format('%d–%d', loc_start, loc_end)
	end
	local make_test_str = function(loc, date, time)
		return string.format(
			'– Ваш выделенный отрывок в месте %s | Добавлено: деньнедели, %s г. в %s',
			loc,
			date,
			time
		)
	end
	local cases = {
		{ { 101, 150 }, '1 января 2015', '08:13:22', '2015-01-01T08:13:22' },
		{ { 201, 250 }, '14 февраля 2016', '21:45:09', '2016-02-14T21:45:09' },
		{ { 301, 350 }, '23 марта 2017', '15:27:48', '2017-03-23T15:27:48' },
		{ { 401, 450 }, '7 апреля 2018', '06:56:35', '2018-04-07T06:56:35' },
		{ { 501, 550 }, '30 мая 2019', '19:30:01', '2019-05-30T19:30:01' },
		{ { 601, 650 }, '12 июня 2020', '11:05:43', '2020-06-12T11:05:43' },
		{ { 701, 750 }, '7 июля 2021', '13:59:16', '2021-07-07T13:59:16' },
		{ { 801, 850 }, '18 августа 2022', '17:44:58', '2022-08-18T17:44:58' },
		{ { 901, 950 }, '28 сентября 2023', '22:22:10', '2023-09-28T22:22:10' },
		{ { 1001, 1050 }, '5 октября 2024', '00:15:55', '2024-10-05T00:15:55' },
		{ { 1101, 1150 }, '11 ноября 2025', '09:07:32', '2025-11-11T09:07:32' },
		{ { 1201, 1250 }, '22 декабря 2026', '14:38:49', '2026-12-22T14:38:49' },
	}

	for k = 1, #cases do
		local loc, date, time, expected = table.unpack(cases[k])
		local loc_str = make_loc_str(loc[1], loc[2])
		local test_str = make_test_str(loc_str, date, time)

		it(string.format('should parse correct: "%s"', test_str, expected), function()
			local actual_loc, actual_time = parser.extract_info(test_str)

			assert.same(loc, actual_loc)
			assert.equal(expected, os.date('%Y-%m-%dT%H:%M:%S', actual_time))
		end)
	end

	it('should return zero time if passed bad month', function()
		local _, time = parser.extract_info(make_test_str(make_loc_str(0, 0), '13 март 2006', '00:00:00'))

		assert.equal(0, time)
	end)

	it('should return zero time if passed incorrect time', function()
		local _, time = parser.extract_info(make_test_str(make_loc_str(0, 0), '13 марта 2006', '25:00:00'))

		assert.equal(0, time)
	end)
end)
