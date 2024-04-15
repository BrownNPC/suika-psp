

bird = {0, 1 , 2}

white = Color.create(255, 255, 255, 255)
peach = Color.create(245, 215, 129, 255)
Graphics.set_clear_color(white)

function loadsprites()
    bgtexinfo = Texture.load('./assets/sprites/wall-bg.png', 1, 0) -- filepath, flip, vram
    bg = Sprite.create(240+18, 256, 516 ,512, bgtexinfo) --idk why these dimensions are correct for 480x272

    cloudtexinfo = Texture.load('./assets/sprites/cloud/cloud.png', 1, 0) -- filepath, flip, vram
    cloud = Sprite.create(240, 240, 48 ,48, cloudtexinfo)
    cloud_x, cloud_y = 240, 220

    line = Transform.create()
    line:set_scale(1.5,170)

    container_lid = Transform.create()
    container_lid:set_scale(152, 4)
    container_lid:set_position(240-10, 220-42)

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

function update(dt)
    move_cloud(dt)

end



function draw(dt)
    bg:draw()
    cloud:draw()
    -- pointer line
    Primitive.draw_rectangle(line, white)
    
    -- box
    Primitive.draw_rectangle(container_lid, peach)
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