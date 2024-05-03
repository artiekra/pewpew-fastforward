local ch = require"helpers/color_helpers"

local module = {}


-- Initialise the HUD
function module.init()
  configure_hud_string("#ff0000ffLoading...")
end


-- Set a HUD to new value, also set the right color
function module.update(velocity, performance)
  local mul = 255 -- multiplier for color

  local nvel = ((velocity-1)*mul) // 1
  local vel_color = ch.make_color(nvel, 255-nvel, 0, 255)
  local vel_color_str = ch.color_to_string(vel_color)

  local nperf = ((performance-1)*mul) // 1
  local perf_color = ch.make_color(nperf, 255-nperf, 0, 255)
  local perf_color_str = ch.color_to_string(perf_color)

  local velocity_str = vel_color_str .. string.format("⚡ x%.2f", velocity)
  local performance_str = perf_color_str .. string.format("👁 x%.2f", performance)
  configure_hud_string(velocity_str .. "  " .. performance_str)
end


return module
