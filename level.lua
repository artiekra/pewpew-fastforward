-- [TODO: fix logs]
-- [TODO: make any score increments smooth?]
-- [TODO: check caching benefits in implemented places]
-- [TODO: consider smoothing camera on slower time factor?]
-- [TODO: dont pass time as argument anyware, use global time instead]
-- [TODO: deal with potential over-imports? (imorting lib when already done)]

require"/dynamic/libs/ppol/.lua"

require"globals/general"
require"globals/end_screen"

log = require"libs/loglua/log"
log.level = LOG_LEVEL

log.info("main", "Initialized logging, level", LOG_LEVEL)

log.debug("main", "Loading other level files..")
local hud = require"misc/hud"
local events = require"events"
local speed = require"misc/speed"
local time = require"misc/time/time"
local timer = require"misc/time/timer"
local shooting = require"misc/shooting"
local rays = require"entities/rays/logic"
local labels = require"entities/misc/labels"
local time_factor = require"misc/time/factor"
local performance = require"misc/performance"
local enemies = require"entities/spawn/spawn"
local angle = require"entities/graphics/angle/logic"
local border = require"entities/graphics/border/logic"
local end_screen = require"entities/misc/end_screen/spawn"

log.debug("main", "Setting up level environment..")
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


-- Transition from normal gameplay to end screen
function end_screen_transition()
  log.info("main", "Transitioning to end screen..")

  set_joystick_colors(0x101010ff, 0x101010ff)
  time_factor.change_time_factor(0, 20)

  -- enemies.destroy_all_enemies()
  end_screen.show()
  hud.clear()

  camera.set_default_ease()
  camera.ease_function_z = function(dz)
    return dz
  end

  camera.static_x = -LEVEL_WIDTH * 0.2560fx
  camera.static_y = LEVEL_HEIGHT / 2.256fx
  camera.static_z = -1500fx
  camera.static_angle = TILT_ANGLE

  camera.speed = 15fx

end


-- Function called every tick (before the end screen)
function level_tick_normal(time, player_x, player_y)
  log.debug("main", "Executing level_tick_normal()")

  -- update ship speed, exponentially
  local speed_upd_condition = ( ( time % (500-((ship_speed-1)*500)) ) // 1 ) == 0
  if speed_upd_condition then
    speed.update_ship_speed()
    log.info("main", "Player ship speed is updated, now", speed.SPEED)
  end

  enemies.spawn(ship, time)
  shooting.update(player_x, player_y)  -- [NOTE: cannot shoot on end screen]

  local player_score = get_score()
  log.trace("main", "player_score =", player_score)

  performance.update(time, player_score)
  hud.update(speed.SPEED, performance.PERFORMANCE)

  timer.update(timer_labels, time)

  for i, event in ipairs(MODE_CHANGE_EVENTS) do
    if time == event then
      LEVEL_MODE = i*2 - 1
    elseif time == event + MODE_CHANGE_DURATION then
      LEVEL_MODE = i*2
    end
  end
end


-- Function called every tick (at end screen)
function level_tick_end_screen(time)
  log.debug("main", "Executing level_tick_end_screen()")

  -- update ONLY the colors, time is 0
  timer.update(timer_labels, LEVEL_DURATION_TICKS)

  local end_screen_time_passed = time - LEVEL_DURATION_TICKS
  
  -- can be zero, so.. < instead of <=
  if end_screen_time_passed < MODE_CHANGE_DURATION then
    LEVEL_MODE = -1
  else
    LEVEL_MODE = -2
  end
end


-- Function called each tick
local is_player_alive = true
function level_tick()

  time.fast_forward(TIME_FACTOR)
  local time = time.TIME

  log.debug("main", "New tick, time =", time)
  log.trace("main", "IS_END_SCREEN =", IS_END_SCREEN)

  -- before alive check to be able to process even after player death
  events.process_events()

  speed.apply_speed()

  if not is_player_alive then
    return
  end

  player_x, player_y = entity_get_pos(ship)
  log.debug("main", "Player pos:", player_x, player_y)
  if (time >= LEVEL_DURATION_TICKS) and (not IS_END_SCREEN) then
    IS_END_SCREEN = true
    end_screen_transition()
  end

  if not IS_END_SCREEN then
    level_tick_normal(time, player_x, player_y)
  else
    level_tick_end_screen(time)
  end

  rays.update(ray1, ray2, LEVEL_WIDTH, LEVEL_HEIGHT,
    BEVEL_SIZE, player_x, player_y)

  log.trace("main", "LEVEL_MODE =", LEVEL_MODE)

  if get_has_lost() == true then
    log.warn("main", "Player lost, stopping the game..")
    is_player_alive = false

    -- flicker into grey when player dies
    LEVEL_MODE = -1
    events.register_event(MODE_CHANGE_DURATION, function()
      LEVEL_MODE = -2
      hud.clear()
      stop_game()
    end)
  end
end


if MEMORY_PRINT then
  add_memory_print()
end


ray1, ray2 = rays.create(LEVEL_WIDTH, LEVEL_HEIGHT,
  BEVEL_SIZE, LEVEL_WIDTH/2fx, LEVEL_HEIGHT/2fx)

enemies.init_spawn(ship)
time.init()

log.debug("main", "Adding update callback - level tick")
add_update_callback(level_tick)
