require"/dynamic/ppol/.lua"
require"globals"

local hud = require"misc/hud"
local labels = require"misc/labels"
local camera = require"misc/camera"
local enemies = require"entities/spawn"
local rays = require"rays/logic"
local shooting = require"misc/shooting"
local performance = require"misc/performance"

set_level_size(LEVEL_WIDTH, LEVEL_HEIGHT)

local ship = new_player_ship(LEVEL_WIDTH/2fx, LEVEL_HEIGHT/2fx)
set_joystick_color(0x202020ff, 0x202020ff)
set_shield(3)
local ship_speed = 0.99

local border = new_entity(LEVEL_WIDTH/2fx, LEVEL_HEIGHT/2fx)
entity_set_mesh(border, "graphics/border/border")

-- level labels around the border
labels.create_decorations(LEVEL_WIDTH, LEVEL_HEIGHT)

add_wall(0fx, LEVEL_HEIGHT-BEVEL_SIZE, BEVEL_SIZE, LEVEL_HEIGHT)
add_wall(LEVEL_WIDTH-BEVEL_SIZE, 0fx, LEVEL_WIDTH, BEVEL_SIZE)

hud.init()


-- if speed < limit, update it (increment) and change the HUD
function update_ship_speed(speed)
  local increment_val = 0.01
  local limit = 2

  if ship_speed < limit then
    speed = speed + increment_val
    set_player_ship_speed(1, 0fx, to_fx((speed*100)//10), -1)
  end

  return speed
end


time = 0
function level_tick()
  time = time + 1 -- global time variable

  player_x, player_y = entity_get_pos(ship)

  if get_is_lost() == true then
    stop_game()
  end

  -- update ship speed, exponentially
  local speed_upd_condition = ( ( time % (500-((ship_speed-1)*500)) ) // 1 ) == 0
  if speed_upd_condition then
    ship_speed = update_ship_speed(ship_speed)
  end

  camera_z = camera.set_camera_z(camera_z)
  enemies.spawn(ship, time)
  shooting.update(time, player_x, player_y)

  rays.update(ray1, ray2, LEVEL_WIDTH, LEVEL_HEIGHT,
    BEVEL_SIZE, player_x, player_y)

  performance.update(time, get_score())
  hud.update(ship_speed, performance.get())

end


ship_speed = update_ship_speed(ship_speed)
camera_z = 1000fx

ray1, ray2 = rays.create(LEVEL_WIDTH, LEVEL_HEIGHT,
  BEVEL_SIZE, LEVEL_WIDTH/2fx, LEVEL_HEIGHT/2fx)

enemies.init_spawn(ship)

add_update_callback(level_tick)
