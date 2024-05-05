require"/dynamic/ppol/.lua"
require"globals"

local hud = require"misc/hud"
local labels = require"misc/labels"
local camera = require"misc/camera"
local enemies = require"entities/spawn"
local rays = require"entities/rays/logic"
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


-- update border colors according to level mode
function update_border_colors()

  function border_update_callback()
    local flicker_speed = 0.1

    if LEVEL_MODE == 0 then
      entity_set_mesh(border, "graphics/border/border", 0)
    elseif LEVEL_MODE == 1 then
      n = random(0, 1)
      if time % (1//flicker_speed) == 0 then  -- make flickering a bit slower
        if n == 0 then
          entity_set_mesh(border, "graphics/border/border", 0)
        else
          entity_set_mesh(border, "graphics/border/border", 1)
        end
      end
    elseif LEVEL_MODE == 2 then
      entity_set_mesh(border, "graphics/border/border", 1)
    end
  end

  entity_set_update_callback(border, border_update_callback)
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
  hud.update(ship_speed, performance.PERFORMANCE)

  local mode_change_end = MODE_CHANGE_START + MODE_CHANGE_DURATION
  if time > MODE_CHANGE_START then
    LEVEL_MODE = 1
    if time > mode_change_end then
      LEVEL_MODE = 2
    end
  end

end


ship_speed = update_ship_speed(ship_speed)
camera_z = 1000fx

ray1, ray2 = rays.create(LEVEL_WIDTH, LEVEL_HEIGHT,
  BEVEL_SIZE, LEVEL_WIDTH/2fx, LEVEL_HEIGHT/2fx)

enemies.init_spawn(ship)

update_border_colors()
add_update_callback(level_tick)
