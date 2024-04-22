local dust = require"enemies/dust/logic"
local helpers = require"enemies/helpers"

local module = {}


-- Spawn enemies, given total level time
function module.spawn(ship, time)

  if time % 10 == 0 then
    x, y = helpers.random_coordinates(ship, 50fx, 20fx)
    dust.spawn(x, y, fx_random(FX_TAU))
  end

end


return module
