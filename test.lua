-- Function to find collision point between a circle and a horizontal line
-- circle_center: table with 'x' and 'y' keys representing the center of the circle
-- circle_radius: radius of the circle
-- line: table representing the horizontal line with 'y' key representing its y-coordinate
function find_collision_point(circle_center, circle_radius, line)
    -- Calculate the distance between the center of the circle and the line
    local distance_to_line = math.abs(circle_center.y - line.y)
    
    -- If the distance is less than or equal to the radius, they intersect
    if distance_to_line <= circle_radius then
        -- Calculate the y-coordinate of the intersection point
        local intersection_y = circle_center.y - circle_radius + distance_to_line
        return circle_center.x, intersection_y
    else
        return nil -- No intersection
    end
end

-- Example usage
circle_center = { x = 5, y = 3 }
circle_radius = 31
line = { y = 8 }

collision_x, collision_y = find_collision_point(circle_center, circle_radius, line)
if collision_x and collision_y then
    print("Collision detected at (" .. collision_x .. ", " .. collision_y .. ")")
else
    print("No collision detected")
end
