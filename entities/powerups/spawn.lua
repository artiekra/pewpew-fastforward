local helpers = require"entities/helpers/general"
local shield_pu = require"entities/powerups/powerup/shield/logic"
local score_pu = require"entities/powerups/powerup/score/logic"
local performance_pu = require"entities/powerups/powerup/performance/logic"
local slowdown_pu = require"entities/powerups/powerup/slowdown/logic"
local fastforward_pu = require"entities/powerups/powerup/fastforward/logic"

pu_spawn_module = {}


-- How far away can powerups spawn from:
-- 1. Player ship (square around ship is blocked)
-- 2. Borders
POWERUP_SPAWN_OFFSETS = {
  shield = {150fx, 50fx},
  score = {150fx, 50fx},
  performance = {150fx, 50fx},
  slowdown = {150fx, 50fx},
  fastforward = {250fx, 100fx}
}


-- [TODO: automatically recognise module name too here?]
local function register_spawn_pu_func(name, module, ...)
  local func_args = {...}

  pu_spawn_module["spawn_" .. name .. "_pu"] = function(ship)
    local x, y = helpers.random_coordinates(
      ship, table.unpack(POWERUP_SPAWN_OFFSETS[name]))
    local powerup_outer, powerup_inner = module.spawn(
      ship, x, y, table.unpack(func_args))

    return {powerup_outer, powerup_inner}
  end

end


register_spawn_pu_func("fastforward", fastforward_pu)
register_spawn_pu_func("slowdown", slowdown_pu)
register_spawn_pu_func("performance", performance_pu, random(1, 3))
register_spawn_pu_func("score", score_pu)
register_spawn_pu_func("shield", shield_pu)


-- Chance table for powerups (after preconditions)
POWERUP_SPAWN_WEIGHTS = {
  {100, pu_spawn_module.spawn_shield_pu},
  {100, pu_spawn_module.spawn_score_pu},
  {100, pu_spawn_module.spawn_performance_pu},
  {100, pu_spawn_module.spawn_slowdown_pu},
  {100, pu_spawn_module.spawn_fastforward_pu}
}


-- Function for getting weighted random numbers
-- https://www.reddit.com/r/lua/comments/8t0mlf/methods_for_weighted_random_picks/
function pu_spawn_module.weighted_random(pool)

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
function pu_spawn_module.shallow_table_copy(maintable)

  local tablecopy = {}
  for k, v in pairs(maintable) do
    tablecopy[k] = v
  end

  return tablecopy
end


-- Uses complex conditions to spawn the correct powerup
function pu_spawn_module.spawn_powerup(ship, time)

  -- If player is low on shields, spawn shield powerup
  -- (100% for <2 shields, 50% for <3 shields)
  player_shields = get_shield()
  if player_shields < 2 then
    local powerup = pu_spawn_module.spawn_shield_pu(ship)
    return powerup
  elseif player_shields < 3 then
    if random(0, 1) then
      local powerup = pu_spawn_module.spawn_shield_pu(ship)
      return powerup
    end
  end

  -- No preconditions satisfied, spawn random powerup
  -- (according to chance table)
  local choice = pu_spawn_module.weighted_random(POWERUP_SPAWN_WEIGHTS)
  powerup = choice(ship)
  
  return powerup
end


return pu_spawn_module
