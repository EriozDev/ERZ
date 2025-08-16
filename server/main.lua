local ERZ_STARTED = false

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
end)

RegisterNetEvent('playerConnect', function()
    local src = source
    if not src then return end
    Wait(3000)
    player.new(src)
    local handle = player.Get(src)
    if not handle then return end
    Logger:info('Player Joined ', GetPlayerName(src), src)
    TriggerClientEvent('playerJoined', src)
end)
