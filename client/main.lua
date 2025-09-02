CreateThread(function()
    ERZ.toServer('playerConnect')
end)

CreateThread(function()
    while true do
        NetworkSetFriendlyFireOption(true)
        SetCanAttackFriendly(PlayerPedId(), true, true)
        Wait(1000)
    end
end)

if Config.DEVMOD then
    RegisterCommand("crun", function(source, args, rawCommand)
        local code = table.concat(args, " ")

        if code == nil or code == "" then
            print("^1Erreur:^7 Aucun code fourni.")
            return
        end

        local func, err = load(code)
        if not func then
            return
        end

        local success, result = pcall(func)
        if not success then
        else
        end
    end, false)
end

ERZ.OnNet('playerJoined', function()
    local _ped = ERZ.lib['_ped']
    local _client = ERZ.lib['Client']
    local ped = _ped.new()
    local client = _client.Init()
    ped:spawn(vec3(-415.767029, -1458.857178, 38.378784), 90.0)
    client:sync()
end)

ERZ.OnNet('localPed:setChakra', function(v)
    v = tonumber(v)
    local _ped = ERZ.lib['_ped']
    local ped = _ped.new()
    ped:setChakra(v)
end)
