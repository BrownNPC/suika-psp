local Vector = require "vector"
local physics = {}

-- local g = 9.81
local g = 1
local pi = 3.14159265359

function math.clamp(low, n, high) return math.min(math.max(n, low), high) end

function physics.calculatePhysics(fruits, step, left_wall,right_wall, height)
  for i, fruit in ipairs(fruits) do
    -- check horizontal bounds
    if fruit.position.x + fruit.width >= right_wall or fruit.position.x + fruit.width <= 350 then
      -- bounce from the sides
      fruit.velocity.x = -fruit.velocity.x
    end

    -- check vertical bounds
    if fruit.position.y + fruit.height >= height and fruit.acceleration.y >= 0 then
      -- bounce from the bottom
      fruit.acceleration.y = -(fruit.acceleration.y * 0.1)
      fruit.velocity.y = -fruit.velocity.y
    end

    -- local x_before = fruit.position.x
    -- local y_before = fruit.position.y

    -- local x_prev = fruit.prev_pos.x
    -- local y_prev = fruit.prev_pos.y

    -- fruit.position.y = fruit.position.y 

    -- usual stuff
    local scale = step / 100 --????? why not 1000? t: author
    fruit.acceleration.y = fruit.acceleration.y + scale * g
    fruit.velocity.y = scale * (fruit.velocity.y + fruit.acceleration.y)
    fruit.position.y = fruit.position.y + fruit.velocity.y
    fruit.position.x = fruit.position.x + fruit.velocity.x

    -- keep the fruits from going out of screen bounds
    -- fruit.position.x = math.clamp(0, fruit.position.x, right_wall - fruit.width)
    fruit.position.x = math.clamp(0,fruit.position.x,  left_wall + fruit.width)
    fruit.position.y = math.clamp(0, fruit.position.y, height - fruit.height)

    for j, otherfruit in ipairs(fruits) do
      if i == j then
        goto continue
      end

      -- check for balls touching balls here
      if physics.colliding(fruit, otherfruit) then
        physics.resolveCollision(fruit, otherfruit)
      end
    end


    ::continue::
  end
end

function physics.colliding(fruit, otherfruit)
  local xd = fruit.position.x - otherfruit.position.x
  local yd = fruit.position.y - otherfruit.position.y

  local radiuses = fruit.radius + otherfruit.radius
  local radiusesSquared = radiuses * radiuses
  local distance = (xd * xd) + (yd * yd)

  return distance <= radiusesSquared
end

function physics.resolveCollision(fruit, otherfruit)
  -- from here: http://stackoverflow.com/questions/345838/ball-to-ball-collision-detection-and-handling
  local collision = fruit.getCenterPosition() - otherfruit.getCenterPosition()
  local distance = collision:len()

  local mtdX = collision.x * (((fruit.radius + otherfruit.radius)-distance)/distance)
  local mtdY = collision.y * (((fruit.radius + otherfruit.radius)-distance)/distance)

  -- move the fruits away from each other
  -- fruit.position.x = fruit.position.x + mtdX
  fruit.position.y = fruit.position.y + mtdY

  -- otherfruit.position.x = otherfruit.position.x 
  -- otherfruit.position.y = otherfruit.position.y 

  if distance == 0.0 then
    return
  end

  if distance <= fruit.radius + otherfruit.radius then
    -- resolve fruits being inside each other?
    distance = distance + fruit.radius + otherfruit.radius
  end

  collision.x = collision.x / distance
  collision.y = collision.y / distance

  local aci = fruit.velocity:dot(collision)
  local bci = otherfruit.velocity:dot(collision)

  local acf = bci
  local bcf = aci

  local firstCollision = collision + Vector.zero
  local secondCollision = collision + Vector.zero

  firstCollision.x = firstCollision.x * (acf - aci)
  firstCollision.y = firstCollision.y * (acf - aci)

  secondCollision.x = secondCollision.x * (bcf - bci)
  secondCollision.y = secondCollision.y * (bcf - bci)

  fruit.velocity = fruit.velocity + firstCollision
  otherfruit.velocity = otherfruit.velocity + secondCollision
end

return physics