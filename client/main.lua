CreateThread(function()
    TriggerServerEvent('playerConnect')
end)

RegisterNetEvent('playerJoined', function()
    local ped = _ped.new()
    ped:spawn(vec3(-415.767029, -1458.857178, 38.378784), 90.0)
end)
