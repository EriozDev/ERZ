fx_version 'cerulean'
game 'gta5'

author 'Erioz'
description 'Server Engine'
version '1.0'

shared_scripts {
    'shared/init.lua',
    'shared/config.lua',
    'shared/libs/logger.lua'
}

client_scripts {
    'client/functions.lua',
    'client/libs/ped.lua',
    'client/main.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/player.lua',
    'server/main.lua'
}