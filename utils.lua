local Vector = require "vector"
local utils = {}
function utils.deltaTime()
    local currentTime = timer:time()
    local dt = (currentTime - utils.lastFrameTime) /1000 -- Convert to seconds
    utils.lastFrameTime = currentTime

    return dt
end



local fruits_magic_nums = {
    {
        size = Vector(40, 40),
        offset = Vector(-4, -4),
        radius = 17,
        points = 1
    },
    {
        size = Vector(40, 43),
        offset = Vector(-1, 0),
        radius = 21,
        points = 3
    },
    {
        size = Vector(62, 56),
        offset = Vector(0, -1),
        radius = 29,
        points = 6
    },
    {
        size = Vector(72, 69),
        offset = Vector(2, 0),
        radius = 35,
        points = 10
    },
    {
        size = Vector(88, 96),
        offset = Vector(0, -3),
        radius = 45,
        points = 15
    },
    {
        size = Vector(112, 112),
        offset = Vector(0, 0),
        radius = 56,
        points = 21
    },
    {
        size = Vector(130, 130),
        offset = Vector(0, 0),
        radius = 65,
        points = 28
    },
    {
        size = Vector(156, 156),
        offset = Vector(-1, -1),
        radius = 78,
        points = 36
    },
    {
        size = Vector(175, 200),
        offset = Vector(0, -13),
        radius = 87,
        points = 45
    },
    {
        size = Vector(250, 220),
        offset = Vector(17, 0),
        radius = 109,
        points = 55
    },
    {
        size = Vector(250, 250),
        offset = Vector(0, 0),
        radius = 125,
        points = 66
    }
}


-- Accessing values
utils.fruits_config = fruits_magic_nums


return utils