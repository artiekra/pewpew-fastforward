local performance = require"misc/performance"
local helpers = require"entities/helpers/general"

require"globals/general"

local module = {}

local entities = {}

-- Some entity globals
local speed = 10fx
local radius = 5fx
local colors = {0x00ff00ff, 0x8000ffff,
  0xff0000ff, 0x808080ff}

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

  if not IS_END_SCREEN then
    entity_change_pos(id, e[i_dx] * speed, e[i_dy] * speed)
  end

  helpers.set_entity_color(e[i_time], id, colors)
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
    entity_set_mesh(id, 'entities/enemies/polygon/bullets/mesh')
  end
end


-- Set wall collision callback function for the entity
local function wall_collision(id, wall_normal_x, wall_normal_y)
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


-- Spawn entity, add update callback
function module.spawn(x, y, angle)

  local id = new_entity(x, y)
  entity_start_spawning(id, 0)
  entity_set_radius(id, radius)

  local dy, dx = fx_sincos(angle)
  entity_set_mesh_angle(id, angle, 0fx, 0fx, 1fx)

  entities[id] = {0, angle, dx, dy}

  helpers.set_entity_color(0, id, colors)

  entity_set_update_callback(id, initial_interpolation_fix)
  entity_set_wall_collision(id, true, wall_collision)
  entity_set_player_collision(id, player_collision)

  return id
end


return module
