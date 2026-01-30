use moss::*

const SMALL_PLANET_RADIUS = 30
const CENTER = (WIDTH/2,HEIGHT/2 + 15)

struct Planet {
    x: Float,
    y: Float,
}

const SKELETON = #include[skel2.bin]
const FLAME = #include[flame.bin]
const TILEMAP = #include[tilemap.bin]

const AVATAR_SPEED = 1.3

fn orbit(time: Float, distance: Int) -> (Int, Int) {
        adjusted_time := time * 0.2
        distance_f := distance.float()
        x := (adjusted_time * 28.0).sin() * distance_f
        y := (adjusted_time * 28.0).cos() * distance_f
        ( x.round(), y.round() )
}


mut time = 0.0

mut x = 0
mut x_direction = 1
mut tick = 0

mut avatar_x = 0.0
mut avatar_y = 0.0

while true {
    clear(2)
    time += 0.01
    tick += 1
    shake := (time * 20.0).sin() * 2.2

    gamepad := gamepad(0)

    delta_x := 
        | gamepad.left -> -1
        | gamepad.right -> 1
        | _ -> 0    
    
    delta_y := 
        | gamepad.up -> -1
        | gamepad.down -> 1
        | _ -> 0    

    avatar_x += delta_x.float() * AVATAR_SPEED
    avatar_y += delta_y.float() * AVATAR_SPEED

    // lets keep it inside the screen
    // Note: bug in fclamp?

    if avatar_x < 0.0 {
        avatar_x = 0.0
    }

    if avatar_y < 0.0 {
        avatar_y = 0.0
    }

    if avatar_x > 256.0-32.0 {
        avatar_x = 256.0-32.0
    }

    if avatar_y > 144.0-32.0 {
        avatar_y = 144.0-32.0
    }


    x += x_direction
    x =
    | x > 80 -> {
        x_direction = -x_direction
        80
      }
    | x < 10 -> {
        x_direction = -x_direction
        10
    }
    | _ -> {
        x
      }

    set(255, 143, 18)
    sprite(avatar_x.round(), avatar_y.round(), 32, SKELETON)

    i := (tick / 4) % 6

    sprite_ex(200-x, 10, 32, 32, i * 32, 192, FLAME)

    tiles : [U8; 8] = [
        0x01, 0x02, 0x03, 0x04,
        0x05, 27, 28, 29,
    ]

    info := TilemapExParams {
        tile_size: 8,
        tile_offset: 0,
        tile_stride: 4,
        colors_offset: 0,
        colors_width: 216,
    }

    tilemap_ex(0, 0, 4, 2, info, tiles, TILEMAP)


    flame_tiles : [U8; 8] = [
        0x01, 0x02, 0x03,
        0x05, 0x05, 0x05,
    ]

    flame_info := TilemapExParams {
        tile_size: 32,
        tile_offset: 0,
        tile_stride: 3,
        colors_offset: 0,
        colors_width: 192,
    }

    tilemap_ex(120, 80, 3, 2, flame_info, flame_tiles, FLAME)

    // ======= Render =========
    (center_x, center_y) = CENTER
    adjusted_x := center_x - 80 + shake.round()

    circle(adjusted_x, center_y, SMALL_PLANET_RADIUS, 21)

    (planet_x, planet_y) = orbit(time:time, distance:SMALL_PLANET_RADIUS)
    circle_fill(adjusted_x + planet_x, center_y + planet_y, 6, 29)


    text(20, 30, "Global Game Gang", 4)

    members: String<42> = "Vildkatt and Catnipped"


    for idx, ch in members {
        color := idx % 28 + 3
        char(20 + idx * 7, 40, ch, color)
    }

    wait_vsync() // display what we rendered and wait
}
