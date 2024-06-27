local ch = require"helpers/color_helpers"

local module = {}


-- Initialise the HUD
-- [TODO: fix grammar]
function module.init()
  log.info("hud", "Initializing the HUD")
  set_hud_string("#ff0000ffLoading...")
end


-- Set a HUD to new value, also set the right color
-- [TODO: make it rainbow on end screen?]
function module.update(velocity, performance)
  log.debug("hud", "Updating hud for velocity", velocity,
    "and performance", performance)

  local mul = 255 -- multiplier for color

  local nvel = ((velocity-1)*mul) // 1
  local vel_color = ch.make_color(nvel, 255-nvel, 0, 255)
  local vel_color_str = ch.color_to_string(vel_color)

  if performance < 1 then
    local nperf = (performance*mul) // 1
    local perf_color = ch.make_color(255-nperf, nperf, 0, 255)
    perf_color_str = ch.color_to_string(perf_color)
  else
    perf_color_str = "#00ff00ff"
  end
  log.trace("hud", "perf_color_str =", perf_color_str)

  local velocity_str = vel_color_str .. string.format("⚡ x%.2f", velocity)
  local performance_str = perf_color_str .. string.format("👁 x%.2f", performance)
  local hud_string = velocity_str .. "  " .. performance_str

  log.trace("hud", "hud_string =", hud_string)
  set_hud_string(hud_string)
end


return module
