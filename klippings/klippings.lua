local cli = require('cliargs')

local parser = require('klippings.parser')

return function()
	cli:set_name('klippings')
	cli:argument('file', 'Path to Clippings.txt')

	local args, err = cli:parse()

	if not args and err then
		-- something wrong happened and an error was printed
		io.write(string.format('%s: %s; re-run with help for usage', cli.name, err))
		os.exit(1)
	end

	io.write(string.format('Try open file: %s', args.file))
	local fd = assert(io.open(args.file, 'r'))

	-- FIXME: Move to parser
	local separator = '=========='
	local modes = {
		title = 1,
		info = 2,
		content = 3,
	}
	local mode = modes.title
	for line in fd:lines() do
		if mode == modes.title and line then
			local title, authors = parser.extract_title(line)

			-- TODO: remove prints
			print('Title:' .. title)
			print('Authors: ' .. table.concat(authors, ', '))
			mode = modes.info

			goto continue
		end

		if mode == modes.info then
			-- TODO: remove prints
			print('Info line: \n' .. line)
			mode = modes.content

			goto continue
		end

		if string.sub(line, 1, #separator) == separator then
			mode = modes.title
			-- TODO: remove print
			print(separator .. '\n')

			goto continue
		end

		if mode == modes.content then
			-- TODO: remove print
			print('add content: \n' .. line)
		end

		::continue::
	end

	fd:close()

	--	print('Readed content:')
	--	print(content)
end
