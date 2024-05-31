local performance = require"misc/performance"
local helpers = require"entities/helpers"

local module = {}

local entities = {}


local radius = 10fx
local speed = 8fx
local spin_speed = 0.1024fx
local colors_light = {0xf9f5f0ff, 0xf5f0f4ff, 0xf4fcf0ff, 0xf0f0f0ff}
local colors_dark = {0x094500ff, 0x450044ff, 0x940c00ff, 0x808080ff}

local i_type = 1
local i_time = 2
local i_angle = 3
local i_dx = 4
local i_dy = 5

local function update_callback(id)
  local e = entities[id]
  if not e then
    return
  end
  e[i_time] = e[i_time] + 1

  entity_change_pos(id, e[i_dx] * speed, e[i_dy] * speed)
  entity_add_mesh_angle(id, spin_speed, e[i_dx], e[i_dy], 0fx)

  helpers.set_entity_color(e[i_time], id, e[i_type] == 1 and colors_light or colors_dark)
end

local function initial_interpolation_fix(id) -- has to be after update_callback due to local visibility
  local e = entities[id]
  if not e then
    return
  end
  e[i_time] = e[i_time] + 1
  if e[i_time] == 2 then
    entity_set_update_callback(id, update_callback)
    entity_set_mesh(id, 'entities/mbaf/mesh')
  end
end

local function wall_collision(id, wall_normal_x, wall_normal_y)
  local e = entities[id]
  local dot_product_move = ((wall_normal_x * e[i_dx]) + (wall_normal_y * e[i_dy])) * 2fx
  e[i_dx] = e[i_dx] - wall_normal_x * dot_product_move
  e[i_dy] = e[i_dy] - wall_normal_y * dot_product_move
  e[i_angle] = fx_atan2(e[i_dy], e[i_dx])
  entity_set_mesh_angle(id, e[i_angle], 0fx, 0fx, 1fx)
end

local function player_collision(entity_id, player_id, ship_id)
  damage_player_ship(ship_id, 1)
  entity_start_exploding(entity_id, 10)
  entities[entity_id] = nil
  performance.increase_player_score(1)
end

local function weapon_collision(entity_id, player_index, weapon)
  if weapon == weapon_type.bullet then
    entity_start_exploding(entity_id, 7)
    entities[entity_id] = nil
    performance.increase_player_score(1)
  end
  return true
end

-- Spawn entity, add update callback
function module.spawn(baf_type, x, y, angle)

  local id = new_entity(x, y)
  entity_start_spawning(id, 0)
  entity_set_radius(id, radius)

  local dy, dx = fx_sincos(angle)
  entity_set_mesh_angle(id, angle, 0fx, 0fx, 1fx)
  
  entities[id] = {baf_type, 0, angle, dx, dy}

  entity_set_update_callback(id, initial_interpolation_fix)
  entity_set_wall_collision(id, true, wall_collision)
  entity_set_player_collision(id, player_collision)
  entity_set_weapon_collision(id, weapon_collision)

  return id
end


return module
