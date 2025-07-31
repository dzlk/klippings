local cli = require('cliargs')

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

	print(string.format('Running with file: %s', args.file))
end
