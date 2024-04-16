
fruit_sprites = {1,2,3,4,5,6,7,8,9,10,11}
current_fruit, next_fruit = math.random(7,11), math.random(7,11)
spawned_fruits = {}

white = Color.create(255, 255, 255, 255)
peach_color = Color.create(241, 224, 129, 255)
Graphics.set_clear_color(white)
-- file = io.open("./test.txt", "w")
-- file:write("test")
-- file:close()


BGM = AudioClip.load('./assets/BGM.wav', 1,1)
BGM:play(0)

function circlesCollide(x1, y1, r1, x2, y2, r2)
    -- Calculate the distance between the centers of the circles
    local dx = x2 - x1
    local dy = y2 - y1
    local distanceSquared = dx * dx + dy * dy

    -- Calculate the sum of the radii squared
    local radiiSquared = (r1 + r2) * (r1 + r2)

    -- Check if the distance between centers is less than or equal to the sum of the radii
    if distanceSquared <= radiiSquared then
        return true -- Circles collide
    else
        return nil -- Circles do not collide
    end
end
function find_collision_point(circle_center, circle_radius, line)
    -- Calculate the distance between the center of the circle and the line
    -- local distance_to_line = math.abs(circle_center.y - line.y)
    local distance_to_line = circle_center.y - line.y
    
    -- If the distance is less than or equal to the radius, they intersect
    if distance_to_line <= circle_radius then
        -- Calculate the y-coordinate of the intersection point
        local intersection_y = circle_center.y - circle_radius + distance_to_line
        return circle_center.x, intersection_y
    else
        return nil -- No intersection
    end
end


function loadsprites()
    bgtexinfo = Texture.load('./assets/sprites/wall-bg.png', 1, 0) -- filepath, flip, vram
    bg = Sprite.create(240+18, 256, 516 ,512, bgtexinfo) --idk why these dimensions are correct for 480x272
    

    -- main game sprites
    cloudtexinfo = Texture.load('./assets/sprites/cloud/cloud.png', 1, 0) -- filepath, flip, vram
    cloud = Sprite.create(240, 240, 48 ,48, cloudtexinfo)
    cloud_x, cloud_y = 240, 240
    
    line = Transform.create()
    line:set_scale(1.5,200)
    
    container_lid = Transform.create()
    container_lid:set_scale(170, 4)
    container_lid:set_position(242, 251-42)

    container_floor_x, container_floor_y = 242, 18
    container_floor = Transform.create()
    container_floor:set_scale(170, 1)
    container_floor:set_position(container_floor_x, container_floor_y)
    -- fruits
    watermelontexinfo = Texture.load('./assets/sprites/fruit/watermelon.png', 1, 0) -- filepath, flip, vram
    fruit_sprites[1] = Sprite.create(240, 137, 88 ,88, watermelontexinfo)
    fruit_sprites[1]:set_position(240, 137)

    melontexinfo = Texture.load('./assets/sprites/fruit/melon.png', 1, 0) -- filepath, flip, vram
    fruit_sprites[2] = Sprite.create(240, 137, 80 ,80, melontexinfo)
    fruit_sprites[2]:set_position(240, 137)

    pineappletexinfo = Texture.load('./assets/sprites/fruit/pineapple.png', 1, 0) -- filepath, flip, vram
    fruit_sprites[3] = Sprite.create(240, 137, 72 ,72, pineappletexinfo)
    fruit_sprites[3]:set_rotation(45) -- sprite is originally diagnal to fit the crown (leaves)
    fruit_sprites[3]:set_position(240, 137)

    peachtexinfo = Texture.load('./assets/sprites/fruit/peach.png', 1, 0) -- filepath, flip, vram
    fruit_sprites[4] = Sprite.create(240, 137, 64 ,64, peachtexinfo)
    fruit_sprites[4]:set_position(240, 137)

    peartexinfo = Texture.load('./assets/sprites/fruit/pear.png', 1, 0) -- filepath, flip, vram
    fruit_sprites[5] = Sprite.create(240, 137, 56 ,56, peartexinfo)
    fruit_sprites[5]:set_position(240, 137)

    appletexinfo = Texture.load('./assets/sprites/fruit/apple.png', 1, 0) -- filepath, flip, vram
    fruit_sprites[6] = Sprite.create(240, 137, 48 ,48, appletexinfo)
    fruit_sprites[6]:set_rotation(45) -- sprite is originally diagnal to fit the crown (leaves)
    fruit_sprites[6]:set_position(240, 137)

    orangetexinfo = Texture.load('./assets/sprites/fruit/orange.png', 1, 0) -- filepath, flip, vram
    fruit_sprites[7] = Sprite.create(240, 137, 40 ,40, orangetexinfo)
    fruit_sprites[7]:set_rotation(45) -- sprite is originally diagnal to fit the crown (leaves)
    fruit_sprites[7]:set_position(240, 137)

    dekopontexinfo = Texture.load('./assets/sprites/fruit/dekopon.png', 1, 0) -- filepath, flip, vram
    fruit_sprites[8] = Sprite.create(240, 137, 32 ,32, dekopontexinfo)
    fruit_sprites[8]:set_rotation(45) -- sprite is originally diagnal to fit the crown (leaves)
    fruit_sprites[8]:set_position(240, 137)

    grapetexinfo = Texture.load('./assets/sprites/fruit/grape.png', 1, 0) -- filepath, flip, vram
    fruit_sprites[9] = Sprite.create(240, 137, 24 ,24, grapetexinfo)
    fruit_sprites[9]:set_rotation(45) -- sprite is originally diagnal to fit the crown (leaves)
    fruit_sprites[9]:set_position(240, 137)
    
    strawberrytexinfo = Texture.load('./assets/sprites/fruit/strawberry.png', 1, 0) -- filepath, flip, vram
    fruit_sprites[10] = Sprite.create(240, 137, 16 ,16, strawberrytexinfo)
    fruit_sprites[10]:set_position(240, 137)

    cherrytexinfo = Texture.load('./assets/sprites/fruit/cherry.png', 1, 0) -- filepath, flip, vram
    fruit_sprites[11] = Sprite.create(240, 137, 8 ,8, cherrytexinfo)
    fruit_sprites[11]:set_position(240, 137)

    -- (54.375 * fruit y)  / 100 = radius, used in collision detection
    fruit_radii= {47.85, 43.5, 39.15, 34.8, 30.45, 26.1, 21.75, 17.4, 13.05, 8.7, 4.35}
end

function move_cloud(dt)
    line_x, line_y = cloud_x, cloud_y-115
    if Input.button_held(PSP_LEFT) then
        cloud_x = cloud_x - dt * 200
    end
    if Input.button_held(PSP_RIGHT) then
        cloud_x = cloud_x + dt * 200
    end

    -- left wall
    if cloud_x < 180 then
        cloud_x = 180
    end
    -- right wall
    if cloud_x > 380-45 then
        cloud_x = 380-45
    end

    line:set_position(line_x-15, line_y)
    cloud:set_position(cloud_x, cloud_y)
    fruit_sprites[current_fruit]:set_position(line_x-15, cloud_y-15)

end

function spawn_fruit(dt, fruit_id)
    local fruit_data = {
        fruit_id = fruit_id,
        speed_x = 0,
        speed_y = -200,
        x = line_x - 15,
        y = cloud_y-15
    }

    spawned_fruits[#spawned_fruits+1] = fruit_data
end

function drop_fruit(dt)
    if Input.button_pressed(PSP_CROSS)  then
        spawn_fruit(dt, 7)
        
        -- current_fruit, next_fruit = math.random(7,11), math.random(7,11)
        -- end
    end
end

function draw_spawned_fruits()
    fruit_sprites[current_fruit]:set_position(line_x-15, cloud_y-15)
    if #spawned_fruits > 0 then
            -- fruit = spawned_fruits[1]
            for i = 1, #spawned_fruits do
                fruit = spawned_fruits[i]
                fruit_sprites[fruit.fruit_id]:set_position(fruit.x, fruit.y)
                fruit_sprites[fruit.fruit_id]:draw()
            -- return
        end
    end
end

function move_spawned_fruits(dt)
    for i = #spawned_fruits, 1, -1 do
        fruit = spawned_fruits[i]
        radius = fruit_radii[fruit.fruit_id]
        collision_x, collision_y = find_collision_point({x = fruit.x, y = fruit.y}, radius, {y = container_floor_y})
        for j = #spawned_fruits, 1, -1 do
            fruit2 = spawned_fruits[j]
            -- to be implemented
        end
        -- center - line_y - radius = depth
        if not collision_x and not collision_y then

            fruit.y = fruit.y + (fruit.speed_y * dt)
            fruit.speed_y = fruit.speed_y - (gravity * dt)
            
        else
            fruit.y = collision_y - (fruit.y - container_floor_y - radius)
            fruit.speed_y = -fruit_speed_y
            -- fruit.y = fruit.y +(-0.1*fruit.speed_y)  * dt
            



        end
        -- ::continue::
    end
end

gravity = 60
function update(dt)
    drop_fruit(dt)
    move_cloud(dt)
    move_spawned_fruits(dt)

end



function draw(dt)
    bg:draw()
    cloud:draw()
    -- pointer line
    Primitive.draw_rectangle(line, white)
    
    -- box
    Primitive.draw_rectangle(container_lid, peach_color)
    Primitive.draw_rectangle(container_floor, peach_color)

    draw_spawned_fruits()
    
end

timer = Timer.create()
loadsprites()

while QuickGame.running() do
    Input.update()

    update(timer:delta())
    
    Graphics.start_frame()
    Graphics.clear()
    draw()

    Graphics.end_frame(true)

end