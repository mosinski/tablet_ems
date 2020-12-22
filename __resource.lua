resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

server_scripts {
  '@mysql-async/lib/MySQL.lua',
  '@es_extended/locale.lua',
  'locates/pl.lua',
  'config.lua',
  'server/server.lua'
}

client_scripts {
  '@es_extended/locale.lua',
  'locates/pl.lua',
  'config.lua',
  'client/client.lua'
}

ui_page('client/html/UI.html')

files({
  'client/html/UI.html',
  'client/html/css/style.css',
  'client/html/css/bootstrap.min.css',
  'client/html/css/all.min.css',
  'client/html/fonts/fa-brands-400.eot',
  'client/html/fonts/fa-brands-400.svg',
  'client/html/fonts/fa-brands-400.ttf',
  'client/html/fonts/fa-brands-400.woff',
  'client/html/fonts/fa-brands-400.woff2',
  'client/html/fonts/fa-regular-400.eot',
  'client/html/fonts/fa-regular-400.svg',
  'client/html/fonts/fa-regular-400.ttf',
  'client/html/fonts/fa-regular-400.woff',
  'client/html/fonts/fa-regular-400.woff2',
  'client/html/fonts/fa-solid-900.eot',
  'client/html/fonts/fa-solid-900.svg',
  'client/html/fonts/fa-solid-900.ttf',
  'client/html/fonts/fa-solid-900.woff',
  'client/html/fonts/fa-solid-900.woff2',
  'client/html/img/tablet.png',
  'client/html/img/logo.png',
  'client/html/img/bg.jpg',
  'client/html/locales/pl.json',
  'client/html/js/nav.js',
  'client/html/js/main.js',
  'client/html/js/patients.js',
  'client/html/js/treatments.js'
})