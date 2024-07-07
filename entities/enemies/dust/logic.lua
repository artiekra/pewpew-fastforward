local performance = require"misc/performance"
local helpers = require"entities/helpers/general"

require"entities/enemies/keys"
require"globals/general"

local module = {}

local entities = {}


-- Some entity globals
local speed = 1fx
local radius = 2fx
local colors = {0x007a50ff, 0x0248abff,
  0xd17300ff, 0x808080ff}


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

  entity_change_pos(id, e[i_dx] * speed * to_fx(TIME_FACTOR),
                        e[i_dy] * speed * to_fx(TIME_FACTOR))

  helpers.set_entity_color(id, colors)
  --[TODO: implement random rainbow colors]
  -- local color_state = helpers.get_color_state()
  -- if color_state ~= nil then
  --
  --   local color
  --   if color_state >= 0 then
  --     color = colors[color_state]
  --   else
  --     if random(1, 3) == 1 then
  --       color = END_SCREEN_ENTITY_COLOR
  --     else
  --       local hue = random(1, 360)
  --       color = ch.make_color(hsv_to_rgb(hue, 100, 50))
  --     end
  --   end
  --
  --   entity_set_mesh_color(id, color)
  --   end
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
      entity_set_mesh(id, 'entities/enemies/dust/mesh')
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


-- Spawn entity, add update callback
function module.spawn(x, y, angle)

  local id = new_entity(x, y)
  entity_start_spawning(id, 2)
  entity_set_mesh(id, "entities/enemies/dust/mesh")
  entity_set_radius(id, radius)

  local dy, dx = fx_sincos(angle)
  entity_set_mesh_angle(id, angle, 0fx, 0fx, 1fx)

  entities[id] = {0, angle, dx, dy}

  helpers.set_entity_color(id, colors)

  entity_set_update_callback(id, initial_interpolation_fix)
  entity_set_wall_collision(id, true, wall_collision)
  entity_set_player_collision(id, player_collision)

  return id 
end


return module
