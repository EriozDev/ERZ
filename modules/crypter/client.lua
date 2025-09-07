local Resource = ERZ.lib['resource']
local r = Resource.Me('crypter');

local crypt = Crypter.new("ma_cle")

--RegisterCommand("cryptbin", function(_, args)
--    local msg = table.concat(args, " ")
--    if msg == "" then msg = "Hello World" end
--
--    local packets = crypt:splitToBinary(msg)
--    print("Packets binaires:", json.encode(packets))
--
--    local plain = crypt:rebuildFromBinary(packets)
--    print("Déchiffré:", plain)
--end)
