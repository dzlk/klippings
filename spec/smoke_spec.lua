local busted = require('busted')

local describe = busted.describe
local it = busted.it
local assert = busted.assert

describe('Smoke Test', function()
	it('should pass', function()
		assert.truthy(true)
	end)
end)
