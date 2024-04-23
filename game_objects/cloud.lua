local Cloud = {}

function Cloud.new(position_vec, box_left, box_right)
    local self = {}
    self.position = position_vec

    function self.move_left(dt)
        self.position.x = math.clamp(box_left, self.position.x - dt * 200, self.position.x)
    end
    
    function self.move_right(dt)
        self.position.x = math.clamp(self.position.x, self.position.x + dt * 200, box_right)
    end
    
    return self
end

return Cloud