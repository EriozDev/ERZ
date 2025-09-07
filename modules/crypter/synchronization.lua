local function byteToBits(byte)
    local bits = {}
    for i = 7, 0, -1 do
        bits[#bits+1] = tostring(math.floor(byte / (2^i)) % 2)
    end
    return table.concat(bits)
end

local function bitsToByte(bits)
    local byte = 0
    for i = 1, 8 do
        byte = byte + tonumber(bits:sub(i,i)) * 2^(8-i)
    end
    return string.char(byte)
end

local function bxor(a, b)
    local res = 0
    local bitval = 1
    for i = 0, 7 do
        local abit = a % 2
        local bbit = b % 2
        if abit ~= bbit then
            res = res + bitval
        end
        a = math.floor(a / 2)
        b = math.floor(b / 2)
        bitval = bitval * 2
    end
    return res
end

local function xor(str, key)
    local res = {}
    local keyLen = #key
    for i = 1, #str do
        local c = string.byte(str, i)
        local k = string.byte(key, (i - 1) % keyLen + 1)
        res[#res+1] = string.char(bxor(c, k))
    end
    return table.concat(res)
end

Crypter = {}
Crypter.__index = Crypter

function Crypter.new(key)
    local self = setmetatable({}, Crypter)
    self.key = key or "default_secret"
    return self
end

function Crypter:encrypt(msg)
    return xor(msg, self.key)
end

function Crypter:decrypt(msg)
    return xor(msg, self.key)
end

function Crypter:splitToBinary(msg, packetSize)
    packetSize = packetSize or 8
    local encrypted = self:encrypt(msg)
    local packets = {}
    for i = 1, #encrypted do
        local byte = string.byte(encrypted, i)
        local bits = byteToBits(byte)
        packets[#packets+1] = bits
    end
    return packets
end

function Crypter:rebuildFromBinary(packets)
    local chars = {}
    for _, bits in ipairs(packets) do
        chars[#chars+1] = bitsToByte(bits)
    end
    local encrypted = table.concat(chars)
    return self:decrypt(encrypted)
end

function Crypter:split(data, size)
    local chunks, i = {}, 1
    while i <= #data do
        chunks[#chunks+1] = data:sub(i, i+size-1)
        i = i + size
    end
    return chunks
end

function Crypter:rebuild(chunks)
    return table.concat(chunks)
end

