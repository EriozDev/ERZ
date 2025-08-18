local ERZ_STARTED = false
local Logger = ERZ.lib['Logger']

CreateThread(function()
    local attempt = 0

    while not ERZ_STARTED do
        Wait(1000)
        attempt = attempt + 1
        Logger:warn('ERZ FrameWork Starting... Don\'t stop the server !')
        if attempt > 3 then
            ERZ_STARTED = true
            goto update
        end
    end

    ::update::
    Logger:info('ERZ FrameWork Started!')
    local libs = GetLibs()
    for i = 1, #libs do
        Logger:debug('Lib ', libs[i], ' Loaded')
    end

    local globals = GetGlobals()
    for j = 1, #globals do
        Logger:debug('Global ', globals[j], ' Loaded')
    end
end)

RegisterNetEvent('playerConnect', function()
    local source = source;
    player.new(source);
    local handle = player.Get(source);
    if not handle then
        return false;
    end
    Logger:info('Player Joined ', GetPlayerName(src), src)
    TriggerClientEvent('playerJoined', src)
end)
