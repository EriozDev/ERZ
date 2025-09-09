local IS_SERVER = IsDuplicityVersion()
local Logger = ERZ.lib['Logger']

local ProtectedEvents = {}

local function generateToken(length)
    local chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789'
    local token = ''
    math.randomseed(os.time() + math.random(1000))
    for i = 1, (length or 10) do
        local randIndex = math.random(1, #chars)
        token = token .. chars:sub(randIndex, randIndex)
    end
    return token
end

local wlEvent = {
    ["gameEventTriggered"] = true,
    ["onClientResourceStart"] = true,
    ["onClientResourceStop"] = true,
    ["onResourceStart"] = true,
    ["onResourceStarting"] = true,
    ["onResourceStop"] = true,
    ["playerConnecting"] = true,
    ["playerDropped"] = true,
    ["populationPedCreating"] = true,
    ["rconCommand"] = true,
    ["entityCreated"] = true,
    ["entityCreating"] = true,
    ["entityRemoved"] = true,
    ["onResourceListRefresh"] = true,
    ["onServerResourceStart"] = true,
    ["onServerResourceStop"] = true,
    ["playerEnteredScope"] = true,
    ["playerJoining"] = true,
    ["onPlayerJoining"] = true,
    ["playerLeftScope"] = true,
    ["ptFxEvent"] = true,
    ["removeAllWeaponsEvent"] = true,
    ["startProjectileEvent"] = true,
    ["weaponDamageEvent"] = true,
    ["CEventName"] = true,
    ["entityDamaged"] = true,
    ["mumbleConnected"] = true,
    ["mumbleDisconnected"] = true,
    ["__cfx_nui:exit"] = true,
    ["__cfx_internal:commandFallback"] = true,
    ["giveWeaponEvent"] = true,
    ["RemoveWeaponEvent"] = true,
    ["explosionEvent"] = true,
    ["onPlayerDropped"] = true,
    ["fireEvent"] = true,
    ["vehicleComponentControlEvent"] = true
}

if IS_SERVER then
    local _RegisterNetEvent = RegisterNetEvent
    local _AddEventHandler = AddEventHandler

    RegisterNetEvent = function(eventName, eventFn)
        if wlEvent[eventName] or eventName:find('__cfx') then
            return _RegisterNetEvent(eventName, eventFn)
        end

        if not ProtectedEvents[eventName] then
            local crypted = string.format('ERZ:%s', GetHashKey(eventName))
            local eventToken = generateToken()
            ProtectedEvents[eventName] = { cryptedName = crypted, token = eventToken }
            Logger:debug('Event secure: ', eventName, 'Token: ', eventToken, ' Crypted: ', crypted)
            return _RegisterNetEvent(crypted, eventFn)
        end

        Logger:debug('Event already secure: ', eventName)
    end

    AddEventHandler = function(eventName, eventFn)
        if ProtectedEvents[eventName] then
            local crypted = ProtectedEvents[eventName].cryptedName
            return _AddEventHandler(crypted, eventFn)
        end
        return _AddEventHandler(eventName, eventFn)
    end

    function GetEventToken(eventName)
        if ProtectedEvents[eventName] then
            return ProtectedEvents[eventName].token
        end
        return nil
    end

    CreateThread(function()
        while true do
            Wait(4000)

            TriggerClientEvent('syncEvents', -1, ProtectedEvents)
        end
    end)

else
    local serverProtectedEvents = {}
    local _TriggerServerEvent = TriggerServerEvent

    TriggerServerEvent = function(eventName, ...)
        local tokenEntry = serverProtectedEvents[eventName]
        if tokenEntry then
            local cryptedName = tokenEntry.cryptedName
            local token = tokenEntry.token
            Logger:debug('Anti Trigger - TS', eventName, cryptedName, ...)
            return _TriggerServerEvent(cryptedName, token, ...)
        else
            return _TriggerServerEvent(eventName, ...)
        end
    end

    RegisterNetEvent('syncEvents')
    AddEventHandler('syncEvents', function(t)
        serverProtectedEvents = t
    end)

end
