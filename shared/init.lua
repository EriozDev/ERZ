ERZ = {}
ERZ.lib = {}

ERZ.G = {}

function GetLibs()
    local __var = {}
    for name in pairs(ERZ.lib) do
        table.insert(__var, name)
    end

    return __var
end

function GetGlobals()
    local __is = {}

    for name in pairs(ERZ.G) do
        table.insert(__is, name)
    end

    return __is
end
