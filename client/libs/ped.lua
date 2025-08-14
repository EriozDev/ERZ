_ped = {}

local __instance = {
    __index = _ped
}

function _ped.new()
    local self = {}
    self.__var = {}
    self.playerid = PlayerId()
    self.name = GetPlayerName(GetPlayerServerId(PlayerId()))

    setmetatable(self, __instance)
    return self;
end

function _ped:addVar(k, v)
    if self.__var[k] then
        return false
    end

    self.__var[k] = v
end

function _ped:removeVar(k)
    if not self.__var[k] then
        return false
    end

    self.__var[k] = nil
end

function _ped:set(k, v)
    self.__var[k] = v
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
    SetPedComponentVariation(ped, 1, 0, 0, 2)

    while not HasPedHeadBlendFinished(PlayerPedId()) or not DoesEntityExist(PlayerPedId()) do
        Wait(0)
    end

    NetworkResurrectLocalPlayer(coords.x, coords.y, coords.z, heading or 0.0, true, false)

    ClearPedTasksImmediately(ped)
    SetEntityVisible(ped, true)
    FreezeEntityPosition(ped, false)
    SetPlayerInvincible(PlayerId(), false)

    SetEntityCoordsNoOffset(ped, coords.x, coords.y, coords.z, false, false, false)
    SetEntityHeading(ped, heading or 0.0)
end
