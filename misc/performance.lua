local module = {}

PERFORMANCE = 1


function module.get()
  return PERFORMANCE
end

function module.set(value)
  PERFORMANCE = value
  return PERFORMANCE
end

function module.increment(value)
  PERFORMANCE = PERFORMANCE + value
  return PERFORMANCE
end


-- Update performance multiplier (basic score&time calculation)
function module.update(time, score)
  PERFORMANCE = 1 + (score/time*100)
  return PERFORMANCE
end


-- Increase player score, taking performance into account
function module.increase_player_score(value)

  -- [TODO: check if you can use non-integers here]
  new_score = (value * PERFORMANCE) // 1
  increase_score(new_score)

  return PERFORMANCE
end


return module
