local dust = require"entities/dust/logic"
local shield = require"entities/powerups/shield/logic"
local score_powerup = require"entities/powerups/score/logic"
local helpers = require"entities/helpers"

local module = {}


-- Initial spawn of the enemies at the start of the level
-- (executed once, before the actual start / first tick of the level)
function module.init_spawn(ship)

  for i=1, 10 do
    local x, y = helpers.random_coordinates(ship, 50fx, 20fx)
    dust.spawn(x, y, fx_random(FX_TAU))
  end

  local x, y = helpers.random_coordinates(ship, 150fx, 50fx)
  shield.spawn(ship, x, y)

  -- local x, y = helpers.random_coordinates(ship, 150fx, 50fx)
  -- score_powerup.spawn(ship, x, y)

end


-- Spawn enemies, given total level time
function module.spawn(ship, time)

  ---- Spawn dust
  -- Function graph: https://jpcdn.it/img/5716adb64996deddb9172d1a1542a643.png
  req = 37.5 * (2.71828^(-0.00020362*time))
  -- print(req//1)
  if time % (req//1) == 0 then
    local x, y = helpers.random_coordinates(ship, 50fx, 20fx)
    dust.spawn(x, y, fx_random(FX_TAU))
  end

  ---- Spawn powerups
  if time % 400 == 0 then
    local x, y = helpers.random_coordinates(ship, 150fx, 50fx)

    choice = random(0, 1)
    if choice == 0 then
      shield.spawn(ship, x, y)
    elseif choice == 1 then
      score_powerup.spawn(ship, x, y)
    end
  end

end


return module
