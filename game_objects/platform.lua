local platform = {}

local vector = require "vector"

function platform.new(x, y, x1, x2)
    local self = {}

    self.x, self.y = x, y
    self.x1, self.x2 = x1, x2

    dx, dy = Vector(self.x, self.y):normalize()
    
    end