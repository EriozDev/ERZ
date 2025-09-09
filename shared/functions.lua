local IS_SERVER = IsDuplicityVersion();
local RegisterNetEvent = RegisterNetEvent;
local CR = Citizen.CreateThread;
local Wait = Wait;
local Ad = AddEventHandler;

local Logger = ERZ.lib['Logger']

function ERZ.On(eventName, fc)
    return Ad(eventName, fc)
end

function ERZ.EventFormatter(eventName)
    return string.format('erz:%s', eventName)
end

function ERZ.Thread(fn)
    CR(fn)
end

function ERZ.OnStart(fn)
    ERZ.Thread(fn)
end

function ERZ.onTick(tickRate, tickFunction)
    if (not IS_SERVER) then
        if tickRate < 1000 then
            Logger:warn('MS loops WARNING - rate: ', tickRate)
        end
    end

    local function StartTickFn(fn)
        fn()
    end

    ERZ.Thread(function()
        while true do
            StartTickFn(tickFunction)
            Wait(tickRate)
        end
    end)
end

function ERZ.Wait(t)
    if type(t) == 'table' then
        for i = 1, #t do
            if #t > 0 and i ~= -1 then
                return print('Error ERZ.Wait expected time ; got table - value')
            end
        end
    end

    return Wait(t);
end

function ERZ.OnNet(eventName, fc)
    if eventName == nil or type(eventName) ~= 'string' then
        return false;
    end

    if (IS_SERVER) then
        Logger:debug('Event OnNet', eventName)
    end

    RegisterNetEvent(ERZ.EventFormatter(eventName), fc)
end

if (IS_SERVER) then
    local TriggerClientEvent = TriggerClientEvent;

    function ERZ.toClient(eventName, target, ...)
        if (eventName) == nil then
            return false;
        end

        local formatedEvent = ERZ.EventFormatter(eventName)
        Logger:debug("toClient [S->C]", eventName, target)
        TriggerClientEvent(formatedEvent, target, ...)
    end
else
    local TriggerServerEvent = TriggerServerEvent;

    function ERZ.toServer(eventName, ...)
        if (eventName) == nil then
            return false;
        end

        local formatedEvent = ERZ.EventFormatter(eventName)
        Logger:debug("toServer [C->S]", eventName)
        TriggerServerEvent(formatedEvent, target, ...)
    end
end
