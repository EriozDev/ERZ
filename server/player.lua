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
    self.group = 'user'
    self.character = {
        job = 'unemployed',
        jobGrade = 0,
        job2 = 'unemployed2',
        jobGrade2 = 0
    }

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

function player:getGroup()
    return self.group
end

function player:setGroup(NewGroup)
    if self.group == NewGroup then return false end
    self.group = NewGroup
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

ERZ.G['player'] = player;
local l = ERZ.G['player'];
return l;
