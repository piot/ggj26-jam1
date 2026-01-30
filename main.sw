use moss::*

const SMALL_PLANET_RADIUS = 30
const CENTER = (WIDTH/2,HEIGHT/2)

struct Planet {
    x: Float,
    y: Float,
}

const SKELETON = #include[skel2.bin]
const FLAME = #include[flame.bin]

fn orbit(time: Float, distance: Int) -> (Int, Int) {
        adjusted_time := time * 0.2
        distance_f := distance.float()
        x := (adjusted_time * 28.0).sin() * distance_f
        y := (adjusted_time * 28.0).cos() * distance_f
        ( x.round(), y.round() )
}


mut planets: [Planet; 16]
mut time = 0.0

mut x = 0
mut x_direction = 1
mut tick = 0

while true {
    clear(0)
    time += 0.01
    tick += 1
    shake := (time * 20.0).sin() * 2.2

    _gamepad := gamepad(0)

    text(20, 30, "This is a Longer String, just to see if it works ", 4)

    for idx, mut planet in planets {
        planet.x += idx.float() * 0.1
        planet.y += idx.float() * 0.02
    }

    // Skeleton hover
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
    //sprite(x, 66, 32, SKELETON)

    i := (tick / 4) % 6
    
    sprite_ex(x, 10, 32, 32, i * 32, 192, FLAME)
    //sprite(x, 66, 192, FLAME)

    tiles : [U8; 4] = [
        0x01, 0x00, 0x03, 0x04,
        0x01, 0x00, 0x03, 0x04,
        ]

    tilemap_ex(20, 20, 4, 2,  0,  4, tiles, FLAME)

    // ======= Render =========
    for idx, planet in planets {
        //circle_fill(planet.x.round(), planet.y.round(), 20, idx)
    }
    (center_x, center_y) = CENTER
    adjusted_x := center_x + shake.round()

    circle(adjusted_x, center_y, SMALL_PLANET_RADIUS, 21)

    (planet_x, planet_y) = orbit(time:time, distance:SMALL_PLANET_RADIUS)
    circle_fill(adjusted_x + planet_x, center_y + planet_y, 6, 29)

    wait_vsync() // display what we rendered and wait
}
