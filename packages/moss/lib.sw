#![api]

const WIDTH = 240
const HEIGHT = 136

external 100 fn wait_vsync()
external 101 fn set(x: Int, y: Int, palette_index: Int)
external 102 fn clear(palette_index: Int)

struct Gamepad {
    up: Bool,
    down: Bool,
    left: Bool,
    right: Bool,
    a: Bool,
    b: Bool,
    start: Bool,
}

external 103 fn gamepad(player: Int) -> Gamepad
external 104 fn get(x: Int, y: Int) -> Int
external 105 fn sprite(x: Int, y: Int, width: Int, colors: [U8])
external 106 fn box(x: Int, y: Int, width: Int, height: Int, palette_index: Int)
external 107 fn line(x0: Int, y0: Int, x1: Int, y1: Int, palette_index: Int)
external 108 fn sprite_flip(x: Int, y: Int, width: Int, colors: [U8], flip_h: Bool, flip_v: Bool)
external 109 fn circle(x: Int, y: Int, radius: Int, palette_index: Int)
external 110 fn circle_fill(x: Int, y: Int, radius: Int, palette_index: Int)
external 111 fn char(x: Int, y: Int, ch: U8, palette_index: Int)
external 112 fn text(x: Int, y: Int, text: String, palette_index: Int)
external 113 fn box_outline(x: Int, y: Int, width: Int, height: Int, palette_index: Int)


type Voice = Int // 0 to 7
type Note = Int // midi-note
type SoundId = Int // Sound index 0 to 63

struct Adsr {
    /// Attack time in milliseconds
    attack: Int,

    /// Decay time in milliseconds
    decay: Int,

    /// Sustain level (0.0 .. 1.0)
    sustain: Float,

    /// Release time in milliseconds
    release: Int,
}

struct SoundDefinition {
    adsr: Adsr,
    root_note: Note,
    //loops: [(Int, Int)], // sample offsets
}

external 114 fn sound_mono(id: Int, raw: [U8], sound: SoundDefinition)
external 115 fn sound_stereo(id: Int, raw: [U8], sound: SoundDefinition)
external 116 fn note_on(id: Voice, note: Note, sound_id: SoundId, volume: Float)
external 117 fn note_off(id: Voice)
external 118 fn pan(id: Voice, pan: Float)

// ============= Marsh Net =============
struct Net {
    handle: Int,
}

impl Net {
    external 3000 fn new(host: String) -> Net
    external 3001 fn write(mut self, enum_payload: Any)
    external 3002 fn read(mut self, mut emum_payload: Any) -> Bool
}
