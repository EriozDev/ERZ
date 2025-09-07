Entities = {}
Entities.__index = Entities
Entities.list = {}

local Logger = ERZ.lib['Logger']

function Entities.New(entity, firstOwner)
    local self = setmetatable({}, Entities)

    self.handle = entity
    self.netId = NetworkGetNetworkIdFromEntity(entity)
    self.model = GetEntityModel(entity)
    self.firstOwner = firstOwner
    self.pos = GetEntityCoords(entity)
    self.createdAt = os.time()

    Entities.list[self.netId] = self
    return self
end

function Entities:exists()
    return DoesEntityExist(self.handle)
end

function Entities:delete()
    if self:exists() then
        DeleteEntity(self.handle)
        Entities.list[self.netId] = nil
        Logger:debug(("Entity %s supprimée (model %s)"):format(self.netId, self.model))
    end
end

function Entities.GetByNetId(netId)
    return Entities.list[netId]
end

function Entities.GetAll()
    return Entities.list
end

local function PendingEntityProcess(handle, firstOwner)
    if not handle then return false end

    local attempt = 0
    local player = false
    while (attempt < 5) do
        if (DoesEntityExist(handle)) then
            local IS_CREATED_BY_SERVER = GetEntityScript(handle)

            if (IS_CREATED_BY_SERVER) then
                player = true
                break
            end

            attempt = attempt + 1
        end
        Wait(10)
    end

    if not player then
        return false;
    end

    local currentOwner = NetworkGetEntityOwner(handle)
    local scriptName   = GetEntityScript(handle)

    print(("FirstOwner: %s | CurrentOwner: %s | Script: %s")
        :format(firstOwner, currentOwner, tostring(scriptName)))

    if firstOwner ~= currentOwner then
        return false
    end

    return true
end

AddEventHandler("entityCreating", function(entity)
    local firstOwner = NetworkGetFirstEntityOwner(entity)
    local obj = Entities.New(entity, firstOwner)

    local pending = PendingEntityProcess(entity, firstOwner)
    if (not pending) then
        Logger:debug(("Spawn entity refusé: entité %s (owner invalide)"):format(obj.netId))
        CancelEvent()
        return
    end

    Logger:debug(("Entité créée netId=%s | model=%s | owner=%s | createdAt=%s")
        :format(obj.netId, obj.model, GetPlayerName(firstOwner), obj.createdAt))
end)
