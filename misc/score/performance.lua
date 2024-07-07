local score = require"misc/score/score"

require"globals/general"

local module = {}

module.PERFORMANCE = 1

module.UPGRADE = 1
module.UPGRADE_TIME = 0


-- Bonus (multiplier, actually) for staying near the center
-- (calculate distance, invert, map, offset, average out)
local function get_center_bonus(x, y, mx, my)
  local dist_x = abs(to_int(mx//2fx - x))
  local dist_y = abs(to_int(my//2fx - y))

  local coof_x = dist_x / to_int(mx)
  local coof_y = dist_y / to_int(my)

  local adjusted_x = (1-coof_x)/2.5 + 0.8
  local adjusted_y = (1-coof_y)/2.5 + 0.8

  return (adjusted_x + adjusted_y) / 2
end


-- Update performance multiplier (basic score&time calculation)
-- MUST BE CALLED EACH TICK!
-- [TODO: balance time system]
-- [TODO: at the start of the level, affect performance less]
-- [TODO: consider only accounting for last n seconds (ticks)]
function module.update(time, score, player_x, player_y)
  log.debug("perf", "Updating performance, time", time,
    "and score", score)

  -- [TODO: can use max function from somewhere?... maybe added in ppol later?]
  local min_perf = 1 - (time//300)*0.01
  if min_perf < 0 then
    min_perf = 0
  end

  if module.UPGRADE_TIME ~= 0 then
    module.UPGRADE_TIME = module.UPGRADE_TIME - 1
    module.PERFORMANCE = module.UPGRADE
  else
    local center_bonus = get_center_bonus(player_x, player_y,
      LEVEL_WIDTH, LEVEL_HEIGHT)
    module.PERFORMANCE = ( min_perf + (score/(time*3)) ) * center_bonus
  end
  log.trace("perf", "module.PERFORMANCE =", module.PERFORMANCE)

  return module.PERFORMANCE
end


-- Increase player score, taking performance into account
-- returns current player performance
function module.increase_player_score(value)
  log.debug("perf", "Increasing player score by", value)

  -- internal score counter, so that non-integers scores are possible
  new_score = value * module.PERFORMANCE
  score.increase_score(new_score)

  return module.PERFORMANCE
end


-- Set performance to a new value for a given duration (in ticks)
function module.upgrade(value, time)
  log.debug("perf", "Setting performance to",
    value, "for ticks", time)

  module.UPGRADE = value
  module.UPGRADE_TIME = time
end


return module
