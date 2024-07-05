local performance = require"misc/performance"
local helpers = require"entities/helpers/general"
local ch = require"helpers/color_helpers"

require"globals/general"

local flower_module = {}

local entities = {}

-- Some entity globals
local radius = 22.2048fx
local default_health = 7
local rolling_speed = 10fx

-- [NOTE: cant have maximum alpha value,
--  its increased for effect, when hit by bullet]
local colors = {0x009a6590, 0xa700fd90,
  0xe0340090, 0x80808090}

local explosion_color = colors[1]

-- Declaring scheme for entity table
local i_time = 1
local i_speed = 2
local i_angle = 3
local i_dx = 4
local i_dy = 5
local i_health = 6
local i_highlight = 7


-- Function to explode the flower, spawn smaller ones, etc..
-- [TODO: test this on end screen]
function flower_module.destroy_flower(flower_id, color)
  entity_start_exploding(flower_id, 15)
  performance.increase_player_score(5)

  entities[flower_id] = nil

  local x, y = entity_get_pos(flower_id)
  create_explosion(x, y, color, 2fx, 50)
end


-- Function to call every tick on entity
local function update_callback(id)
  local e = entities[id]
  if not e then
    return
  end
  e[i_time] = e[i_time] + 1
  e[i_highlight] = e[i_highlight] - 1

  if not IS_END_SCREEN then
    entity_change_pos(id, e[i_dx], e[i_dy])
    entity_add_mesh_angle(id, rolling_speed * e[i_speed], -e[i_dy], e[i_dx], 0fx)
  end

  -- [TODO: fix highlights not always working]
  local color_state = helpers.get_color_state()
  if color_state then

    if color_state >= 0 then
      color = colors[color_state]
      explosion_color = color
      if e[i_highlight] > 0 then
        entity_set_mesh_color(id, ch.make_color_with_alpha(color, 255))
      else
        entity_set_mesh_color(id, color)
      end

    else
      -- [TODO: consider working with highlights here?]
      explosion_color = END_SCREEN_ENTITY_COLOR
      entity_set_mesh_color(id, END_SCREEN_ENTITY_COLOR)
    end
  end

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
    entity_set_mesh(id, "entities/enemies/flower/mesh")
  end
end


-- Set wall collision callback function for the entity
local function wall_collision(entity_id, wall_normal_x, wall_normal_y)
  local e = entities[entity_id]
  if not e then  -- [TODO: this potentionally not needed?]
    return
  end

  local dx, dy = e[i_dx], e[i_dy]
  local dot_product = dx * wall_normal_x + dy * wall_normal_y
  dx = dx - 2fx * dot_product * wall_normal_x
  dy = dy - 2fx * dot_product * wall_normal_y

  local angle = fx_atan2(dy, dx)
  entity_set_mesh_angle(id, angle, 0fx, 0fx, 1fx)
  e[i_angle] = angle
  e[i_dx] = dx
  e[i_dy] = dy
end


-- Set player collision callback function for the entity
local function player_collision(entity_id, player_id, ship_id)
  if not IS_END_SCREEN then

    local e = entities[entity_id]
    if not e then
      return
    end

    local health = e[i_health]

    if health > 3 then
      damage_player_ship(ship_id, 3)
    else
      damage_player_ship(ship_id, health)
    end
    flower_module.destroy_flower(entity_id, explosion_color)

    entities[entity_id] = nil
    performance.increase_player_score(3)

  end
end


-- Set weapon collision callback function for the entity
local function weapon_collision(entity_id, player_index, weapon)
  local e = entities[entity_id]
  if not e then
    return
  end

  local health = e[i_health]

  if health > 0 then
    if weapon == weapon_type.bullet then
      e[i_health] = health - 1  -- [TODO: assigning to health, reference to array?]
      e[i_highlight] = 5
      if e[i_health] <= 0 then
        flower_module.destroy_flower(entity_id, explosion_color)
      end
    end
  end

  return true
end


-- Spawn entity, add update callback
function flower_module.spawn(x, y, angle, speed)
  local id = new_entity(x, y)
  entity_start_spawning(id, 5)
  entity_set_radius(id, radius)
  helpers.set_entity_color(id, colors)

  local dy, dx = fx_sincos(angle)
  local e = {}
  e[i_time] = 0
  e[i_angle] = angle
  e[i_speed] = speed
  e[i_dx] = dx * speed
  e[i_dy] = dy * speed
  e[i_health] = default_health
  e[i_highlight] = 0

  entity_set_mesh(id, "entities/enemies/flower/mesh")
  entity_set_mesh_angle(id, angle, 0fx, 0fx, 1fx)

  entity_set_update_callback(id, initial_interpolation_fix)
  entity_set_wall_collision(id, true, wall_collision_callback)
  entity_set_player_collision(id, player_collision_callback)
  entity_set_weapon_collision(id, weapon_collision)

  entities[id] = e

  return id 
end


return flower_module
