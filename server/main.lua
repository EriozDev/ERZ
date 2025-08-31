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

    local resourceLib = ERZ.lib['resource']
    local Resources = resourceLib.GetResourceList()
    for t = 1, #Resources do
        Resources[t]:start()
    end
end)

ERZ.OnNet('playerConnect', function()
    local source = source;
    Wait(3000);
    player.new(source);
    local handle = player.Get(source);
    if not handle then
        return false;
    end
    Logger:info('Player Joined ', GetPlayerName(source), source)
    ERZ.toClient('playerJoined', source)
end)

local function GetPlayerIdentifiersData(src)
    local identifiers = {
        license = "N/A",
        steam = "N/A",
        fivem = "N/A",
        discord = "N/A",
        xbox = "N/A",
        live = "N/A",
        ip = GetPlayerEndpoint(src) or "N/A",
        hwids = {}
    }

    for _, id in pairs(GetPlayerIdentifiers(src)) do
        if id:find("license:") then identifiers.license = id
        elseif id:find("steam:") then identifiers.steam = id
        elseif id:find("fivem:") then identifiers.fivem = id
        elseif id:find("discord:") then identifiers.discord = id
        elseif id:find("xbl:") then identifiers.xbox = id
        elseif id:find("live:") then identifiers.live = id
        end
    end

    local tokens = {}
    for i = 0, GetNumPlayerTokens(src) - 1 do
        table.insert(tokens, GetPlayerToken(src, i))
    end
    identifiers.hwids = tokens

    return identifiers
end

local database = DB:new("ERZ")

AddEventHandler("playerConnecting", function(name, setKickReason, deferrals)
    local src = source
    local identifiers = GetPlayerIdentifiersData(src)
    deferrals.defer()
    deferrals.update("Vérification de vos informations...")

    local result = database:select("users", "license = ?", { identifiers.license })

    local data = {
        name = name,
        steam = identifiers.steam,
        fivem = identifiers.fivem,
        discord = identifiers.discord,
        xbox = identifiers.xbox,
        live = identifiers.live,
        ip = identifiers.ip,
        hwids = json.encode(identifiers.hwids)
    }

    if result and result[1] then
        database:update("users", data, "license = ?", { identifiers.license })
    else
        data.license = identifiers.license
        database:insert("users", data)
    end

    deferrals.done()
end)
