require('luarocks.loader')
local busted = require('busted')

local strings = require('klippings.strings')

local describe, it, assert = busted.describe, busted.it, busted.assert

describe('trim :: ', function()
	it('should trim spaces', function()
		assert.equal('some strings', strings.trim('  some strings    '))
	end)

	it('should correct work with normal string', function()
		assert.equal('some', strings.trim('some'))
	end)
end)
