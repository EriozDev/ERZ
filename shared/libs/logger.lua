Logger = {}

function Logger:new(...)
    return print('[¨1ERZ^0] ', ...)
end

function Logger:warn(...)
    return print('[^3Warn^0]', ...)
end

function Logger:info(...)
    return print('[^5Info^0]', ...)
end

function Logger:debug(...)
    return print('[^6Debug^0] ', ...)
end
