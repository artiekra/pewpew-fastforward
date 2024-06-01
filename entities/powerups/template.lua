local helpers = require"entities/helpers"
local arrow = require"entities/powerups/arrow/logic"
local ch = require"helpers/color_helpers"
require"entities/powerups/config"

local module = {}

local entities = {}


local start_dissapearing = 240
local lifetime = 480

local i_box = 1
local i_ibox = 2
local i_colors = 3
local i_time = 4
local i_text = 5
local i_color_state = 6
local i_callback = 7
local i_rgb = 8 -- rgb state index - true if rgb colors should be used

local dc = 5
local function update_rgb(r, g, b, state)
  if state == 1 then
    if r > 0 then
      r = r - dc
      g = g + dc
    else
      state = 2
    end
  elseif state == 2 then
    if g > 0 then
      g = g - dc
      b = b + dc
    else
      state = 3
    end
  else
    if b > 0 then
      b = b - dc
      r = r + dc
    else
      state = 1
    end
  end
  return r, g, b, state
end

local function player_collision(entity_id, player_id, ship_id)
  local x, y = entity_get_pos(ship_id)
  local box = entities[entity_id]
  
  if box[i_rgb] then
    local r, g, b = table.unpack(box[i_colors])
    new_message(x, y, color_to_string(make_color(r, g, b, 255)) .. box[i_text], 1fx, 16)
  else
    new_message(x, y, color_to_string(box[i_colors][3][box[i_color_state]]) .. box[i_text], 1fx, 16)
  end
  
  if box[i_callback] then
    box[i_callback](entity_id, player_id, ship_id)
  end

  play_sound("entities/powerups/sounds/pickup")

  entity_start_exploding(box[i_box], 11)
  entity_start_exploding(box[i_ibox], 11)
  entities[entity_id] = nil
end

local function update_callback(id) -- id == box[i_id] in this case
  local box = entities[id]
  if not box then
    return
  end
  box[i_time] = box[i_time] + 1

  local color_state = helpers.get_color_state(time)
  if color_state then
    box[i_color_state] = color_state
  end
  local outer_color = box[i_colors][1][box[i_color_state]]
  local inner_color = box[i_colors][2][box[i_color_state]]
  
  if box[i_time] < start_dissapearing then
    entity_set_mesh_color(box[i_box], outer_color)
    entity_set_mesh_color(box[i_ibox], inner_color)
    return
  end
  
  if box[i_time] == lifetime then
    entity_destroy(box[i_box])
    entity_destroy(box[i_ibox])
    entities[id] = nil
  else
    local opacity = (lifetime - box[i_time]) * 255 // (lifetime - start_dissapearing)
    entity_set_mesh_color(box[i_box], change_alpha(outer_color, opacity))
    entity_set_mesh_color(box[i_ibox], change_alpha(inner_color, opacity))
  end

end

local function update_callback_rgb(id)
  local box = entities[id]
  if not box then
    return
  end
  box[i_time] = box[i_time] + 1
  box[i_colors] = {update_rgb(table.unpack(box[i_colors]))}
  
  local r, g, b = table.unpack(box[i_colors])
  
  if box[i_time] < start_dissapearing then
    local color = make_color(r, g, b, 255)
    entity_set_mesh_color(box[i_box], color)
    entity_set_mesh_color(box[i_ibox], color)
    return
  end
  
  if box[i_time] == lifetime then
    entity_destroy(box[i_box])
    entity_destroy(box[i_ibox])
    entities[id] = nil
  else
    local opacity = (lifetime - box[i_time]) * 255 // (lifetime - start_dissapearing)
    local color = make_color(r, g, b, opacity)
    entity_set_mesh_color(box[i_box], color)
    entity_set_mesh_color(box[i_ibox], color)
  end
  
end

-- Spawn entity, add update callback
function module.spawn(ship_id, x, y, icon_mesh, text, colors, callback) -- provide nil instead of colors and rgb pallette will be used instead
  
  -- local angle = fx_random(0fx, FX_TAU)
  local angle = 0fx
  local box = new_entity(x, y)
  entity_start_spawning(box, 0)
  entity_set_mesh(box, "entities/powerups/mesh")
  entity_set_radius(box, to_fx(BOX_RADIUS))
  entity_set_mesh_angle(box, angle, 0fx, 0fx, 1fx)

  -- entity for inner shield icon
  local inner_box = new_entity(x, y)
  entity_start_spawning(inner_box, 0)
  entity_set_mesh(inner_box, icon_mesh)
  entity_set_mesh_angle(inner_box, angle, 0fx, 0fx, 1fx)
  
  if colors then
    entities[box] = {box, inner_box, colors, 0, text, 1, callback}
    arrow.add_arrow(ship_id, box, colors[1])
    entity_set_update_callback(box, update_callback)
  else
    entities[box] = {box, inner_box, {255, 0, 0, 1}, 0, text, 1, callback, true}
    arrow.add_arrow(ship_id, box, {0xff0000ff, 0x00ff00ff, 0x0000ffff, 0xffffffff})
    entity_set_update_callback(box, update_callback_rgb)
  end
  
  entity_set_player_collision(box, player_collision)

  return box, inner_box
end


return module
