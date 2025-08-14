player = {}
PlayerList = {}

local __instance = {
    __index = player
}

function player.new(id)
    local self = {}

    self.source = id
    self.userName = GetPlayerName(self.source)
    self.states = {}

    PlayerList[self.source] = self
    setmetatable(self, __instance)
    return self;
end

function player.Get(id)
    return PlayerList[id]
end

function player.GetPlayers()
    local players = {}
    for id, playerObject in pairs(PlayerList) do
        players[id] = playerObject
    end

    return players;
end

function player:getData()
    return self;
end

function player:getUserName()
    return self.userName
end

function player:getStates()
    return self.states;
end
