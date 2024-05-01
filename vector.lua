local Vector = {}
Vector.__index = Vector


local function new(x, y)
  return setmetatable({x=x or 0, y=y or 0}, Vector)
end

local zero = new(0, 0)

function Vector:__add(v)
  return new(self.x + v.x, self.y + v.y)
end

function Vector:__sub(v)
  return new(self.x - v.x, self.y - v.y)
end

function Vector:__mul(v)
  return new(self.x * v.x + self.y * v.y)
end

function Vector:__div(v)
  return new(self.x / v.x + self.y / v.y)
end

function Vector:__eq(v)
  return self.x == v.x and self.y == v.y
end

function Vector:__tostring()
  return ("<%g, %g>"):format(self.x, self.y)
end

function Vector:dot(v)
  return self.x * v.x + self.y * v.y
end

function Vector:dist(v)
  local dx = self.x - v.x
  local dy = self.y - v.y
  return math.sqrt(dx * dx + dy * dy)
end

function Vector:normalize()
  local dist = self:dist()
  return new(self.x / len, self.y / len)
  

end

return setmetatable({new = new, zero = zero},
	{__call = function(_, ...) return new(...) end})