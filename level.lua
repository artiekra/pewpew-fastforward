require"/dynamic/ppol/.lua"
require"globals"

local hud = require"misc/hud"
local timer = require"misc/timer"
local labels = require"entities/misc/labels"
local enemies = require"entities/spawn"
local rays = require"entities/rays/logic"
local shooting = require"misc/shooting"
local performance = require"misc/performance"
local angle = require"entities/graphics/angle/logic"
local border = require"entities/graphics/border/logic"

set_level_size(LEVEL_WIDTH, LEVEL_HEIGHT)

local ship = new_player_ship(LEVEL_WIDTH/2fx, LEVEL_HEIGHT/2fx)
set_joystick_colors(0x202020ff, 0x202020ff)
set_shield(3)
local ship_speed = 0.99

border.spawn(LEVEL_WIDTH/2fx, LEVEL_HEIGHT/2fx)

-- add two half-squares (angles), just as a decorative element
angle.spawn(LEVEL_WIDTH, 0fx, 0fx)
angle.spawn(0fx, LEVEL_HEIGHT, FX_TAU/2fx)

-- level labels around the border
labels.create_decorations(LEVEL_WIDTH, LEVEL_HEIGHT)

add_wall(0fx, LEVEL_HEIGHT-BEVEL_SIZE, BEVEL_SIZE, LEVEL_HEIGHT)
add_wall(LEVEL_WIDTH-BEVEL_SIZE, 0fx, LEVEL_WIDTH, BEVEL_SIZE)

hud.init()
local timer_labels = timer.init(LEVEL_WIDTH, LEVEL_HEIGHT)


-- if speed < limit, update it (increment) and change the HUD
function update_ship_speed(speed)
  local increment_val = 0.01
  local limit = 2

  if ship_speed < limit then
    speed = speed + increment_val
    -- set_player_ship_speed(1, 0fx, to_fx((speed*100)//10), -1)
    set_player_ship_speed(1, to_fx((speed*100)//10))
  end

  return speed
end


function get_level_mode(t, a, b)
  local div = t // a
  local m = div * 2
  local remainder = t % a
  if remainder > b then
    m = m + 1
  end

  return m
end


time = 0
function level_tick()
  time = time + 1 -- global time variable

  player_x, player_y = entity_get_pos(ship)

  if get_has_lost() == true then
    stop_game()
  end

  -- update ship speed, exponentially
  local speed_upd_condition = ( ( time % (500-((ship_speed-1)*500)) ) // 1 ) == 0
  if speed_upd_condition then
    ship_speed = update_ship_speed(ship_speed)
  end

  enemies.spawn(ship, time)
  shooting.update(time, player_x, player_y)

  rays.update(ray1, ray2, LEVEL_WIDTH, LEVEL_HEIGHT,
    BEVEL_SIZE, player_x, player_y)

  local player_score = get_score()
  performance.update(time, player_score)
  hud.update(ship_speed, performance.PERFORMANCE)

  timer.update(timer_labels, time)

  local interval = MODE_CHANGE_FREQ - MODE_CHANGE_DURATION
  LEVEL_MODE = get_level_mode(time, MODE_CHANGE_FREQ, interval)
  if LEVEL_MODE > LEVEL_MODE_MAX then
    LEVEL_MODE = LEVEL_MODE_MAX
  end
end


ship_speed = update_ship_speed(ship_speed)

ray1, ray2 = rays.create(LEVEL_WIDTH, LEVEL_HEIGHT,
  BEVEL_SIZE, LEVEL_WIDTH/2fx, LEVEL_HEIGHT/2fx)

enemies.init_spawn(ship)

add_update_callback(level_tick)
