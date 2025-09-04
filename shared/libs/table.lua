---@class Packets
local Packets = {}
Packets.__index = Packets

function Packets:new()
    local self = setmetatable({}, Packets)
    self.buffers = {}
    self.maxSize = 100
    return self
end

---@param id string | number
---@param key string | number
---@param value any
function Packets:stack(id, key, value)
    if not self.buffers[id] then
        self.buffers[id] = {}
    end

    local buf = self.buffers[id]

    if #buf >= self.maxSize then
        table.remove(buf, 1)
    end

    table.insert(buf, { key = key, value = value })
end

---@param id string | number
function Packets:unstack(id)
    if not self.buffers[id] then return nil end
    return table.remove(self.buffers[id])
end

---@param id string | number
function Packets:getKeys(id)
    local buf = self.buffers[id]
    if not buf then return {} end

    local keys = {}
    for _, entry in ipairs(buf) do
        table.insert(keys, entry.key)
    end
    return keys
end

---@param id string | number
function Packets:getValues(id)
    local buf = self.buffers[id]
    if not buf then return {} end

    local values = {}
    for _, entry in ipairs(buf) do
        table.insert(values, entry.value)
    end
    return values
end

---@param id string | number
function Packets:buildPacket(id)
    local buf = self.buffers[id]
    if not buf then return { id = id, size = 0, data = {} } end

    return {
        id = id,
        size = #buf,
        data = buf
    }
end

---@param id string | number
function Packets:clear(id)
    self.buffers[id] = {}
end

function Packets:listBuffers()
    local list = {}
    for id, _ in pairs(self.buffers) do
        table.insert(list, id)
    end
    return list
end

function Packets:setMaxSize(size)
    self.maxSize = size
end

ERZ.lib['Packets'] = Packets;
