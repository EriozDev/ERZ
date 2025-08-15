CreateThread(function()
    TriggerServerEvent('playerConnect')
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


RegisterNetEvent('playerJoined', function()
    local ped = _ped.new()
    ped:spawn(vec3(-415.767029, -1458.857178, 38.378784), 90.0)
end)
