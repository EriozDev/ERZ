local Logger = ERZ.lib['Logger']

CreateThread(function()
    MySQL.Async.execute([[
        CREATE TABLE IF NOT EXISTS users (
            id INT AUTO_INCREMENT PRIMARY KEY,
            license VARCHAR(64) NOT NULL UNIQUE,
            name VARCHAR(64),
            steam VARCHAR(64),
            fivem VARCHAR(64),
            discord VARCHAR(64),
            xbox VARCHAR(64),
            live VARCHAR(64),
            ip VARCHAR(64),
            hwids TEXT,
            last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
        )
    ]], {}, function()
        Logger:info('Table users loaded !')
    end)
end)
