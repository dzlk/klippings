# Klippings

A utility for parsing Kindle Clippings and saving them in the required format

```
klippings path/to/file

## Show help
klippings --help
```

## Develop

Install dependencies:
- lua
- stylua

Run the app:
```
luarocks build

./lua_modules/bin/klippings
```

Run tests:
```
luarocks test
```

Run lint and checks:
```
stylua .
luacheck src
```

### Use mise for a comfortable development experience
Install mise: https://mise.jdx.dev/installing-mise.html

Trust config: `mise trust`

Tasks:
```
mise test   # running tests
mise build  # build app
```

Mise automatically adds `./lua_modules/bin/` to PATH. 
Therefore, you can launch the application without specifying a path:
```
klippings
```

If you want to add a watcher, install `watchexec`:
```
mise use -g watchexec@latest
```

Then you can run tasks with watch:
```
mise watch test
```
