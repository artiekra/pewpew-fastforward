require"/dynamic/ppol/.lua"
require"globals"
hud = require"hud"

set_level_size(LEVEL_WIDTH, LEVEL_HEIGHT)

ship = new_player_ship(LEVEL_WIDTH/2fx, LEVEL_HEIGHT/2fx)
set_player_ship_weapon(1, cannon_frequency["_15"], cannon_type["triple"])

border = new_entity(LEVEL_WIDTH/2fx, LEVEL_HEIGHT/2fx)
entity_set_mesh(border, "graphics/border/border")

add_wall(0fx, LEVEL_HEIGHT-BEVEL_SIZE, BEVEL_SIZE, LEVEL_HEIGHT)
add_wall(LEVEL_WIDTH-BEVEL_SIZE, 0fx, LEVEL_WIDTH, BEVEL_SIZE)

hud.init()


hud_value = 1
time = 0
function level_tick()
  time = time + 1
  if time % 20 == 0 then
    if hud_value < 2 then
      hud_value = hud_value + 0.01
      hud.set(hud_value)
      set_player_ship_speed(1, 0fx, to_fx((hud_value*100)//10), -1)
    end
  end
end


add_update_callback(level_tick)
