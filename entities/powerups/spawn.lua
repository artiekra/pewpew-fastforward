local helpers = require"entities/helpers"
local shield_pu = require"entities/powerups/powerup/shield/logic"
local score_pu = require"entities/powerups/powerup/score/logic"
local performance_pu = require"entities/powerups/powerup/performance/logic"

module = {}

-- How far away can powerups spawn from:
-- 1. Player ship (square around ship is blocked)
-- 2. Borders
POWERUP_SPAWN_OFFSETS = {
  shield = {150fx, 50fx},
  score = {150fx, 50fx},
  performance = {150fx, 50fx}
}


-- Get random coordinates and spawn shield powerup
function module.spawn_shield_pu(ship)
  local x, y = helpers.random_coordinates(
    ship, table.unpack(POWERUP_SPAWN_OFFSETS.shield))
  shield_pu.spawn(ship, x, y)
end


-- Get random coordinates and spawn score powerup
function module.spawn_score_pu(ship)
  local x, y = helpers.random_coordinates(
    ship, table.unpack(POWERUP_SPAWN_OFFSETS.score))
  score_pu.spawn(ship, x, y)
end


-- Get random coordinates and spawn performance powerup
function module.spawn_performance_pu(ship)
  local x, y = helpers.random_coordinates(
    ship, table.unpack(POWERUP_SPAWN_OFFSETS.performance))
  performance_pu.spawn(ship, x, y)
end


-- Chance table for powerups (after preconditions)
POWERUP_SPAWN_WEIGHTS = {
  {100, module.spawn_shield}, {100, module.spawn_score},
  {100, module.spawn_performance}
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


-- https://www.reddit.com/r/lua/comments/mcen99/how_to_deal_with_lua_tables_copies_and_not_mess/
function module.shallow_table_copy(maintable)

  local tablecopy = {}
  for k, v in pairs(maintable) do
    tablecopy[k] = v
  end

  return tablecopy
end


-- Uses complex conditions to spawn the correct powerup
function module.spawn_powerup(ship, time)

  -- If player is low on shields, spawn shield powerup
  -- (100% for <2 shields, 50% for <3 shields)
  player_shields = get_shield()
  if player_shields < 2 then
    module.spawn_shield_pu(ship)
    return
  elseif player_shields < 3 then
    if random(0, 1) then
      module.spawn_shield_pu(ship)
      return
    end
  end

  -- No preconditions satisfied, spawn random powerup
  -- (according to chance table)
  local choice = module.weighted_random(POWERUP_SPAWN_WEIGHTS)
  choice(ship)

end

return module
