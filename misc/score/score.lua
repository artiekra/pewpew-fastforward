require"globals/general"

local module = {}

module.SCORE = 0


-- Sync level score and actual game API score
-- MUST BE CALLED EACH TICK!
-- [TODO: make any score increments smooth?]
function module.update()
  log.debug("score", "Syncing scores")

  new_game_score = module.SCORE // 1
  log.trace("score", "new_game_score =", new_game_score)
  increase_score(new_game_score - get_score())

end


-- Increase player's score
function module.increase_score(v)
  log.debug("score", "Increasing player score by", v)

  module.SCORE = module.SCORE + v
end


return module
