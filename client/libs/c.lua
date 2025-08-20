local Client = {}

local Logger = ERZ.lib['Logger']

local __instance = {
    __index = Client;
}

function Client.Init()
    local self = {}

    self.sessionToken = math.random(1, 999);
    self.iks = {};
    self.state = 'active'

    setmetatable(self, __instance)
    return self;
end

function Client:getState()
    return self.state
end

function Client:sync()
    Logger:debug('Client has been Loaded!')
end

ERZ.lib['Client'] = Client;
