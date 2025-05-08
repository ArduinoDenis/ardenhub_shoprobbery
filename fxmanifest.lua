fx_version 'cerulean'
game 'gta5'

author 'ArdenHub'
description 'Sistema di rapine per negozi e banche'
version '1.0.0'
lua54 'true'

shared_scripts {
    '@es_extended/imports.lua',
    '@ox_lib/init.lua',
    'config.lua'
}

client_scripts {
    'client.lua'
}

server_scripts {
    'server.lua'
}

dependencies {
    'es_extended',
    'ox_lib'
}