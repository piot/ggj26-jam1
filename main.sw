use moss::*

const SMALL_PLANET_RADIUS = 30
const CENTER = (WIDTH/2,HEIGHT/2)

struct Planet {
    x: Float,
    y: Float,
}


fn orbit(time: Float, distance: Int) -> (Int, Int) {
        adjusted_time := time * 0.2
        distance_f := distance.float()
        x := (adjusted_time * 28.0).sin() * distance_f
        y := (adjusted_time * 28.0).cos() * distance_f
        ( x.round(), y.round() )
}


mut planets: [Planet; 16]

mut time = 0.0


while true {
    clear(0)
    time += 0.01
    shake := (time * 20.0).sin() * 2.2

    _gamepad := gamepad(0)

    text(20, 30, "hello", 4)

    (center_x, center_y) = CENTER
    adjusted_x := center_x + shake.round()

    circle(adjusted_x, center_y, SMALL_PLANET_RADIUS, 21)

    (planet_x, planet_y) = orbit(time, SMALL_PLANET_RADIUS)
    circle_fill(adjusted_x + planet_x, center_y + planet_y, 6, 29)

 
    // ======= Render =========

    wait_vsync() // display what we rendered and wait
}
