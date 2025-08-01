rockspec_format = '3.0'

package = 'klippings'
version = 'dev-1'
source = {
	url = '*** please add URL for source tarball, zip or repository here ***',
}
description = {
	homepage = '*** please enter a project homepage ***',
	license = '*** please specify a license ***',
}
dependencies = {
	'lua >= 5.4',
	'lua_cliargs >= 3.0',
}
build_dependencies = {
	'luacheck >= 1.2',
}
build = {
	type = 'builtin',
	modules = {
		['klippings'] = 'src/klippings.lua',
		['klippings.parser'] = 'src/parser.lua',
		['klippings.strings'] = 'src/strings.lua',
	},
	install = {
		bin = {
			['klippings'] = 'bin/klippings',
		},
	},
}
test_dependencies = {
	'busted',
}
test = {
	type = 'busted',
}
