local dust = require"enemies/dust/logic"
local helpers = require"enemies/helpers"

local module = {}


-- Spawn enemies, given total level time
function module.spawn(time)

  if time % 10 == 0 then
    x, y = helpers.random_coordinates()
    dust.spawn(x, y)
  end

end


return module
