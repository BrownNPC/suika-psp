

fruit = {1,2,3,4,5,6,7,8,9,10,11}

white = Color.create(255, 255, 255, 255)
peach_color = Color.create(245, 215, 129, 255)
Graphics.set_clear_color(white)

BGM = AudioClip.load('./assets/BGM.wav', 1,1)
BGM:play(0)

function loadsprites()
    bgtexinfo = Texture.load('./assets/sprites/wall-bg.png', 1, 0) -- filepath, flip, vram
    bg = Sprite.create(240+18, 256, 516 ,512, bgtexinfo) --idk why these dimensions are correct for 480x272
    

    -- main game sprites
    cloudtexinfo = Texture.load('./assets/sprites/cloud/cloud.png', 1, 0) -- filepath, flip, vram
    cloud = Sprite.create(240, 240, 48 ,48, cloudtexinfo)
    cloud_x, cloud_y = 240, 220
    
    line = Transform.create()
    line:set_scale(1.5,170)
    
    container_lid = Transform.create()
    container_lid:set_scale(152, 4)
    container_lid:set_position(240-10, 220-42)

    -- fruits
    watermelontexinfo = Texture.load('./assets/sprites/fruit/watermelon.png', 1, 0) -- filepath, flip, vram
    fruit[1] = Sprite.create(240, 137, 88 ,88, watermelontexinfo)
    fruit[1]:set_position(240, 137)

    melontexinfo = Texture.load('./assets/sprites/fruit/melon.png', 1, 0) -- filepath, flip, vram
    fruit[2] = Sprite.create(240, 137, 80 ,80, melontexinfo)
    fruit[2]:set_position(240, 137)


    pineappletexinfo = Texture.load('./assets/sprites/fruit/pineapple.png', 1, 0) -- filepath, flip, vram
    fruit[3] = Sprite.create(240, 137, 72 ,72, pineappletexinfo)
    fruit[3]:set_rotation(45) -- sprite is originally diagnal to fit the crown (leaves)
    fruit[3]:set_position(240, 137)

    peachtexinfo = Texture.load('./assets/sprites/fruit/peach.png', 1, 0) -- filepath, flip, vram
    fruit[4] = Sprite.create(240, 137, 64 ,64, peachtexinfo)
    fruit[4]:set_position(240, 137)

    peartexinfo = Texture.load('./assets/sprites/fruit/pear.png', 1, 0) -- filepath, flip, vram
    fruit[5] = Sprite.create(240, 137, 56 ,56, peartexinfo)
    fruit[5]:set_position(240, 137)

    appletexinfo = Texture.load('./assets/sprites/fruit/apple.png', 1, 0) -- filepath, flip, vram
    fruit[6] = Sprite.create(240, 137, 48 ,48, appletexinfo)
    fruit[6]:set_rotation(45) -- sprite is originally diagnal to fit the crown (leaves)
    fruit[6]:set_position(240, 137)

    orangetexinfo = Texture.load('./assets/sprites/fruit/orange.png', 1, 0) -- filepath, flip, vram
    fruit[7] = Sprite.create(240, 137, 40 ,40, orangetexinfo)
    fruit[7]:set_rotation(45) -- sprite is originally diagnal to fit the crown (leaves)
    fruit[7]:set_position(240, 137)

    dekopontexinfo = Texture.load('./assets/sprites/fruit/dekopon.png', 1, 0) -- filepath, flip, vram
    fruit[8] = Sprite.create(240, 137, 32 ,32, dekopontexinfo)
    fruit[8]:set_rotation(45) -- sprite is originally diagnal to fit the crown (leaves)
    fruit[8]:set_position(240, 137)

    grapetexinfo = Texture.load('./assets/sprites/fruit/grape.png', 1, 0) -- filepath, flip, vram
    fruit[9] = Sprite.create(240, 137, 24 ,24, grapetexinfo)
    fruit[9]:set_rotation(45) -- sprite is originally diagnal to fit the crown (leaves)
    fruit[9]:set_position(240, 137)

    
    strawberrytexinfo = Texture.load('./assets/sprites/fruit/strawberry.png', 1, 0) -- filepath, flip, vram
    fruit[10] = Sprite.create(240, 137, 16 ,16, strawberrytexinfo)
    fruit[10]:set_position(240, 137)

    cherrytexinfo = Texture.load('./assets/sprites/fruit/cherry.png', 1, 0) -- filepath, flip, vram
    fruit[11] = Sprite.create(240, 137, 8 ,8, cherrytexinfo)
    fruit[11]:set_position(240, 137)

end

function move_cloud(dt)
    line_x, line_y = cloud_x, cloud_y-110
    if Input.button_held(PSP_LEFT) then
        cloud_x = cloud_x - dt * 200
    end
    if Input.button_held(PSP_RIGHT) then
        cloud_x = cloud_x + dt * 200
    end

    -- left wall
    if cloud_x < 180-20 then
        cloud_x = 180-20
    end
    -- right wall
    if cloud_x > 340-35 then
        cloud_x = 340-35
    end

    line:set_position(line_x, line_y)
    cloud:set_position(cloud_x, cloud_y)

end

function update_fruit()
    
end

function update(dt)
    move_cloud(dt)

end



function draw(dt)
    bg:draw()
    cloud:draw()
    -- pointer line
    Primitive.draw_rectangle(line, white)
    
    -- box
    Primitive.draw_rectangle(container_lid, peach_color)

    -- fruit
    for i = 1, #fruit do -- # means length
        fruit[i]:draw()
    end
end

timer = Timer.create()
loadsprites()
-- reset_game()
while QuickGame.running() do
    Input.update()

    update(timer:delta())

    Graphics.start_frame()
    Graphics.clear()


    draw()

    Graphics.end_frame(true)

end