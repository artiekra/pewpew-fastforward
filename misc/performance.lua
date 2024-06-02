local module = {}

module.PERFORMANCE = 1
module.SCORE = 0

module.UPGRADE = 1
module.UPGRADE_TIME = 0


-- Update performance multiplier (basic score&time calculation)
-- MUST BE CALLED EACH TICK!
-- [TODO: rework time system]
function module.update(time, score)
  -- [TODO: can use max function from somewhere?... maybe added in ppol later?]
  local min_perf = 1 - (time//300)*0.01
  if min_perf < 0 then
    min_perf = 0
  end
  
  if module.UPGRADE_TIME ~= 0 then
    module.UPGRADE_TIME = module.UPGRADE_TIME - 1
    module.PERFORMANCE = module.UPGRADE
  else
    module.PERFORMANCE = min_perf + (score/time*3)
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
