local dust = require"enemies/dust/logic"
local helpers = require"enemies/helpers"

local module = {}


-- Initial spawn of the enemies at the start of the level
-- (executed once, before the actual start / first tick of the level)
function module.init_spawn(ship)

  for i=1, 10 do
    x, y = helpers.random_coordinates(ship, 50fx, 20fx)
    dust.spawn(x, y, fx_random(FX_TAU))
  end

end


-- Spawn enemies, given total level time
function module.spawn(ship, time)

  -- Function graph: https://jpcdn.it/img/5716adb64996deddb9172d1a1542a643.png
  req = 37.5 * (2.71828^(-0.00020362*time))
  print(req//1)
  if time % (req//1) == 0 then
    x, y = helpers.random_coordinates(ship, 50fx, 20fx)
    dust.spawn(x, y, fx_random(FX_TAU))
  end

end


return module
