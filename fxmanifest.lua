shared_script '@GuardianX/resource/wrapper.lua'

fx_version 'cerulean'
game 'gta5'

author 'Erioz'
description 'Server Engine'
version '1.0'

shared_scripts {
    'shared/init.lua',
    'shared/config.lua',
    'shared/libs/logger.lua',
    'shared/libs/resource.lua',
    'shared/functions.lua'
}

client_scripts {
    'client/functions.lua',
    'client/libs/ped.lua',
    'client/libs/c.lua',
    'client/main.lua',
    'modules/fight/client/main.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/initSQL.lua',
    'server/player.lua',
    'server/main.lua',
    'modules/fight/server/main.lua'
}