local _ped = {}

local __instance = {
    __index = _ped
}

local p_Index = {}

function _ped.new()
    local self = {}
    local playerId = PlayerId()
    local serverId = GetPlayerServerId(playerId)

    if p_Index[serverId] then
        return p_Index[serverId]
    end

    self.__var = {}
    self.playerId = playerId
    self.serverId = serverId
    self.name = GetPlayerName(playerId)
    self.ped = nil
    self.ch = 0
    self.IsFreeze = false

    setmetatable(self, __instance)
    p_Index[serverId] = self
    return self
end

function _ped:update()
    self.ped = PlayerPedId()
end

function _ped:getChakra()
    return self.ch
end

function _ped:setChakra(v)
    if type(v) ~= 'number' then
        return false
    end
    self.ch = v
end

function _ped.GetLocal()
    local serverId = GetPlayerServerId(PlayerId())
    local self = p_Index[serverId] or _ped.new()
    self:update()
    return self
end

function _ped:setCoords(x, y, z)
    SetEntityCoords(self.ped, x, y, z, false, false, false, true)
    return true
end

function _ped:getServerId()
    return self.serverId
end

function _ped:addVar(k, v)
    if self.__var[k] then return false end
    self.__var[k] = v
    return true
end

function _ped:removeVar(k)
    if not self.__var[k] then return false end
    self.__var[k] = nil
    return true
end

function _ped:set(k, v)
    self.__var[k] = v
end

function _ped:get(k)
    return self.__var[k]
end

function _ped:spawn(coords, heading)
    Wait(0)
    ShutdownLoadingScreen()
    ResetPausedRenderphases()
    ShutdownLoadingScreenNui()

    local model = "mp_m_freemode_01"
    RequestModel(model)
    while not HasModelLoaded(model) do Wait(0) end

    SetPlayerModel(PlayerId(), model)
    Wait(100)
    local ped = PlayerPedId()
    self.ped = ped
    SetPedComponentVariation(ped, 1, 0, 0, 2)

    while not HasPedHeadBlendFinished(PlayerPedId()) or not DoesEntityExist(PlayerPedId()) do
        Wait(0)
    end

    NetworkResurrectLocalPlayer(coords.x, coords.y, coords.z, heading or 0.0, true, false)

    ClearPedTasksImmediately(ped)
    FreezeEntityPosition(ped, false)
    SetPlayerInvincible(PlayerId(), false)

    SetEntityCoordsNoOffset(ped, coords.x, coords.y, coords.z, false, false, false)
    SetEntityHeading(ped, heading or 0.0)

    local resourceLib = ERZ.lib['resource']
    local Resources = resourceLib.GetResourceList()
    for i = 1, #Resources do
        Resources[i]:start()
    end
end

function _ped:setClothes(componentId, drawableId, textureId, paletteId)
    if not self.ped or not DoesEntityExist(self.ped) then
        return false
    end
    SetPedComponentVariation(self.ped, componentId, drawableId, textureId, paletteId or 0)
    return true
end

function _ped:getClothes(componentId)
    if not self.ped or not DoesEntityExist(self.ped) then
        return nil
    end
    local drawable = GetPedDrawableVariation(self.ped, componentId)
    local texture = GetPedTextureVariation(self.ped, componentId)
    local palette = GetPedPaletteVariation(self.ped, componentId)
    return {drawable = drawable, texture = texture, palette = palette}
end

function _ped:saveOutfit()
    if not self.ped or not DoesEntityExist(self.ped) then
        return false
    end
    local outfit = {}
    for i = 0, 11 do
        outfit[i] = self:getClothes(i)
    end
    self.__var["outfit"] = outfit
    return outfit
end

function _ped:loadOutfit(outfit)
    outfit = outfit or self.__var["outfit"]
    if not outfit then return false end
    for compId, data in pairs(outfit) do
        if data then
            self:setClothes(compId, data.drawable, data.texture, data.palette)
        end
    end
    return true
end

function _ped:applyOutfit(outfit)
    if not outfit then return false end
    for compId, data in pairs(outfit) do
        if data then
            self:setClothes(compId, data.drawable or 0, data.texture or 0, data.palette or 0)
        end
    end
    return true
end

function _ped:setFreezeState(v)
    if type(v) ~= 'boolean' then
        return false;
    end
    self.IsFreeze = v
    FreezeEntityPosition(self.ped, self.IsFreeze)
end

function _ped:setVisible(state, selfVisible)
    if not self.ped or not DoesEntityExist(self.ped) then
        return false
    end

    if state then
        SetEntityVisible(self.ped, true, false)
        SetLocalPlayerVisibleLocally(self.ped, true)
    else
        SetEntityVisible(self.ped, false, false)

        if selfVisible then
            SetLocalPlayerVisibleLocally(self.ped, true)
        else
            SetLocalPlayerVisibleLocally(self.ped, false)
        end
    end

    return true
end


ERZ.lib['_ped'] = _ped
