require"/dynamic/ppol/.lua"
require"globals"

set_level_size(LEVEL_WIDTH, LEVEL_HEIGHT)

ship = new_player_ship(LEVEL_WIDTH/2fx, LEVEL_HEIGHT/2fx)
set_player_ship_weapon(1, cannon_frequency["_15"], cannon_type["triple"])

border = new_entity(LEVEL_WIDTH/2fx, LEVEL_HEIGHT/2fx)
entity_set_mesh(border, "graphics/border/border")


function level_tick()
  -- print("Hi!")
end


add_update_callback(level_tick)
