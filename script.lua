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
    -- Initialize variables for delta time calculation
    utils.lastFrameTime = timer:time()
    screen_width = 460
    screen_height = 252
    fruit_sprites = {1,2,3,4,5,6,7,8,9,10,11}
    loadsprites()
    
    next_fruit_id = math.random(1,5)
    
    spawned_fruits = {}
    cloud = Objects.cloud.new(Vector(screen_width/2 , 4), 165, 315) --pos, right wall, left wall
    newfruit = {has_collided = true} --initial blank object, will be deleted
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

    if controls.cross() and newfruit.has_collided == true then
        local sprite = fruit_sprites[next_fruit_id]
        newfruit = Objects.fruit.new(Vector(cloud.position.x, cloud.position.y), next_fruit_id, sprite)
        spawned_fruits[#spawned_fruits+1] = newfruit
        next_fruit_id = math.random(1,5)
    end
end

function update(dt)
    -- screen.print(0, 170, dt, blue)
    move_cloud(dt)
    chipmunk.space.step(sp, dt)
    
end

function draw_sprites(dt)
    bg_spr:blit(0, 0)
    cloud_spr:blit(cloud.position.x, cloud.position.y)

    --guide line
    draw.rect(cloud.position.x,48,1.5,200,white_color);

    for i = 1, #spawned_fruits do
        spawned_fruits[i].draw()
    end
end


init()

while running do
    controls.read()
    
    -- Calculate delta time

    dt = utils.deltaTime()
    draw_sprites(dt)
    update(dt)
    
    screen.flip()
    screen.waitvblankstart()
end
