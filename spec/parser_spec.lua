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
