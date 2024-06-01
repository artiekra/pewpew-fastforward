local module = {}

module.PERFORMANCE = 1
module.SCORE = 0

module.UPGRADE = 1
module.UPGRADE_TIME = 0


-- Update performance multiplier (basic score&time calculation)
-- MUST BE CALLED EACH TICK!
-- [TODO: rework time system]
function module.update(time, score)
  if module.UPGRADE_TIME ~= 0 then
    module.UPGRADE_TIME = module.UPGRADE_TIME - 1
    module.PERFORMANCE = module.UPGRADE
  else
    module.PERFORMANCE = 1 + (score/time*5)
  end

  return module.PERFORMANCE
end


-- Increase player score, taking performance into account
function module.increase_player_score(value)

  -- internal score counter, so that non-integers scores are possible
  new_score = value * module.PERFORMANCE
  module.SCORE = module.SCORE + new_score

  new_game_score = module.SCORE // 1
  increase_score(new_game_score - get_score())

  return module.PERFORMANCE
end


-- Set performance to a new value for a given duration (in ticks)
function module.upgrade(value, time)
  print(value, time)

  module.UPGRADE = value
  module.UPGRADE_TIME = time
end


return module
