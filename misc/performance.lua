local module = {}

module.PERFORMANCE = 1
module.SCORE = 0


-- Update performance multiplier (basic score&time calculation)
function module.update(time, score)
  module.PERFORMANCE = 1 + (score/time*10)
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


return module
