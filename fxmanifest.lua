fx_version "cerulean"
game "gta5"

title "Garage Script - FivemDK"
author "Lindholm"

lua54 'yes'

client_scripts {
    'client.lua',
    'config.lua'
}

server_scripts {
    'server.lua',
    '@mysql-async/lib/MySQL.lua',
}

shared_scripts {
    '@ox_lib/init.lua',
    '@es_extended/imports.lua'
}

files {
	"ui/dist/**/*"
}

-- ui_page "http://localhost:3000"
ui_page "./ui/dist/index.html"