RegisterNetEvent('playerConnect', function()
    local src = source
    if not src then return end
    Wait(3000)
    player.new(src)
    local handle = player.Get(src)
    if not handle then return end
    TriggerClientEvent('playerJoined', src)
end)
