local performance = require"misc/performance"
local helpers = require"entities/helpers/general"

require"entities/enemies/lightbaf/config"
require"entities/enemies/keys"
require"globals/general"

local module = {}

local entities = {}


-- Declaring scheme for entity table
local i_time = 1
local i_angle = 2
local i_dx = 3
local i_dy = 4


-- Function to call every tick on entity
local function update_callback(id)
  local e = entities[id]
  if not e then
    return
  end
  e[i_time] = e[i_time] + 1

  entity_change_pos(id, e[i_dx] * SPEED * to_fx(TIME_FACTOR),
                        e[i_dy] * SPEED * to_fx(TIME_FACTOR))
  entity_add_mesh_angle(id, SPIN_SPEED, e[i_dx], e[i_dy], 0fx)

  helpers.set_entity_color(id, COLORS)
end


-- Fixing interpolation at first 2 ticks
-- has to be after update_callback due to local visibility
local function initial_interpolation_fix(id)
  local e = entities[id]
  if not e then
    return
  end
  e[i_time] = e[i_time] + 1
  if e[i_time] == 2 then
    entity_set_update_callback(id, update_callback)
    entity_set_mesh(id, 'entities/enemies/lightbaf/mesh')
  end
end


-- Set wall collision callback function for the entity
local function wall_collision(id, wall_normal_x, wall_normal_y)
  entities[id] = nil
  entity_start_exploding(id, 10)
end


-- Set player collision callback function for the entity
local function player_collision(entity_id, player_id, ship_id)
  if not IS_END_SCREEN then
    damage_player_ship(ship_id, 1)
    entity_start_exploding(entity_id, 10)
    entities[entity_id] = nil
    performance.increase_player_score(1)
  end
end


-- Set weapon collision callback function for the entity
local function weapon_collision(entity_id, player_index, weapon)
  if weapon == weapon_type.bullet then
    entity_start_exploding(entity_id, 7)
    entities[entity_id] = nil
    performance.increase_player_score(1)
  end
  return true
end


-- Spawn entity, add update callback
function module.spawn(x, y, angle)

  local id = new_entity(x, y)
  entity_start_spawning(id, 2)
  entity_set_radius(id, RADIUS)

  local dy, dx = fx_sincos(angle)
  entity_set_mesh_angle(id, angle, 0fx, 0fx, 1fx)
  
  entities[id] = {0, angle, dx, dy}

  helpers.set_entity_color(id, COLORS)

  entity_set_update_callback(id, initial_interpolation_fix)
  entity_set_wall_collision(id, true, wall_collision)
  entity_set_player_collision(id, player_collision)
  entity_set_weapon_collision(id, weapon_collision)

  return id
end


-- Spawn a wave of light bafs
-- [TODO: prevent bafs from spawning in bevels]
function module.spawn_wave(side, baf_n, offset)
  local baf_margin = 20fx

  local bafs = {}

  local lh = LEVEL_HEIGHT
  local lw = LEVEL_WIDTH
  -- local bs = BEVEL_SIZE  -- needed to prevent going out of bevel when using offset..
  -- [TODO: add margins to prevent wall collisions right away here?]
  for i=1, baf_n do

    if side == 0 then
      x = i*baf_margin + offset
      y = 0fx
    elseif side == 1 then
      x = LEVEL_WIDTH
      y = LEVEL_HEIGHT - i*baf_margin - offset
    elseif side == 2 then
      x = LEVEL_WIDTH - i*baf_margin - offset
      y = LEVEL_HEIGHT
    elseif side == 3 then
      x = 0fx
      y = i*baf_margin + offset
    end

    local angle = (side+1) * (FX_TAU/4fx)
    local baf = module.spawn(x, y, angle)
    table.insert(bafs, baf)
  end

  return bafs
end


return module
