local Vector = require "vector"
local fruits_config = require "utils".fruits_config

local Fruit = {}

function Fruit.new(pos, id, sprite)
    local self = {}

    self.n = id % 11
    self.sprite = sprite
    self.scale = 2.6
    self.radius = fruits_config[self.n].radius / self.scale
    self.position = pos
    self.shape = HC.circle(pos.x, pos.y, self.radius)

    self.speed_x, self.speed_y = 0, 21
    self.gravity = 300
    self.has_collided = false
    self.sprite:resize(fruits_config[self.n].size.x / self.scale,
         fruits_config[self.n].size.y / self.scale)

    
    
    
    function self.draw()
        local x,y = self.shape:center()
        self.sprite:blit(x-self.radius, y-self.radius)
    end


    return self
end

return Fruit
