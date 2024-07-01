local dust = require"entities/enemies/dust/logic"
local flower = require"entities/enemies/flower/logic"
local polygon = require"entities/enemies/polygon/logic"
local darkbaf = require"entities/enemies/darkbaf/logic"
local lightbaf = require"entities/enemies/lightbaf/logic"

local level_time = require"misc/time"
local helpers = require"entities/helpers/general"
local spawn_powerup = require"entities/powerups/spawn"

require"globals/general"
require"helpers/lua_helpers"

local module = {}
module.enemies = {}


-- Initial spawn of the enemies at the start of the level
-- (executed once, before the actual start / first tick of the level)
function module.init_spawn(ship)
  log.info("spawn", "Initial spawn of enemies")

  for i=1, 10 do
    local x, y = helpers.random_coordinates(ship, 50fx, 20fx)
    local enemy = dust.spawn(x, y, fx_random(FX_TAU))
    table.insert(module.enemies, enemy)
  end

  local pu1 = spawn_powerup.spawn_shield_pu(ship)
  local pu2 = spawn_powerup.spawn_score_pu(ship)
  local pu3 = spawn_powerup.spawn_performance_pu(ship)
  local pu4 = spawn_powerup.spawn_slowdown_pu(ship)
  table_insert_all(module.enemies, pu1[1], pu1[2],
    pu2[1], pu2[2], pu3[1], pu3[2], pu4[1], pu4[2])

  local x, y = helpers.random_coordinates(ship, 50fx, 20fx)
  local enemy = polygon.spawn(x, y, fx_random(FX_TAU))
  table.insert(module.enemies, enemy)

  -- local x, y = helpers.random_coordinates(ship, 150fx, 50fx)
  -- score_powerup.spawn(ship, x, y)

end


-- Spawn enemies, given total level time
-- [TODO: better condition, literally everywhere..]
-- [TODO: add a gap to account for precise time being float]
function module.spawn(ship)
  -- local time = level_time.PRECISE_TIME
  local time = level_time.TIME
  log.debug("spawn", "Spawning enemies, time", time)

  ---- Spawn dust
  -- Function graph: https://jpcdn.it/img/5716adb64996deddb9172d1a1542a643.png
  -- [NOTE: might be slow]
  req = 37.5 * (2.71828^(-0.00020362*time))
  -- print(req//1)
  if time % (req//1) == 0 then
    log.trace("spawn", "Spawning dust..")
    local x, y = helpers.random_coordinates(ship, 50fx, 20fx)
    local enemy = dust.spawn(x, y, fx_random(FX_TAU))
    table.insert(module.enemies, enemy)
  end

  -- Spawn polygon 
  if time % 200 == 0 then
    log.trace("spawn", "Spawning polygon..")
    local x, y = helpers.random_coordinates(ship, 50fx, 20fx)
    local enemy = polygon.spawn(x, y, fx_random(FX_TAU))
    table.insert(module.enemies, enemy)
  end

  -- Spawn darkbaf
  if time % 30 == 0 then
    log.trace("spawn", "Spawning darkbaf..")
    local x, y = helpers.random_coordinates(ship, 50fx, 20fx)
    local enemy = darkbaf.spawn(x, y, fx_random(FX_TAU))
    table.insert(module.enemies, enemy)
  end

  -- Spawn lightbaf
  if time % 30 == 0 then
    log.trace("spawn", "Spawning lightbaf (wave)..")
    local x, y = helpers.random_coordinates(ship, 50fx, 20fx)
    local bafs = lightbaf.spawn_wave(random(0, 3), random(3, 8), fx_random(0fx, 500fx))
    table_insert_all(module.enemies, table.unpack(bafs))
  end

  -- Spawn flower
  if time % 200 == 0 then
    log.trace("spawn", "Spawning flower.. (W.I.P.)")
    local x, y = helpers.random_coordinates(ship, 50fx, 20fx)
    -- local enemy = flower.spawn(x, y, fx_random(FX_TAU))
    table.insert(module.enemies, enemy)
  end

  -- Spawn powerups
  if time % 400 == 0 then
    log.trace("spawn", "Spawning powerup..")
    local powerup = spawn_powerup.spawn_powerup(ship, time)
    table_insert_all(module.enemies, table.unpack(powerup))  -- both inner and outer box
  end

end


-- Destroy all enemies and powerups (not _entities_, but *enemies*)
function module.destroy_all_enemies()
  log.info("spawn", "Destroying all the enemies")

  for _, enemy in ipairs(module.enemies) do
    log.trace("spawn", "Got enemy to destroy,", enemy)
    if entity_get_is_alive(enemy) then
      log.trace("spawn", "Enemy", enemy, "is alive, destroying..")
      entity_destroy(enemy)
    end
  end

end


return module
