shared_script '@GuardianX/resource/wrapper.lua'

fx_version 'cerulean'
game 'gta5'

author 'Erioz'
description 'Server Engine'
version '1.0'

shared_scripts {
    '@oxmysql/lib/MySQL.lua',
    'shared/init.lua',
    'shared/config.lua',
    'shared/libs/logger.lua',
    'shared/wrapper.lua',
    'shared/libs/resource.lua',
    'shared/libs/table.lua',
    'shared/functions.lua',
    'modules/crypter/synchronization.lua',
}

client_scripts {
    'client/functions.lua',
    'client/libs/ped.lua',
    'client/libs/c.lua',
    'client/main.lua',
    'modules/zoneManager/client/main.lua',
    'modules/fight/client/main.lua',
    'modules/crypter/client.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/libs/db.lua',
    'server/libs/entities.lua',
    'server/initSQL.lua',
    'server/player.lua',
    'server/main.lua',
    'modules/zoneManager/server/main.lua',
    'modules/fight/server/main.lua',
    'modules/crypter/server.lua'
}