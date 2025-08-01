local cli = require('cliargs')

local parser = require('klippings.parser')

return function()
	cli:set_name('klippings')
	cli:argument('file', 'Path to Clippings.txt')

	local args, err = cli:parse(arg)

	print(args)

	if not args and err then
		-- something wrong happened and an error was printed
		print(string.format('%s: %s; re-run with help for usage', cli.name, err))
		os.exit(1)
	end

	print(string.format('Try open file: %s', args.file))
	local fd = assert(io.open(args.file, 'r'))

	local separator = '=========='
	local modes = {
		title = 1,
		content = 2,
	}
	local mode = modes.title
	for line in fd:lines() do
		if mode == modes.title and line then
			print(parser.extract_title(line))
			mode = modes.content

			goto continue
		end
		if string.sub(line, 1, #separator) == separator then
			mode = modes.title
		end

		::continue::
	end

	fd:close()

	--	print('Readed content:')
	--	print(content)
end
