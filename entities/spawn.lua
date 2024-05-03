local dust = require"entities/dust/logic"
local helpers = require"entities/helpers"
local spawn_powerup = require"entities/powerups/spawn"

local module = {}

-- Initial spawn of the enemies at the start of the level
-- (executed once, before the actual start / first tick of the level)
function module.init_spawn(ship)

  for i=1, 10 do
    local x, y = helpers.random_coordinates(ship, 50fx, 20fx)
    dust.spawn(x, y, fx_random(FX_TAU))
  end

  spawn_powerup.spawn_shield(ship)

  -- local x, y = helpers.random_coordinates(ship, 150fx, 50fx)
  -- score_powerup.spawn(ship, x, y)

end


-- Spawn enemies, given total level time
function module.spawn(ship, time)

  ---- Spawn dust
  -- Function graph: https://jpcdn.it/img/5716adb64996deddb9172d1a1542a643.png
  -- [TODO: better condition]
  -- [NOTE: might be slow]
  req = 37.5 * (2.71828^(-0.00020362*time))
  -- print(req//1)
  if time % (req//1) == 0 then
    local x, y = helpers.random_coordinates(ship, 50fx, 20fx)
    dust.spawn(x, y, fx_random(FX_TAU))
  end

  ---- Spawn powerups
  -- [TODO: better condition]
  if time % 400 == 0 then
    spawn_powerup.spawn_powerup(ship, time)
  end

end


return module
