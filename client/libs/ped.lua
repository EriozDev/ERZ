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

    setmetatable(self, __instance)
    p_Index[serverId] = self
    return self
end

function _ped:update()
    self.ped = PlayerPedId()
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
    SetEntityVisible(ped, false)
    SetPlayerInvincible(PlayerId(), false)

    SetEntityCoordsNoOffset(ped, coords.x, coords.y, coords.z, false, false, false)
    SetEntityHeading(ped, heading or 0.0)

    local resourceLib = ERZ.lib['resource']
    local Resources = resourceLib.GetResourceList()
    for i = 1, #Resources do
        Resources[i]:start()
    end
end

ERZ.lib['_ped'] = _ped
