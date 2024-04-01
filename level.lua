require"/dynamic/ppol/.lua"
require"globals"

set_level_size(LEVEL_WIDTH, LEVEL_HEIGHT)

ship = new_player_ship(LEVEL_WIDTH/2fx, LEVEL_HEIGHT/2fx)
set_player_ship_weapon(1, cannon_frequency["_15"], cannon_type["triple"])

border = new_entity(0fx, 0fx)
entity_set_mesh(border, "border")

add_memory_print()
