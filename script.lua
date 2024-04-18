Vector = require "vector"
Physics = require "physics"
Fruit = require "fruit"

fruit_sprites = {1,2,3,4,5,6,7,8,9,10,11}
current_fruit, next_fruit = math.random(7,11), math.random(7,11)
spawned_fruits = {}

white = Color.create(255, 255, 255, 255)
peach_color = Color.create(241, 224, 129, 255)
Graphics.set_clear_color(white)


BGM = AudioClip.load('./assets/BGM.wav', 1,1)
BGM:play(0)

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
    fruit_diameter_hitbox = {11.303, 10.275, 9.248, 8.22, 7.193, 6.165, 5.138, 4.11, 3.083, 2.055, 1.028}
    -- fruit_radii = {47.851, 43.501, 39.151, 34.801, 30.451, 26.1, 21.75, 17.4, 13.05, 8.7, 7.831}
    fruit_diamerer = {88, 80, 72, 64, 56, 48, 40, 32, 24, 16, 12}
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

end

function draw_fruits()

    for i = #spawned_fruits, 1, -1 do
        if #spawned_fruits > 0 then
            local fruit = spawned_fruits[i]
            fruit_sprites[fruit.fruit_id]:set_position(fruit.position.x, 295-fruit.getCenterPosition().y)

            fruit_sprites[fruit.fruit_id]:draw()
        end
    end
end
    

function process_inputs()
    if Input.button_pressed(PSP_CROSS) then
        current_fruit = next_fruit
        new_fruit = Fruit.new(fruit_diamerer[current_fruit], current_fruit)
        new_fruit.setPosition(line_x, 100)
        spawned_fruits[#spawned_fruits+1] = new_fruit
        next_fruit = math.random(7,11)
    end
end

function update(dt)
    Physics.calculatePhysics(spawned_fruits,  1 / 30 * 1000, 300,300, 272)
    move_cloud(dt)
    process_inputs(dt)
end

function draw(dt)
    bg:draw()
    cloud:draw()
    -- pointer line
    Primitive.draw_rectangle(line, white)
    -- box
    Primitive.draw_rectangle(container_lid, peach_color)
    Primitive.draw_rectangle(container_floor, peach_color)
    draw_fruits()
    -- next fruit bubble pos = (320+90,251-50)
end

timer = Timer.create()
loadsprites()
frames = 0
while QuickGame.running() do
    frames = frames + 1
    Input.update()

    update(timer:delta())
    
    Graphics.start_frame()
    Graphics.clear()
    draw()

    Graphics.end_frame(true)

end