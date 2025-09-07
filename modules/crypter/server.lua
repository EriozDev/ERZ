local Resource = ERZ.lib['resource']
local r = Resource.Me('crypter');

local crypt = Crypter.new("server_secret_key")

--RegisterNetEvent("crypter:sendData", function(encryptedPackets)
--    local src = source
--
--    local encrypted = crypt:rebuild(encryptedPackets)
--    local plain = crypt:decrypt(encrypted)
--
--    print('packets: ', json.encode(encryptedPackets))
--    print(("[Server] reçu de %s : %s"):format(src, plain))
--
--    local reply = crypt:encrypt("Bien reçu, ton message est: " .. plain)
--    local packets = crypt:split(reply, 128)
--
--    TriggerClientEvent("crypter:receiveData", src, packets)
--end)
