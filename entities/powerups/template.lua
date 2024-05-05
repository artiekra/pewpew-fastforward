local helpers = require"entities/helpers"
local fm = require"helpers/floating_message"
require"entities/powerups/config"

local module = {}


-- Spawn entity, add update callback
function module.spawn(ship_id, x, y, icon_mesh, text, colors, callback)
  local start_dissapearing = 240  -- 480 maybe or smth?
  local stop_dissapearing = 480

  local outer_colors = colors[1]
  local inner_colors = colors[2]
  local text_colors = colors[3]

  local box = new_entity(x, y)
  entity_start_spawning(box, 2)
  entity_set_mesh(box, "entities/powerups/mesh")
  entity_set_radius(box, to_fx(BOX_RADIUS))

  -- entity for inner shield icon
  local inner_box= new_entity(x, y)
  entity_start_spawning(inner_box, 2)
  entity_set_mesh(inner_box, icon_mesh)
  entity_set_radius(inner_box, to_fx(BOX_RADIUS))

  local box_time = 0
  function box_update_callback()  -- [TODO: add args??]
    box_time = box_time + 1
    if box_time >= start_dissapearing then
      local total = stop_dissapearing - start_dissapearing
      local time_left = stop_dissapearing - box_time
      local opacity = (time_left * 255) // total

      -- [TODO: check if entity exists]
      if opacity > 0 then
        entity_set_mesh_color(box, 0xffffff00 + opacity)
        entity_set_mesh_color(inner_box, 0xffffff00 + opacity)
      else
        entity_destroy(box)
        entity_destroy(inner_box)
      end
    end

    -- [TODO: sync changing outer and inner color?]
    outer_color = helpers.get_mesh_color(box_time, table.unpack(outer_colors))
    if outer_color ~= nil then
      entity_set_mesh_color(box, outer_color)
    end

    inner_color = helpers.get_mesh_color(box_time, table.unpack(inner_colors))
    if inner_color ~= nil then
      entity_set_mesh_color(inner_box, inner_color)
    end

  end

  function box_player_collision(entity_id, player_id, ship_id)
    x, y = entity_get_pos(ship_id)

    if LEVEL_MODE == 0 then    
      pu = fm.new(x, y, text, 1fx, text_colors[1], 16)
    else
      pu = fm.new(x, y, text, 1fx, text_colors[2], 16)
    end

    play_sound("entities/powerups/sounds/pickup")

    entity_start_exploding(entity_id, 11)
  end

  function inner_box_player_collision(entity_id, player_id, ship_id)
    callback(entity_id, player_id, ship_id)
    entity_destroy(inner_box)
  end

  -- [TODO: custom arrows?]
  add_arrow(ship_id, box, 0x002902ff)

  entity_set_update_callback(box, box_update_callback)
  entity_set_player_collision(box, box_player_collision)
  entity_set_player_collision(inner_box, inner_box_player_collision)

  return shield
end


return module
