local Vector = require "vector"
local fruits_config = require "utils".fruits_config
local Fruit = {}

function Fruit.new(pos, id, sprite)
    local self = {}
    self.n = id % 11

    self.sprite = sprite

    -- self.body = chipmunk.body.new(10, 20)
    self.scale = 2.6 -- scale fruit radius from original sizes
    self.radius = fruits_config[self.n].radius / self.scale

    self.shape = HC.circle(pos.x, pos.y, self.radius)


    self.has_collided = false
    self.sprite:resize(fruits_config[self.n].size.x / self.scale, fruits_config[self.n].size.y / self.scale)
    function self.draw()
        local x,y = self.shape:center()
        self.sprite:blit(x,y)

    end
    
    function self.print()
        print(self.acceleration)
        print(self.velocity)
    end
    
    return self
end

return Fruit