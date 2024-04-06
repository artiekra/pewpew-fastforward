require"/dynamic/ppol/.lua"
require"globals"
hud = require"hud"

set_level_size(LEVEL_WIDTH, LEVEL_HEIGHT)

ship = new_player_ship(LEVEL_WIDTH/2fx, LEVEL_HEIGHT/2fx)
set_player_ship_weapon(1, cannon_frequency["_15"], cannon_type["triple"])
set_joystick_color(0x202020ff, 0x202020ff)
set_shield(3)
ship_speed = 0.99

border = new_entity(LEVEL_WIDTH/2fx, LEVEL_HEIGHT/2fx)
entity_set_mesh(border, "graphics/border/border")

add_wall(0fx, LEVEL_HEIGHT-BEVEL_SIZE, BEVEL_SIZE, LEVEL_HEIGHT)
add_wall(LEVEL_WIDTH-BEVEL_SIZE, 0fx, LEVEL_WIDTH, BEVEL_SIZE)

hud.init()


-- if speed < limit, update it (increment) and change the HUD
function update_ship_speed(speed)
  increment_val = 0.01
  limit = 2

  if ship_speed < limit then
    speed = speed + increment_val
    hud.set(speed)
    set_player_ship_speed(1, 0fx, to_fx((speed*100)//10), -1)
  end

  return speed
end


-- only executed once, when level is created
function startup()
  ship_speed = update_ship_speed(ship_speed)
end


time = 0
function level_tick()
  time = time + 1 -- global time variable

  -- update ship speed, exponentially
  local speed_upd_condition = ( ( time % (500-((ship_speed-1)*500)) ) // 1 ) == 0
  if speed_upd_condition then
    ship_speed = update_ship_speed(ship_speed)
  end

end


startup()
add_update_callback(level_tick)
