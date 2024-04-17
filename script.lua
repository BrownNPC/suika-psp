
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

    -- Calculate the sum of the squares of the radii
    local radiiSquared = (r1 * r1) + (r2 * r2)

    -- Check if the distance between centers is less than or equal to the sum of the squares of the radii
    if distanceSquared <= radiiSquared then
        return true -- Circles collide
    else
        return false -- Circles do not collide
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
    fruit_sprites[11] = Sprite.create(240, 137, 12 ,12, cherrytexinfo)
    fruit_sprites[11]:set_position(240, 137)

    -- (54.375 * fruit y)  / 100 = radius, used in collision detection
    fruit_hitbox = {53.145, 48.314, 48.482, 42.651, 33.82, 32.988, 24.157, 19.325, 14.494, 9.663, 7.831}
    -- fruit_radii = {47.851, 43.501, 39.151, 34.801, 30.451, 26.1, 21.75, 17.4, 13.05, 8.7, 7.831}
    fruit_radii = {44.311, 39.101, 35.991, 30.881, 27.771, 23.66, 20.55, 16.44, 13.05, 8.7, 7.831}
end

function move_cloud(dt)
    line_x, line_y = cloud_x, cloud_y-115
    if Input.button_held(PSP_LEFT) then
        cloud_x = cloud_x - dt * 200
    end
    if Input.button_held(PSP_RIGHT) then
        cloud_x = cloud_x + dt * 200
    end
end

function spawn_fruit(dt, fruit_id, x, y)
    x = x == nil and line_x-15 or x
    y = y == nil and cloud_y-15 or y
    local fruit_data = {
        fruit_id = fruit_id,
        speed_x = 0,
        speed_y = -200,
        x = x,
        y = y
    }
    spawned_fruits[#spawned_fruits+1] = fruit_data
end

dropped_fruit = false
drop_fruit_frames = 0
function drop_fruit(dt)
    if dropped_fruit then
        current_fruit = next_fruit
        drop_fruit_frames = drop_fruit_frames + 1
        if drop_fruit_frames > 25 then
            next_fruit = math.random(7,11)
            drop_fruit_frames = 0
            dropped_fruit = false
        end
    end
    if Input.button_held(PSP_CROSS) and not dropped_fruit then
        spawn_fruit(dt, current_fruit)
        dropped_fruit = true
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
        local fruit = spawned_fruits[i]
        local radius = fruit_hitbox[fruit.fruit_id]
        -- Assuming container_floor_y is the y-coordinate of the floor
        
        ::continue::
        -- center - line_y - radius = depth
        radius=fruit_radii[fruit.fruit_id]
        local collision_x, collision_y = find_collision_point({x = fruit.x, y = fruit.y}, radius, {y = container_floor_y})
        if not collision_x and not collision_y then

            -- if fruit.speed_y > 0 then
                -- fruit.speed_y = fruit.speed_y - gravity 
            -- end
            -- fruit.speed_y = fruit.speed_y + (fruit.speed_y/10 * dt)
            fruit.y = fruit.y + (fruit.speed_y * dt)
            -- fruit.y = fruit.x + (fruit.speed_x * dt)
            contact_pos = fruit.y
            
        else

            -- fruit.y = contact_pos
            fruit.y = fruit.y +1
            fruit.speed_y = 0
        end
        -- ::continue::
    end
end

gravity = -1
frames = 0
function update(dt)
    frames = frames + 1
    if frames > 60 then 
        frames = 0
    end
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
    fruit_sprites[current_fruit]:draw()
    draw_spawned_fruits()
    fruit_sprites[next_fruit]:set_position(320+90,251-50) -- next fruit
    fruit_sprites[next_fruit]:draw()
    
end

timer = Timer.create()
loadsprites()
frames = 0
while QuickGame.running() do
    Input.update()

    update(timer:delta())
    
    Graphics.start_frame()
    Graphics.clear()
    draw()

    Graphics.end_frame(true)

end