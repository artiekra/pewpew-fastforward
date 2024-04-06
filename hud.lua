ch = require"helpers/color_helpers"

module = {}


-- Initialise the HUD
function module.init()
  configure_hud_string("#ff0000ffVelocity: ????")
end


-- Set a HUD to new value, also set the right color
function module.set(value)
  local mul = 255 -- multiplier for color

  local nval = ((value-1)*mul) // 1
  color = ch.make_color(nval, 255-nval, 0, 255)
  color_str = ch.color_to_string(color)

  configure_hud_string(color_str .. "Velocity: x" .. value)
end


return module
