local Resource = {};
local ResourceList = {};

local Logger = ERZ.lib['Logger']

local __instance = {
    __index = Resource;
};

function Resource.New(name, author, version, description)
    local self = {}

    self.name = name
    self.author = author
    self.version = version
    self.description = description
    self.state = 'stop'
    self.tb = {}

    setmetatable(self, __instance)
    return self;
end

function Resource.Me(name)
    local r = Resource.New(name, 'author', 1.0, 'description')

    if (r == nil) then
        return false;
    end

    ResourceList[name] = r

    return r;
end
Me = Resource.Me

function Resource:start()
    if self.state ~= 'start' then
        self.state = 'start'

        CreateThread(function()
            Logger:debug('Module ' .. self.name .. ' has been started!')

            while self.state == 'start' do
                Wait(0)
            end

            Logger:debug('Module ' .. self.name .. ' has been stopped!')
        end)
    end
end

function Resource:set(k, v)
    self.tb[k] = v
end

function Resource:stop()
    if self.state == 'start' then
        self.state = 'stop'
    end
end

function Resource.Get(resourceName)
    if (resourceName == nil) then
        return false;
    end

    local r = ResourceList[resourceName]
    if (not r) then
        return false;
    end

    return r;
end

function Resource.GetResourceList()
    local pResource = {}

    for _, meta in pairs(ResourceList) do
        table.insert(pResource, meta)
    end

    return pResource
end

function Resource:getMetaData()
    return self;
end

function Resource:setMeta(meta, n)
    if self[meta] ~= nil then
        self[meta] = n
    end
end

function Resource:getResourceName()
    return self.name;
end

function Resource:getConfig()
    return self.tb['CFG']
end

function Resource:Config(cfg)
    if (not cfg) then
        return self:getConfig()
    end

    self:set('CFG', cfg)
end

ERZ.lib['resource'] = Resource;

return Resource;
