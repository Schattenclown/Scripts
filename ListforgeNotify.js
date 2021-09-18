registerPlugin({
    name: 'Serverinfo Fetcher from https://listforge.net/',
    version: '4.2.0',
    description: 'This example actually does something',
    author: 'Schattenclown',
    backends: ['ts3'],
    requiredModules: ['http'],
    vars: [
        {    
            name: 'servers',
            title: 'Servers',
            type: 'array',
            vars: [
                    {
                        name: 'Servername',
                        title: 'Servername',
                        type: 'string',
                        placeholder: '',
                    },
                    {
                        name: 'Serverpasswort',
                        title: 'Serverpasswort',
                        type: 'string',
                        placeholder: '',
                    },
                    {
                        name: 'APIurl',
                        title: 'API Url',
                        type: 'string',
                        placeholder: '',
                    },
                    {
                        name: 'Channel',
                        title: 'Channel',
                        type: 'channel',
                        indent: 3,
                    },
                    {
                        name: 'Game',
                        title: 'Game',
                        type: 'select',
                        options:['None', 'ARK: Survival Server ist Online', 'Conan Exiles', 'Minecraft', 'The Forest'],
                    }
                ]
            },
            {
                name: 'AllChannel',
                title: 'All infos in one Channel',
                type: 'channel',
                indent: 3,
            },
            {
                name: 'mcwhitelist',
                title: 'Minecraft Whitelist ON/OFF',
                type: 'checkbox',
            },
            {
                name: 'Showlog',
                title: 'Show/hide Log',
                type: 'checkbox',
            },
            {
                name: 'interval',
                title: 'Refresh interval (in seconds)',
                type: 'number',
                placeholder: '300',
                default: 300
            },
            {
                name: 'Serveranz',
                title: 'Eingetragene Serveranzahl',
                type: 'number',
                placeholder: '1',
                default: 1
            }
    ]
}, 

function(_, config, meta)
{
    // import modules
    var engine = require('engine')
    var http = require('http')
    var backend = require('backend')
    var zae = 1;  

    let servers = config.servers
    if (!servers || servers.length == 0) 
    {
        engine.log('No servers configured.')
        return
    }

    refresh()
    setInterval(refresh, (config.interval || 60) * 1000)

    function refresh()
    {
        var speichern = ''
        var channel1 = backend.getChannelByID(config.AllChannel);
        
        for (let server of servers)
        {
            fetchdata(server, data => 
            {
                //select channel for desc change
                var channel = backend.getChannelByID(server.Channel);
                
                //changes is_online to readable
                var onof = "Offline"
                if(data.is_online == 1)
                {
                    onof = 'Online '
                }
                //MC  Whitelist
                var whitelistonof = 'aus'
                if(config.mcwhitelist == true)
                {
                    whitelistonof = 'an'
                }
                
                //set channeldesc
                if(server.Game == 3)
                {
                    channel.setName(onof + ' ' + data.players + '/' + data.maxplayers + ' | ' + server.Servername)
                    channel.setDescription('[url=' + data.url + '][img]https://minecraft-mp.com/regular-banner-' + data.id + '-4.png[/img][/url]' + '\nSpiel: ' + server.Servername + '\nName: ' + data.name + '\nIP: ' + data.address + ':' + data.port + '\nWhitelist: ' + whitelistonof + '\nStatus: ' + '[color=Green]'+ onof + '[/color]' + '\nSpieler: ' + data.players + '/' + data.maxplayers + '\nMap: ' + data.map + '\nHyperlink: [URL=' + data.url + '][color=Green]Status-check[/color][/URL]' + '\nUptime: ' + data.uptime + '%')           
                    speichern = speichern.concat(`[url=${data.url}][img]https://minecraft-mp.com/regular-banner-${data.id}-4.png[/img][/url]\nSpiel: ${server.Servername}\nName: ${data.name}\nIP: ${data.address}:${data.port}\nWhitelist: ${whitelistonof}\nStatus: [color=Green]${onof}[/color]\nSpieler: ${data.players}/${data.maxplayers}\nVersion:${data.version}\nHyperlink: [URL=${data.url}][color=Green]Status-check[/color][/URL]\nUptime: ${data.uptime}%\n`)
                }
                else
                {
                    channel.setName(onof + ' ' + data.players + '/' + data.maxplayers + ' | ' + server.Servername)
                    channel.setDescription('[url=' + data.url + '][img]' + data.url + '/banners/regular-banner-1.png[/img][/url]' + '\nSpiel: ' + server.Servername + '\nName: ' + data.hostname + '\nIP: ' + data.address + ':' + data.query_port + '\n[b][URL=steam://connect/' + data.address + ':' + data.query_port + '/' + server.Serverpasswort + '][color=royalblue]Instant connection[/color][/URL][/b]' + '\nStatus: ' + '[color=Green]'+ onof + '[/color]' + '\nSpieler: ' + data.players + '/' + data.maxplayers + '\nMap: ' + data.map + '\nHyperlink: [URL=' + data.url + '][color=Green]Status-check[/color][/URL]' + '\nUptime: ' + data.uptime + '%')
                    speichern = speichern.concat(`[url=${data.url}][img]${data.url}/banners/regular-banner-1.png[/img][/url]\nSpiel: ${server.Servername}\nName: ${data.hostname}\nIP: ${data.address}:${data.query_port}\nPasswort: ${server.Serverpasswort}\n[b][URL=steam://connect/${data.address}:${data.query_port}/${server.Serverpasswort}][color=royalblue]Instant connection[/color][/URL][/b]\nStatus: [color=Green]${onof}[/color]\nSpieler: ${data.players}/${data.maxplayers}\nMap: ${data.map}\nHyperlink: [URL=${data.url}][color=Green]Status-check[/color][/URL]\nUptime: ${data.uptime}%\n`)
                }
                
                if(zae == config.Serveranz)
                {
                    channel1.setDescription(speichern)
                }

                //show log
                if(config.Showlog == true)
                {
                    console.log(speichern)
                }
                zae++
            })
        }
        zae = 1
    }

    function fetchdata(server, callback)
    {
        http.simpleRequest(
        {
            method:     'POST',
            url:        server.APIurl,
            timeout:    6000,
            headers:
            {
                'Content-Type': 'application/json'
            }
        }, (error, response) =>
        {
            // check whether request was successfull
            if (error || response.statusCode != 200)
            {
                engine.log(`[Error] API request failed: ${(error || 'HTTP '+response.statusCode)}`)
                return
            }

            var data
            try
            {
                data = JSON.parse(response.data.toString())
            } catch (err)
            {
                engine.log(`[Error] Unable to parse data: ${err}`)
                engine.log(`Response: ${response.data}`)
            }

            // check whether response is valid
            if (!data)
            {
                return
            } else if (data.stat == 'fail')
            {
                engine.log(`[Error] API Request failed: ${JSON.stringify(data.error)}`)
                return
            }
            
            if(config.Showlog == true)
            {
                engine.log(`Data: ${response.data}`)
            }
            
            callback(data)
        })
    }
})