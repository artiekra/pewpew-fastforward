local helpers = require"entities/helpers"
local shield = require"entities/powerups/shield/logic"
local score_powerup = require"entities/powerups/score/logic"

module = {}

-- How far away can powerups spawn from:
-- 1. Player ship (square around ship is blocked)
-- 2. Borders
POWERUP_SPAWN_OFFSETS = {
  shield = {150fx, 50fx},
  score = {150fx, 50fx}
}


-- Get random coordinates and spawn shield powerup
function module.spawn_shield(ship)
  local x, y = helpers.random_coordinates(
    ship, table.unpack(POWERUP_SPAWN_OFFSETS.shield))
  shield.spawn(ship, x, y)
end


-- Get random coordinates and spawn score powerup
function module.spawn_score(ship)
  local x, y = helpers.random_coordinates(
    ship, table.unpack(POWERUP_SPAWN_OFFSETS.score))
  score_powerup.spawn(ship, x, y)
end


-- Chance table for powerups (after preconditions)
POWERUP_SPAWN_WEIGHTS = {
  {100, module.spawn_shield}, {100, module.spawn_score}
}


-- Function for getting weighted random numbers
-- https://www.reddit.com/r/lua/comments/8t0mlf/methods_for_weighted_random_picks/
function module.weighted_random(pool)

  local poolsize = 0
  for k,v in pairs(pool) do
    poolsize = poolsize + v[1]
  end

  local selection = random(1,poolsize)
  for k,v in pairs(pool) do
    selection = selection - v[1] 
    if (selection <= 0) then
      return v[2]
    end
  end

end


-- Uses complex conditions to spawn the correct powerup
function module.spawn_powerup(ship, time)

  -- If player is low on shields, spawn shield powerup
  -- (100% for <2 shields, 50% for <3 shields)
  player_shields = get_shield()
  if player_shields < 2 then
    module.spawn_shield(ship)
    return
  elseif player_shields < 3 then
    if random(0, 1) then
      module.spawn_shield(ship)
      return
    end
  end

  -- No preconditions satisfied, spawn random powerup
  -- (according to chance table)
  local choice = module.weighted_random(POWERUP_SPAWN_WEIGHTS)
  choice(ship)

end

return module
