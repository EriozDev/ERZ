local Logger = {}

function Logger:new(...)
    return print('[¨1ERZ^0] ', ...)
end

function Logger:warn(...)
    return print('[^3WARN^0]', ...)
end

function Logger:info(...)
    return print('[^5INFO^0]', ...)
end

function Logger:debug(...)
    if Config.DEVMOD then
        return print('[^6DEBUG^0] ', ...)
    end
end

ERZ.lib['Logger'] = Logger;
