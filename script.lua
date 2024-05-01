utils = require "utils"
Objects = require "objects"
Vector = require "vector"
HC = require "hcl.hc"


function init()
    blue = color.new(0, 0, 255)
    peach_color = color.new(241, 224, 129)
    white_color = color.new(255, 255, 255, 180)

    running = true
    timer = timer.new()
    timer:start()
    math.randomseed(1000)
    -- Initialize variables for delta time calculation
    utils.lastFrameTime = timer:time()
    screen_width = 460
    screen_height = 252
    fruit_sprites = {1,2,3,4,5,6,7,8,9,10,11}
    loadsprites()
    
    next_fruit_id = math.random(1,5)
    
    spawned_fruits = {}
    cloud = Objects.cloud.new(Vector(screen_width/2 , 4), 165, 315) --pos, right wall, left wall
    has_collided = true
    floor = HC.rectangle(70, screen_height, screen_width-70, screen_height-22)
    gravity = 600
end

function loadsprites()
    bg_spr = image.load("./assets/sprites/wall-bg.png")
    cloud_spr = image.load('./assets/sprites/cloud/cloud.png')
    cloud_spr:resize(48, 48);

    fruit_sprites[1] = image.load('./assets/sprites/fruit/cherry.png')
    fruit_sprites[2] = image.load('./assets/sprites/fruit/strawberry.png')
    fruit_sprites[3] = image.load('./assets/sprites/fruit/grapes.png')
    fruit_sprites[4] = image.load('./assets/sprites/fruit/dekopon.png')
    fruit_sprites[5] = image.load('./assets/sprites/fruit/orange.png')
    fruit_sprites[6] = image.load('./assets/sprites/fruit/apple.png')
    fruit_sprites[7] = image.load('./assets/sprites/fruit/pear.png')
    fruit_sprites[8] = image.load('./assets/sprites/fruit/peach.png')
    fruit_sprites[9] = image.load('./assets/sprites/fruit/pineapple.png')
    fruit_sprites[10] = image.load('./assets/sprites/fruit/melon.png')
    fruit_sprites[11] = image.load('./assets/sprites/fruit/watermelon.png')
end

function move_cloud(dt)
    
    if controls.left() then
        cloud.move_left(dt)
    end

    if controls.right() then
        cloud.move_right(dt)
    end

    if controls.cross() and has_collided == true then
        local sprite = fruit_sprites[next_fruit_id]
        newfruit = Objects.fruit.new(Vector(cloud.position.x, cloud.position.y), next_fruit_id, sprite)
        spawned_fruits[#spawned_fruits+1] = newfruit
        next_fruit_id = math.random(1,5)
        has_collided = false

    end
end

function physics(dt)
    if #spawned_fruits  then

        for i = 1, #spawned_fruits-1 do
            local fruit = spawned_fruits[i]
            -- local shape = fruit.shape
            for j = i +1, #spawned_fruits do

                local otherfruit = spawned_fruits[j]
                
                local collision, dx, dy = fruit.shape:collidesWith(otherfruit.shape)

                if collision == true then
                    otherfruit.shape:move(-dx, -dy)
                    -- fruit.shape:move(dx, dy)
                    otherfruit.speed_x = -dx  
                    otherfruit.speed_y = -dy + 100  
                    
                    if otherfruit == newfruit then -- allow spawning of new fruits
                        has_collided = true
                    end
                end

            end
        end

        -- gravity and movement and wall+floor collisons
        for i = 1, #spawned_fruits do
            local fruit = spawned_fruits[i]

            fruit.shape:move(fruit.speed_x * dt, fruit.speed_y * dt)

            fruit.speed_y = fruit.speed_y + gravity * dt
            -- check collision with  floor
            local collision, dx, dy = fruit.shape:collidesWith(floor)
            if collision == true then
                fruit.shape:move(dx, dy)
                if fruit == newfruit then -- allow spawning of new fruits
                    has_collided = true
                    fruit.speed_y = 0
                end
            end
            
            -- check collision with walls 
            local x,y = fruit.shape:center()
            if x < 170 then
                fruit.shape:moveTo(170, y)

                -- table.remove(spawned_fruits, i)
            elseif x > 170+140 then
                fruit.shape:moveTo(170+140, y)
                -- table.remove(spawned_fruits, i)
            end

        end
    end
end

    


function update(dt)
    if frames % 2 == 0 then
        physics(dt)
    end
    move_cloud(dt)
    -- chipmunk.space.step(sp, dt)    
end

function draw_sprites(dt)
    bg_spr:blit(0, 0)
    cloud_spr:blit(cloud.position.x, cloud.position.y)

    --guide line
    draw.rect(cloud.position.x,48,1.5,200,white_color);

    for i = 1, #spawned_fruits do
        spawned_fruits[i].draw()
    end
    screen.print(10, 10,  #spawned_fruits, white_color)
    if newfruit then
        screen.print(10, 20,  newfruit.speed_y .. " " .. newfruit.speed_x, white_color)
    end
end


init()
frames = 0
while running do
    controls.read()
    
    -- Calculate delta time

    dt = utils.deltaTime()
    draw_sprites(dt)
    update(dt)
    
    screen.flip()
    frames = frames + 1
    if frames== 60 then
        frames = 0
    end
    screen.waitvblankstart()
end
