
-- [ Metadata de la ressource ]
fx_version 'cerulean'							-- supported  functionality for the resource
games { 'gta5' } 								-- supported game API
lua54 'yes'										-- Enables Lua 5.4
author 'Vidock <https://github.com/Vidock-pro>'
description 'gtk_ZoneInterdite'
version '0.2.0'

-- [ Liste des scripts à éxécuter ]
-- [ Liste des scripts à éxécuter côté client ]
client_scripts {
	'@PolyZone/client.lua',
	'@PolyZone/BoxZone.lua',
	'@PolyZone/EntityZone.lua',
	'@PolyZone/CircleZone.lua',
	'@PolyZone/ComboZone.lua',
	'config.lua',
	'client/*.lua'
}
-- [ Liste des scripts à éxécuter côté serveur ]
server_scripts {
	'@oxmysql/lib/MySQL.lua',
	'server/*.lua'
}
-- [ Liste des scripts Partagé à éxécuter]
shared_script '@es_extended/imports.lua'

-- [ Liste des ressources dépendante]
dependencies {
	'es_extended',
	'oxmysql',
	'PolyZone'
}

