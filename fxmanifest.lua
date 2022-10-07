name "Don-Jewelery"
author "DonHulieo"
version "v0.0.9"
description "Don\'s reworked jewelery heist for QBCore"

fx_version 'cerulean'
game 'gta5'

shared_scripts {
    '@qb-core/shared/locale.lua',
    'locale/en.lua', -- replace with desired language
    'config.lua'
}

client_script {
	'@PolyZone/client.lua',
    '@PolyZone/BoxZone.lua',
    '@PolyZone/EntityZone.lua',
    '@PolyZone/CircleZone.lua',
    '@PolyZone/ComboZone.lua',
    'client/main.lua',
    'client/doors.lua'
}
server_script {
    '@oxmysql/lib/MySQL.lua',
    'server/main.lua',
    'server/doors.lua'
}

lua54 'yes'
